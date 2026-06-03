package com.webgiadung.webgiadung.services;

import com.webgiadung.webgiadung.dao.ProductFavoriteDao;
import com.webgiadung.webgiadung.model.ProductFavorite;

import java.util.List;

public class ProductFavoriteService {
    private ProductFavoriteDao productFavoriteDao = new ProductFavoriteDao();


    public List<ProductFavorite> getFavoriteProductsByUserId(int userId) {
        return productFavoriteDao.findFavoriteProductsByUserId(userId);
    }
    public boolean isFavorite(int userId, int productId) {
        return productFavoriteDao.isFavorite(userId, productId);
    }

    public boolean addFavorite(int userId, int productId) {
        return productFavoriteDao.add(userId, productId);
    }


    public boolean removeFavorite(int userId, int productId) {
        return productFavoriteDao.delete(userId, productId);
    }

}