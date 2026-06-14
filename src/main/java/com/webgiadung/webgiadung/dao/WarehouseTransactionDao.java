package com.webgiadung.webgiadung.dao;

import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.mapper.MapMappers;

import java.util.List;
import java.util.Map;
import java.util.Optional;

public class WarehouseTransactionDao extends BaseDao {

    public int insert(Handle handle, int productId, Integer orderId, String type, int quantity, String note) {
        return handle.createUpdate("""
                INSERT INTO warehouse_transactions (product_id, order_id, type, quantity, note, created_at)
                VALUES (:productId, :orderId, :type, :quantity, :note, NOW())
            """)
                .bind("productId", productId)
                .bind("orderId", orderId) // Sẽ nhận null nếu là nhập hàng
                .bind("type", type)
                .bind("quantity", quantity)
                .bind("note", note)
                .execute();
    }

    // hàm này dùng sau
    public boolean executeTransactionAndUpdateStock(int productId, Integer orderId, String type, int quantity, String note) {
        return get().inTransaction(handle -> {

            int inserted = insert(handle, productId, orderId, type, quantity, note);

            String sqlUpdate;
            if ("IMPORT".equals(type) || "RETURN".equals(type)) {
                sqlUpdate = "UPDATE products SET quantity = quantity + :qty WHERE id = :id";
            } else {
                sqlUpdate = "UPDATE products SET quantity = quantity - :qty WHERE id = :id";
            }

            int updated = handle.createUpdate(sqlUpdate)
                    .bind("qty", quantity)
                    .bind("id", productId)
                    .execute();

            // update nếu hết hàng thì bỏ gd
            if (updated == 0 && ("EXPORT".equals(type) || "DAMAGED".equals(type))) {
                throw new RuntimeException("Sản phẩm ID " + productId + " không đủ tồn kho!");
            }

            // Trả về true nếu cả 2 thao tác thành công
            return inserted > 0 && updated > 0;
        });
    }

    public boolean handleDamagedTransaction(int productId, int quantity, String note) {
        return get().inTransaction(handle -> {

            int currentStock = handle.createQuery("SELECT quantity FROM products WHERE id = :id")
                    .bind("id", productId)
                    .mapTo(Integer.class)
                    .findOne()
                    .orElse(0);

            if (currentStock < quantity) {
                throw new RuntimeException("Số lượng tồn kho hiện tại không đủ để báo hư hỏng!");
            }

            Optional<Integer> existingTxId = handle.createQuery("""
                    SELECT id FROM warehouse_transactions 
                    WHERE product_id = :productId AND type = 'DAMAGED' 
                    LIMIT 1
                """)
                    .bind("productId", productId)
                    .mapTo(Integer.class)
                    .findOne();

            boolean txResult;

            if (existingTxId.isPresent()) {
                int updatedTx = handle.createUpdate("""
                        UPDATE warehouse_transactions 
                        SET quantity = quantity + :qty, note = :note, created_at = NOW() 
                        WHERE id = :id
                    """)
                        .bind("qty", quantity)
                        .bind("note", note)
                        .bind("id", existingTxId.get())
                        .execute();
                txResult = updatedTx > 0;
            } else {

                int insertedTx = handle.createUpdate("""
                        INSERT INTO warehouse_transactions (product_id, order_id, type, quantity, note, created_at)
                        VALUES (:productId, :orderId, 'DAMAGED', :quantity, :note, NOW())
                    """)
                        .bind("productId", productId)
                        .bind("orderId", (Integer) null)
                        .bind("quantity", quantity)
                        .bind("note", note)
                        .execute();
                txResult = insertedTx > 0;
            }

            // Cập nhật trừ số lượng tồn kho trong bảng products
            int updatedProduct = handle.createUpdate("""
                    UPDATE products SET quantity = quantity - :qty WHERE id = :id
                """)
                    .bind("qty", quantity)
                    .bind("id", productId)
                    .execute();

            return txResult && updatedProduct > 0;
        });
    }

    public java.util.List<java.util.Map<String, Object>> getDamagedTransactions() {
        return get().withHandle(handle ->
                handle.createQuery("""
                    SELECT 
                        t.id,
                        t.product_id AS productId,
                        p.name AS productName,
                        t.quantity,
                        t.note,
                        DATE_FORMAT(t.created_at, '%d/%m/%Y') AS reportDate
                    FROM warehouse_transactions t
                    JOIN products p ON t.product_id = p.id
                    WHERE t.type = 'DAMAGED'
                    ORDER BY t.created_at DESC
                """)
                        .mapToMap()
                        .list()
        );
    }
    // danh sách đơn hàng theo loại export/return
    public java.util.List<java.util.Map<String, Object>> getOrderLogTransactions(String orderId, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder("""
            SELECT 
                t.id AS tx_id,
                t.order_id AS order_id,
                t.type AS tx_type,
                t.quantity AS quantity,
                t.note AS note,
                DATE_FORMAT(t.created_at, '%d/%m/%Y %H:%i') AS report_date,
                p.name AS product_name,
                p.image AS product_image,
                o.customer_name AS customer_name,
                ua.phone AS customer_phone,
                ua.address AS shipping_address,
                o.total_price AS total_price
            FROM warehouse_transactions t
            LEFT JOIN products p ON t.product_id = p.id
            LEFT JOIN orders o ON t.order_id = o.id
            LEFT JOIN user_addresses ua ON o.user_id = ua.user_id AND ua.is_default = 1
            WHERE t.type IN ('EXPORT', 'RETURN')
        """);

        boolean hasOrderId = orderId != null && !orderId.trim().isEmpty();
        boolean hasFromDate = fromDate != null && !fromDate.trim().isEmpty() && !fromDate.contains("undefined");
        boolean hasToDate = toDate != null && !toDate.trim().isEmpty() && !toDate.contains("undefined");

        if (hasOrderId) {
            sql.append(" AND CAST(t.order_id AS CHAR) LIKE :orderId ");
        }
        if (hasFromDate) {
            sql.append(" AND DATE(t.created_at) >= :fromDate ");
        }
        if (hasToDate) {
            sql.append(" AND DATE(t.created_at) <= :toDate ");
        }

        sql.append(" ORDER BY t.created_at DESC ");

        return get().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (hasOrderId) query.bind("orderId", "%" + orderId.trim() + "%");
            if (hasFromDate) query.bind("fromDate", fromDate.trim());
            if (hasToDate) query.bind("toDate", toDate.trim());

            java.util.List<java.util.Map<String, Object>> rawList = query.mapToMap().list();

            return rawList.stream().map(row -> {
                java.util.Map<String, Object> lowerCaseRow = new java.util.LinkedHashMap<>();
                row.forEach((key, value) -> lowerCaseRow.put(key.toLowerCase(), value));

                if (lowerCaseRow.get("customer_name") == null) {
                    lowerCaseRow.put("customer_name", "");
                }
                if (lowerCaseRow.get("customer_phone") == null) {
                    lowerCaseRow.put("customer_phone", "");
                }
                if (lowerCaseRow.get("shipping_address") == null) {
                    lowerCaseRow.put("shipping_address", "");
                }
                if (lowerCaseRow.get("total_price") == null) {
                    lowerCaseRow.put("total_price", 0);
                }

                lowerCaseRow.put("payment_method", "Thanh toán khi nhận hàng");

                return lowerCaseRow;
            }).collect(java.util.stream.Collectors.toList());
        });
    }
}
