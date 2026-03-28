package com.webgiadung.webgiadung.services;

import com.webgiadung.webgiadung.dao.KeywordsDao;
import com.webgiadung.webgiadung.dao.ProductImageDao;
import com.webgiadung.webgiadung.model.ProductImage;

public class ProductImageService {
    private ProductImageDao productImageDao = new ProductImageDao();
    public int addProductImage(ProductImage img) {
        try {
            if (img.getPath() == null || img.getPath().isEmpty()) {
                return -1;
            }
            return productImageDao.insert(img);
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }
}
