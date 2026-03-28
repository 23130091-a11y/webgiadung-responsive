package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.ProductImage;

public class ProductImageDao extends BaseDao{
    public int insert(ProductImage img) {
        return get().withHandle(h ->
                h.createUpdate("INSERT INTO product_images (path, product_id, created_at, updated_at) " +
                                "VALUES (:path, :productId, NOW(), NOW())")
                        .bind("path", img.getPath())
                        .bind("productId", img.getProductId())
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one()
        );
    }
}
