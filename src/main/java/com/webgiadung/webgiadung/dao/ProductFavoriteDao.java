package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.Product;
import com.webgiadung.webgiadung.model.ProductFavorite;

import java.util.List;

public class ProductFavoriteDao extends BaseDao {

    public boolean add(int userId, int productId) {
        return get().withHandle(h ->
                h.createUpdate("""
                        INSERT IGNORE INTO product_favorites (user_id, product_id, created_at)
                        VALUES (:userId, :productId, NOW())
                        """)
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .execute() > 0
        );
    }

    public boolean delete(int userId, int productId) {
        return get().withHandle(h ->
                h.createUpdate("""
                        DELETE FROM product_favorites 
                        WHERE user_id = :userId AND product_id = :productId
                        """)
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .execute() > 0
        );
    }

    public boolean isFavorite(int userId, int productId) {
        return get().withHandle(h ->
                h.createQuery("""
                    SELECT CAST(COUNT(*) AS SIGNED) 
                    FROM product_favorites 
                    WHERE user_id = :userId AND product_id = :productId
                    """)
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public List<ProductFavorite> findFavoriteProductsByUserId(int userId) {
        return get().withHandle(h ->
                h.createQuery("""
                        SELECT 
                            pf.id AS fav_id, 
                            pf.user_id AS fav_userId, 
                            pf.product_id AS fav_productId, 
                            pf.created_at AS fav_createdAt,
                            p.id AS p_id, 
                            p.name AS p_name, 
                            p.image AS p_image,
                            p.price_first AS p_firstPrice, 
                            p.discounts_id AS p_discountsId, 
                            p.categories_id AS p_categoriesId, 
                            p.brands_id AS p_brandsId, 
                            p.is_visible AS p_isVisible,
                            p.status AS p_status, 
                            p.quantity AS p_quantity, 
                            p.sold_quantity AS p_soldQuantity, 
                            p.created_at AS p_createdAt, 
                            p.updated_at AS p_updatedAt,
                            IFNULL(d.discount_value, 0) AS p_discountPercent,
                            d.discount_type AS p_discountType,
                            IFNULL(pr.ratingAvg, 0.0) AS p_ratingAvg
                        FROM product_favorites pf
                        INNER JOIN products p ON pf.product_id = p.id
                        LEFT JOIN discounts d ON p.discounts_id = d.id
                        LEFT JOIN (
                            SELECT product_id, ROUND(AVG(rating), 1) AS ratingAvg 
                            FROM product_reviews 
                            GROUP BY product_id
                        ) pr ON p.id = pr.product_id
                        WHERE pf.user_id = :userId AND p.is_visible = 1
                        ORDER BY pf.created_at DESC
                        """)
                        .bind("userId", userId)
                        .map((rs, ctx) -> {
                            ProductFavorite favorite = new ProductFavorite();
                            favorite.setId(rs.getInt("fav_id"));
                            favorite.setUserId(rs.getInt("fav_userId"));
                            favorite.setProductId(rs.getInt("fav_productId"));

                            // Bảo vệ hệ thống chống sập NullPointerException khi created_at null
                            java.sql.Timestamp favTimestamp = rs.getTimestamp("fav_createdAt");
                            if (favTimestamp != null) {
                                favorite.setCreatedAt(favTimestamp.toLocalDateTime());
                            }

                            Product product = new Product();
                            product.setId(rs.getInt("p_id"));
                            product.setName(rs.getString("p_name"));
                            product.setImage(rs.getString("p_image"));
                            product.setFirstPrice(rs.getDouble("p_firstPrice"));
                            product.setDiscountsId(rs.getInt("p_discountsId"));
                            product.setCategoriesId(rs.getInt("p_categoriesId"));
                            product.setBrandsId(rs.getInt("p_brandsId"));
                            product.setIsVisible(rs.getInt("p_isVisible"));
                            product.setStatus(rs.getInt("p_status"));
                            product.setQuantity(rs.getInt("p_quantity"));
                            product.setSoldQuantity(rs.getInt("p_soldQuantity"));

                            product.setDiscountPercent(rs.getDouble("p_discountPercent"));
                            product.setDiscountType(rs.getString("p_discountType"));
                            product.setRatingAvg(rs.getDouble("p_ratingAvg"));

                            favorite.setProduct(product);
                            return favorite;
                        })
                        .list()
        );
    }
}