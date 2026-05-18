package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.*;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.statement.Query;
import java.util.List;
import java.util.Map;

public class OrderDao extends BaseDao {

    public int placeOrder(User user, UserAddress address, String shipMethod,
                          long shipFee, String payMethod, double finalTotal, Cart orderCart) {

        return get().inTransaction(handle -> {
            int orderId = insertOrder(handle, user, address, payMethod, shipFee, finalTotal);

            insertOrderItems(handle, orderId, orderCart);

            return orderId; // Trả về ID để Servlet dùng gửi sang VNPAY
        });
    }

    private int insertOrder(Handle handle, User user, UserAddress address,
                            String payMethod, long shipFee, double finalTotal) {
        return handle.createUpdate(
                        "INSERT INTO orders (user_id, customer_name, customer_phone, shipping_address, " +
                                "payment_method, shipping_fee, total_price, status_payment, status_transport, created_at) " +
                                "VALUES (:userId, :name, :phone, :address, :payMethod, :shipFee, :total, 0, 0, NOW())")
                .bind("userId", user.getId())
                .bind("name", address.getFullName())
                .bind("phone", address.getPhone())
                .bind("address", address.getAddress())
                .bind("payMethod", payMethod)
                .bind("shipFee", shipFee)
                .bind("total", finalTotal)
                .executeAndReturnGeneratedKeys()
                .mapTo(Integer.class)
                .one();
    }

    // dùng prepared batch để tăng hiệu suất
    private void insertOrderItems(Handle handle, int orderId, Cart orderCart) {
        var itemBatch = handle.prepareBatch(
                "INSERT INTO order_items (order_id, product_id, product_name, original_price, price, quantity) " +
                        "VALUES (:orderId, :prodId, :prodName, :originalPrice, :price, :qty)");

        var stockBatch = handle.prepareBatch(
                "UPDATE products " +
                        "SET quantity = quantity - :qty, " +
                        "    sold_quantity = sold_quantity + :qty " +
                        "WHERE id = :prodId AND quantity >= :qty");

        for (CartItem item : orderCart.getItems()) {
            itemBatch.bind("orderId", orderId)
                    .bind("prodId", item.getProduct().getId())
                    .bind("prodName", item.getProduct().getName())
                    .bind("originalPrice", item.getOriginalPrice())
                    .bind("price", item.getDiscountPrice())
                    .bind("qty", item.getQuantity())
                    .add();

            stockBatch.bind("prodId", item.getProduct().getId())
                    .bind("qty", item.getQuantity())
                    .add();
        }

        itemBatch.execute();
        stockBatch.execute();
    }

