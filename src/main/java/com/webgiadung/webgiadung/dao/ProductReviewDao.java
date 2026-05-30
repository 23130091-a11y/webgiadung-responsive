package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.ProductReview;

import java.util.List;

public class ProductReviewDao extends BaseDao {

    public void insert(int productId, int userId, double rating, String comment, String fileName) {
        get().useHandle(h ->
                h.createUpdate("""
                    INSERT INTO product_reviews (product_id, user_id, rating, comment, image, status)
                    VALUES (:productId, :userId, :rating, :comment, :image, 1)
                """)
                        .bind("productId", productId)
                        .bind("userId", userId)
                        .bind("rating", rating)
                        .bind("comment", comment)
                        .bind("image", (fileName == null || fileName.isEmpty()) ? null : fileName)
                        .execute()
        );
    }

    public List<ProductReview> findByProductId(int productId) {
        return get().withHandle(h ->
                h.createQuery("""
                    SELECT pr.*, 
                           COALESCE(u.name, u.email) AS authorName,
                           u.avatar AS authorAvatar
                    FROM product_reviews pr
                    LEFT JOIN users u ON u.id = pr.user_id
                    WHERE pr.product_id = :pid AND pr.status = 1
                    ORDER BY pr.created_at DESC
                """)
                        .bind("pid", productId)
                        .mapToBean(ProductReview.class)
                        .list()
        );
    }

    // hàm này dùng sau trong admin, xem lại tất cả review kể cả cái bị ẩn
    public List<ProductReview> findAllForAdmin() {
        return get().withHandle(h ->
                h.createQuery("SELECT pr.*, u.name AS authorName FROM product_reviews pr JOIN users u ON u.id = pr.user_id ORDER BY pr.created_at DESC")
                        .mapToBean(ProductReview.class)
                        .list()
        );
    }

    public boolean hasDeliveredOrder(int userId, int productId) {
        return get().withHandle(h ->
                h.createQuery("""
                    SELECT COUNT(*)
                    FROM order_items oi
                    JOIN orders o ON oi.order_id = o.id
                    WHERE o.user_id          = :userId
                      AND oi.product_id      = :productId
                      AND o.status_transport = 3
                """)
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }
}
