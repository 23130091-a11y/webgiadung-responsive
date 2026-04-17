package com.webgiadung.webgiadung.dao;

import org.jdbi.v3.core.Handle;

public class WarehouseTransactionDao extends BaseDao{

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

            // Trả về true nếu cả 2 thao tác thành công
            return inserted > 0 && updated > 0;
        });
    }
}