    public List<Map<String, Object>> findOrdersByUser(int userId) {
        String sql = """
        SELECT 
            o.id, 
            o.total_price, 
            o.status_transport, 
            o.status_payment, 
            o.created_at,
            r.status AS refund_status,
            r.reason AS refund_reason_admin
        FROM orders o
        LEFT JOIN refunds r ON o.id = r.order_id
        WHERE o.user_id = :user_id
        ORDER BY o.id DESC
    """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("user_id", userId)
                        .mapToMap()
                        .list()
        );
    }

    public List<Map<String, Object>> findItemsByOrder(int orderId) {
        String sql = """
        SELECT 
            oi.product_name, 
            oi.original_price,
            oi.price AS discount_price,
            oi.quantity, 
            (oi.price * oi.quantity) AS total_item_price,
            p.image AS product_image
        FROM order_items oi
        LEFT JOIN products p ON oi.product_id = p.id
        WHERE oi.order_id = :order_id
        ORDER BY oi.id ASC
    """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("order_id", orderId)
                        .mapToMap()
                        .list()
        );
    }

    public boolean cancelOrder(int orderId, int userId, String reason) {
        return get().inTransaction(handle -> {
            // lấy tiền và phương thức
            Map<String, Object> order = handle.createQuery(
                            "SELECT total_price, payment_method, status_payment FROM orders WHERE id = :id AND user_id = :uId")
                    .bind("id", orderId)
                    .bind("uId", userId)
                    .mapToMap()
                    .findOne().orElse(null);

            if (order == null) return false;

            String sql = """
        UPDATE orders
        SET status_transport = 4
        WHERE id = :id
          AND user_id = :user_id
          AND status_transport = 0
    """;

            int updated = handle.createUpdate(sql)
                            .bind("id", orderId)
                            .bind("user_id", userId)
                            .execute();

            if (updated <= 0) return false;

            String paymentMethod = (String) order.get("payment_method");
            int statusPayment = ((Number) order.get("status_payment")).intValue();
            double totalPrice = ((Number) order.get("total_price")).doubleValue();

            if ("e-wallet".equalsIgnoreCase(paymentMethod) && statusPayment == 1) {
                handle.createUpdate("INSERT INTO refunds (order_id, amount, reason, status) " +
                                "VALUES (:oid, :amount, :reason, 0)")
                        .bind("oid", orderId)
                        .bind("amount", totalPrice)
                        .bind("reason", "Hủy đơn hàng: " + reason)
                        .execute();
            }

            // lấy ds sp và số lượng từ đơn này
            List<Map<String, Object>> items = handle.createQuery(
                                    "SELECT product_id, quantity FROM order_items WHERE order_id = :order_id")
                            .bind("order_id", orderId)
                            .mapToMap()
                            .list();

            // hoàn sl và tạo giao dịch kho
            for(Map<String, Object> item : items) {
                int productId = (int) item.get("product_id");
                int quantity = (int) item.get("quantity");

                handle.createUpdate("UPDATE products SET quantity = quantity + :qty WHERE id = :id")
                                .bind("qty", quantity)
                                .bind("id", productId)
                                .execute();

                //
                handle.createUpdate("INSERT INTO warehouse_transactions (product_id, order_id, type, quantity, note, created_at) " +
                                        "VALUES (:pid, :oid, 'RETURN', :qty, :note, NOW())")
                                .bind("pid", productId)
                                .bind("oid", orderId)
                                .bind("qty", quantity)
                                .bind("note", "Hủy đơn #" + orderId + ". Lý do: " + reason)
                                .execute();
            }
            return true;
        });

    }

    public boolean isOrderOwnedByUser(int orderId, int userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE id=:id AND user_id=:user_id";
        Integer cnt = get().withHandle(h ->
                h.createQuery(sql)
                        .bind("id", orderId)
                        .bind("user_id", userId)
                        .mapTo(Integer.class)
                        .one()
        );
        return cnt != null && cnt > 0;
    }

    public List<Map<String, Object>> findItemsForRepurchase(int orderId) {
        String sql = """
        SELECT 
            oi.product_id   AS product_id,
            oi.product_name AS name,
            COALESCE(p.image, 'assets/img/no-image.png') AS image,
            oi.price        AS old_price,
            p.price_first         AS current_price,
            p.status        AS product_status,
            oi.quantity     AS quantity
        FROM order_items oi
        LEFT JOIN products p ON p.id = oi.product_id
        WHERE oi.order_id = :order_id
        ORDER BY oi.id ASC
    """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("order_id", orderId)
                        .mapToMap()
                        .list()
        );
    }

    // lấy tất cả những order
    public List<OrderAdmin> getAllOrders() {
        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT 
                    o.id,
                    o.user_id AS userId,
                    o.customer_name AS customerName,
                    o.customer_phone AS customerPhone,
                    o.shipping_address AS shippingAddress,
                    o.status_transport AS statusTransport,
                    o.payment_method AS paymentMethod,
                    o.status_payment AS statusPayment,
                    o.total_price AS totalPrice,
                    o.shipping_fee AS shippingFee,
                    o.created_at AS createdAt
                FROM orders o
                ORDER BY o.created_at DESC
            """).mapToBean(OrderAdmin.class).list()
        );
    }

    // search order theo id hoặc name
    public List<OrderAdmin> searchOrders(String keyword) {
        String searchPattern = "%" + (keyword == null ? "" : keyword.trim()) + "%";

        return get().withHandle(handle ->
                handle.createQuery("""
                SELECT 
                    o.id,
                    o.user_id AS userId,
                    o.customer_name AS customerName,
                    o.customer_phone AS customerPhone,
                    o.shipping_address AS shippingAddress,
                    o.status_transport AS statusTransport,
                    o.payment_method AS paymentMethod,
                    o.status_payment AS statusPayment,
                    o.total_price AS totalPrice,
                    o.shipping_fee AS shippingFee,
                    o.created_at AS createdAt
                FROM orders o
                WHERE CAST(o.id AS CHAR) LIKE :kw
                   OR o.customer_name LIKE :kw
                ORDER BY o.created_at DESC
            """)
                        .bind("kw", searchPattern)
                        .mapToBean(OrderAdmin.class)
                        .list()
        );
    }

    public void deleteOrders(List<Integer> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) return;

        get().useHandle(handle ->
                handle.createUpdate("DELETE FROM orders WHERE id IN (<ids>)")
                        .bindList("ids", orderIds)
                        .execute()
        );
    }

    public void updateStatusTransport(int orderId, int statusTransport) {
        get().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE orders SET status_transport = :status WHERE id = :id"
                        )
                        .bind("status", statusTransport)
                        .bind("id", orderId)
                        .execute()
        );
    }

    public void updateStatusPayment(int orderId, int statusPayment) {
        get().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE orders SET status_payment = :status WHERE id = :id"
                        )
                        .bind("status", statusPayment)
                        .bind("id", orderId)
                        .execute()
        );
    }
    public List<CustomerPurchaseStat> getCustomerPurchaseStats(String keyword) {
        String kw = "%" + (keyword == null ? "" : keyword.trim()) + "%";

        return get().withHandle(handle -> handle.createQuery("""
        SELECT u.id AS userId,
               u.name AS customerName,
               u.email AS email,
               u.phone AS phone,
               COUNT(o.id) AS totalOrders,
               COALESCE(SUM(o.total_price), 0) AS totalSpent,
               MAX(o.created_at) AS lastOrderDate
        FROM users u
        LEFT JOIN orders o ON u.id = o.user_id
        WHERE u.role = 0
          AND (
                u.name LIKE :kw
                OR u.email LIKE :kw
                OR COALESCE(u.phone, '') LIKE :kw
          )
        GROUP BY u.id, u.name, u.email, u.phone
        ORDER BY lastOrderDate DESC
        """)
                .bind("kw", kw)
                .mapToBean(CustomerPurchaseStat.class)
                .list());
    }

    public List<OrderAdmin> getOrdersByUserId(int userId) {
        return get().withHandle(handle -> handle.createQuery("""
         SELECT
                            o.id,
                            o.user_id AS userId,
                            o.customer_name AS customerName,
                            o.customer_phone AS customerPhone,
                            o.shipping_address AS shippingAddress,
                            o.status_transport AS statusTransport,
                            o.payment_method AS paymentMethod,
                            o.status_payment AS statusPayment,
                            o.total_price AS totalPrice,
                            o.shipping_fee AS shippingFee,
                            o.created_at AS createdAt
                        FROM orders o
                        WHERE o.user_id = :userId
                        ORDER BY o.created_at DESC
        """)
                .bind("userId", userId)
                .mapToBean(OrderAdmin.class)
                .list());
    }

    // tìm đơn hàng theo id
    public OrderAdmin findById(int orderId) {
        String sql = """
        SELECT
                    id,
                    user_id AS userId,
                    customer_name AS customerName,
                    customer_phone AS customerPhone,
                    shipping_address AS shippingAddress,
                    status_transport AS statusTransport,
                    payment_method AS paymentMethod,
                    status_payment AS statusPayment,
                    total_price AS totalPrice,
                    shipping_fee AS shippingFee,
                    created_at AS createdAt
        FROM orders
        WHERE id = :id
    """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("id", orderId)
                        .mapToBean(OrderAdmin.class)
                        .findOne()
                        .orElse(null)
        );
    }

    private String buildDateAndStatusFilter(String fromDate, String toDate, String status) {
        StringBuilder sql = new StringBuilder(" WHERE 1=1 ");

        if (fromDate != null && !fromDate.isBlank()) {
            sql.append(" AND DATE(o.created_at) >= :fromDate ");
        }
        if (toDate != null && !toDate.isBlank()) {
            sql.append(" AND DATE(o.created_at) <= :toDate ");
        }

        sql.append(resolveStatusFilter(status));
        return sql.toString();
    }

    private void bindDateFilters(Query query, String fromDate, String toDate) {
        if (fromDate != null && !fromDate.isBlank()) {
            query.bind("fromDate", fromDate);
        }
        if (toDate != null && !toDate.isBlank()) {
            query.bind("toDate", toDate);
        }
    }

    private String resolveStatusFilter(String status) {
        if (status == null || status.isBlank()) {
            return "";
        }

        // Nếu project của bạn dùng completed = 2 hoặc = 3 thì để IN (2, 3) là an toàn.
        return switch (status) {
            case "pending" -> " AND o.status_transport = 0 ";
            case "shipping" -> " AND o.status_transport = 1 ";
            case "done" -> " AND o.status_transport IN (2, 3) ";
            case "cancelled" -> " AND o.status_transport = 4 ";
            default -> "";
        };
    }

    public Map<String, Object> getRevenueSummary(String fromDate, String toDate, String status,
                                                 String monthA, String monthB) {
        String sql = """
            SELECT
                (
                    SELECT COALESCE(SUM(o1.total_price), 0)
                    FROM orders o1
                    WHERE DATE(o1.created_at) = CURDATE()
                      AND o1.status_transport <> 4
                ) AS today_revenue,

                (
                    SELECT COALESCE(SUM(o2.total_price), 0)
                    FROM orders o2
                    WHERE DATE_FORMAT(o2.created_at, '%Y-%m') = :monthA
                      AND o2.status_transport <> 4
                ) AS month_a_revenue,

                (
                    SELECT COALESCE(SUM(o3.total_price), 0)
                    FROM orders o3
                    WHERE DATE_FORMAT(o3.created_at, '%Y-%m') = :monthB
                      AND o3.status_transport <> 4
                ) AS month_b_revenue,

                COUNT(*) AS total_orders,

                COALESCE(SUM(CASE WHEN o.status_transport = 4 THEN 1 ELSE 0 END), 0) AS cancelled_orders,

                COALESCE(
                    ROUND(
                        SUM(CASE WHEN o.status_transport = 4 THEN 1 ELSE 0 END) * 100.0 / NULLIF(COUNT(*), 0),
                        2
                    ),
                    0
                ) AS cancel_rate
            FROM orders o
            """ + buildDateAndStatusFilter(fromDate, toDate, status);

        return get().withHandle(handle -> {
            Query query = handle.createQuery(sql)
                    .bind("monthA", monthA)
                    .bind("monthB", monthB);

            bindDateFilters(query, fromDate, toDate);
            return query.mapToMap().one();
        });
    }

    public List<Map<String, Object>> getRevenueByDate(String fromDate, String toDate, String status) {
        String sql = """
            SELECT
                DATE(o.created_at) AS order_date,
                COUNT(*) AS total_orders,
                COALESCE(SUM(o.total_price), 0) AS gross_revenue,
                COALESCE(SUM(CASE WHEN o.status_transport = 4 THEN 1 ELSE 0 END), 0) AS cancelled_orders,
                COALESCE(SUM(CASE WHEN o.status_transport = 4 THEN o.total_price ELSE 0 END), 0) AS cancelled_value,
                COALESCE(SUM(CASE WHEN o.status_transport <> 4 THEN o.total_price ELSE 0 END), 0) AS net_revenue
            FROM orders o
            """ + buildDateAndStatusFilter(fromDate, toDate, status) + """
            GROUP BY DATE(o.created_at)
            ORDER BY DATE(o.created_at) DESC
            """;

        return get().withHandle(handle -> {
            Query query = handle.createQuery(sql);
            bindDateFilters(query, fromDate, toDate);
            return query.mapToMap().list();
        });
    }

    public List<Map<String, Object>> getTopSellingProducts(String fromDate, String toDate, String status, int limit) {
        String sql = """
            SELECT
                oi.product_id AS product_id,
                oi.product_name AS product_name,
                COALESCE(SUM(oi.quantity), 0) AS sold_qty,
                COALESCE(SUM(oi.price * oi.quantity), 0) AS revenue
            FROM order_items oi
            JOIN orders o ON o.id = oi.order_id
            """ + buildDateAndStatusFilter(fromDate, toDate, status) + """
              AND o.status_transport <> 4
            GROUP BY oi.product_id, oi.product_name
            ORDER BY sold_qty DESC, revenue DESC
            LIMIT :limit
            """;

        return get().withHandle(handle -> {
            Query query = handle.createQuery(sql).bind("limit", limit);
            bindDateFilters(query, fromDate, toDate);
            return query.mapToMap().list();
        });
    }

    public Map<String, Object> getOrderStatusStats(String fromDate, String toDate) {
        String sql = """
            SELECT
                COALESCE(SUM(CASE WHEN o.status_transport = 0 THEN 1 ELSE 0 END), 0) AS pending_orders,
                COALESCE(SUM(CASE WHEN o.status_transport = 1 THEN 1 ELSE 0 END), 0) AS shipping_orders,
                COALESCE(SUM(CASE WHEN o.status_transport IN (2, 3) THEN 1 ELSE 0 END), 0) AS completed_orders,
                COALESCE(SUM(CASE WHEN o.status_transport = 4 THEN 1 ELSE 0 END), 0) AS cancelled_orders
            FROM orders o
            """ + buildDateAndStatusFilter(fromDate, toDate, null);

        return get().withHandle(handle -> {
            Query query = handle.createQuery(sql);
            bindDateFilters(query, fromDate, toDate);
            return query.mapToMap().one();
        });
    }
    public List<Map<String, Object>> getMonthlyRevenueChart(int months) {
        String sql = """
        WITH RECURSIVE months AS (
            SELECT
                CAST(DATE_FORMAT(TIMESTAMPADD(MONTH, 1 - :months, CURDATE()), '%Y-%m-01') AS DATE) AS month_start,
                1 AS seq
            UNION ALL
            SELECT
                DATE_ADD(month_start, INTERVAL 1 MONTH),
                seq + 1
            FROM months
            WHERE seq < :months
        )
        SELECT
            DATE_FORMAT(m.month_start, '%Y-%m') AS month_key,
            CONCAT('T', MONTH(m.month_start)) AS month_label,
            COALESCE(SUM(
                CASE
                    WHEN o.status_transport <> 4 THEN o.total_price
                    ELSE 0
                END
            ), 0) AS revenue
        FROM months m
        LEFT JOIN orders o
            ON o.created_at >= m.month_start
           AND o.created_at < DATE_ADD(m.month_start, INTERVAL 1 MONTH)
        GROUP BY m.month_start
        ORDER BY m.month_start ASC
    """;

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("months", months)
                        .mapToMap()
                        .list()
        );
    }
    public List<Map<String, Object>> getProductMonthComparison(String monthA, String monthB, int limit) {
        String sql = """
            SELECT
                oi.product_id AS product_id,
                oi.product_name AS product_name,

                COALESCE(SUM(
                    CASE
                        WHEN DATE_FORMAT(o.created_at, '%Y-%m') = :monthA
                         AND o.status_transport <> 4
                        THEN oi.quantity ELSE 0
                    END
                ), 0) AS month_a_qty,

                COALESCE(SUM(
                    CASE
                        WHEN DATE_FORMAT(o.created_at, '%Y-%m') = :monthB
                         AND o.status_transport <> 4
                        THEN oi.quantity ELSE 0
                    END
                ), 0) AS month_b_qty,

                COALESCE(SUM(
                    CASE
                        WHEN DATE_FORMAT(o.created_at, '%Y-%m') = :monthA
                         AND o.status_transport <> 4
                        THEN oi.price * oi.quantity ELSE 0
                    END
                ), 0) AS month_a_revenue,

                COALESCE(SUM(
                    CASE
                        WHEN DATE_FORMAT(o.created_at, '%Y-%m') = :monthB
                         AND o.status_transport <> 4
                        THEN oi.price * oi.quantity ELSE 0
                    END
                ), 0) AS month_b_revenue

            FROM order_items oi
            JOIN orders o ON o.id = oi.order_id
            GROUP BY oi.product_id, oi.product_name
            HAVING month_a_qty > 0 OR month_b_qty > 0
            ORDER BY month_b_qty DESC, month_b_revenue DESC
            LIMIT :limit
            """;

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("monthA", monthA)
                        .bind("monthB", monthB)
                        .bind("limit", limit)
                        .mapToMap()
                        .list()
        );
    }

    public List<Map<String, Object>> getImportBatchSalesReport(int limit) {
        String sql = """
            WITH inbound_ranked AS (
                SELECT
                    i.id,
                    i.receipt_code,
                    i.supplier_name,
                    i.product_id,
                    p.name AS product_name,
                    i.pre_stock_qty,
                    i.import_qty,
                    i.unit_cost,
                    i.total_price,
                    i.created_at,
                    LEAD(i.created_at) OVER (
                        PARTITION BY i.product_id
                        ORDER BY i.created_at
                    ) AS next_import_at
                FROM inbound_details i
                LEFT JOIN products p ON p.id = i.product_id
            )
            SELECT
                ib.id AS inbound_id,
                ib.receipt_code AS receipt_code,
                COALESCE(ib.supplier_name, '') AS supplier_name,
                ib.product_id AS product_id,
                COALESCE(ib.product_name, CONCAT('Sản phẩm #', ib.product_id)) AS product_name,
                ib.pre_stock_qty AS pre_stock_qty,
                ib.import_qty AS import_qty,
                ib.unit_cost AS unit_cost,
                ib.total_price AS total_price,
                ib.created_at AS imported_at,
                ib.next_import_at AS next_import_at,

                COALESCE(SUM(
                    CASE
                        WHEN o.status_transport <> 4 THEN oi.quantity
                        ELSE 0
                    END
                ), 0) AS sold_qty_since_import,

                COALESCE(COUNT(DISTINCT
                    CASE
                        WHEN o.status_transport <> 4 THEN o.id
                        ELSE NULL
                    END
                ), 0) AS sold_order_count,

                GREATEST(
                    ib.import_qty - COALESCE(SUM(
                        CASE
                            WHEN o.status_transport <> 4 THEN oi.quantity
                            ELSE 0
                        END
                    ), 0),
                    0
                ) AS estimated_remaining_qty

            FROM inbound_ranked ib
            LEFT JOIN order_items oi
                ON oi.product_id = ib.product_id
            LEFT JOIN orders o
                ON o.id = oi.order_id
               AND o.created_at >= ib.created_at
               AND (ib.next_import_at IS NULL OR o.created_at < ib.next_import_at)

            GROUP BY
                ib.id,
                ib.receipt_code,
                ib.supplier_name,
                ib.product_id,
                ib.product_name,
                ib.pre_stock_qty,
                ib.import_qty,
                ib.unit_cost,
                ib.total_price,
                ib.created_at,
                ib.next_import_at

            ORDER BY ib.created_at DESC
            LIMIT :limit
            """;

        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("limit", limit)
                        .mapToMap()
                        .list()
        );
    }
}