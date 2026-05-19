package com.webgiadung.webgiadung.dao;

import java.util.List;
import java.util.Map;

public class CartDao extends BaseDao {
    public void upsert(int userId, int productId, int quantity) {
        get().useHandle(h ->
                h.createUpdate(
                                "INSERT INTO cart_items (user_id, product_id, quantity, added_at, updated_at) " +
                                        "VALUES (:uid, :pid, :qty, NOW(), NOW()) " +
                                        "ON DUPLICATE KEY UPDATE quantity = quantity + :qty, updated_at = NOW()"
                        )
                        .bind("uid", userId)
                        .bind("pid", productId)
                        .bind("qty", quantity)
                        .execute()
        );
    }


    public void setQuantity(int userId, int productId, int quantity) {
        if (quantity <= 0) {
            delete(userId, productId);
            return;
        }
        get().useHandle(h ->
                h.createUpdate(
                                "INSERT INTO cart_items (user_id, product_id, quantity, added_at, updated_at) " +
                                        "VALUES (:uid, :pid, :qty, NOW(), NOW()) " +
                                        "ON DUPLICATE KEY UPDATE quantity = :qty, updated_at = NOW()"
                        )
                        .bind("uid", userId)
                        .bind("pid", productId)
                        .bind("qty", quantity)
                        .execute()
        );
    }


    public void delete(int userId, int productId) {
        get().useHandle(h ->
                h.createUpdate(
                                "DELETE FROM cart_items WHERE user_id = :uid AND product_id = :pid"
                        )
                        .bind("uid", userId)
                        .bind("pid", productId)
                        .execute()
        );
    }


    public void deleteAll(int userId) {
        get().useHandle(h ->
                h.createUpdate("DELETE FROM cart_items WHERE user_id = :uid")
                        .bind("uid", userId)
                        .execute()
        );
    }


    public List<Map<String, Object>> getCartRows(int userId) {
        return get().withHandle(h ->
                h.createQuery(
                                "SELECT product_id, quantity FROM cart_items " +
                                        "WHERE user_id = :uid ORDER BY added_at ASC"
                        )
                        .bind("uid", userId)
                        .mapToMap()
                        .list()
        );
    }
}