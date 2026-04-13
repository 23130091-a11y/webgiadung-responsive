package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.*;
import org.jdbi.v3.core.Handle;

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
            SELECT id, total_price, status_transport, status_payment, created_at
            FROM orders
            WHERE user_id = :user_id
            ORDER BY id DESC
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

    public boolean cancelOrder(int orderId, int userId) {
        String sql = """
        UPDATE orders
        SET status_transport = 4
        WHERE id = :id
          AND user_id = :user_id
          AND status_transport = 0
    """;

        int updated = get().withHandle(h ->
                h.createUpdate(sql)
                        .bind("id", orderId)
                        .bind("user_id", userId)
                        .execute()
        );
        return updated > 0;
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
            oi.price        AS first_price,
            (oi.price * oi.quantity) AS total_price,
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
}