package com.webgiadung.webgiadung.services;

import com.webgiadung.webgiadung.dao.ProductDao;
import com.webgiadung.webgiadung.dao.ProductDescriptionsDao;
import com.webgiadung.webgiadung.dao.ProductDetailsDao;
import com.webgiadung.webgiadung.model.Product;
import com.webgiadung.webgiadung.model.ProductDescriptions;
import com.webgiadung.webgiadung.model.ProductDetails;

import java.util.List;

public class ProductService {
    ProductDao pdao = new ProductDao();
    ProductDescriptionsDao descDao = new ProductDescriptionsDao();
    ProductDetailsDao detailDao = new ProductDetailsDao();

    // Lấy danh sách tất cả sản phẩm
    public List<Product> getListProduct() {
        return pdao.getListProduct();
    }

    // Thêm sản phẩm mới và trả về ID (Generated Key)
    public int addProduct(Product p) {
        return pdao.insert(p);
    }

    // Lấy chi tiết một sản phẩm theo ID
    public Product getProduct(int id) {
        return pdao.getProduct(id);
    }

    // Thêm mô tả ngắn cho sản phẩm
    public int addDescription(ProductDescriptions desc) {
        return descDao.insert(desc);
    }

    // Lấy danh sách các dòng mô tả của một sản phẩm nhất định
    public List<ProductDescriptions> getDescriptionsByProduct(int productId) {
        return descDao.findByProductId(productId);
    }

    // Thêm chi tiết sản phẩm (bao gồm ảnh chi tiết và nội dung)
    public int addProductDetail(ProductDetails detail) {
        return detailDao.insert(detail);
    }

    // Lấy danh sách các mục chi tiết của một sản phẩm nhất định
    public List<ProductDetails> getDetailsByProduct(int productId) {
        return detailDao.findByProductId(productId);
    }

    public List<Product> getFeaturedProducts() {
        return pdao.getFeaturedProducts();
    }

    public List<Product> getPromotionProducts() {
        return pdao.getPromotionProducts();
    }

    public List<Product> getSuggestedProducts() {
        return pdao.getSuggestedProducts();
    }

    public List<Product> getLimitedProducts() {
        return pdao.getLimitedProducts();
    }

    public List<Product> getNewProducts() {
        return pdao.getNewProducts();
    }

    public List<Product> getProductsByCategory(int categoryId) {
        return pdao.getProductsByCategoryId(categoryId);
    }

    public List<Product> searchProductByName(String keyword) {
        return pdao.searchByName(keyword);
    }

    public Product getProductFullInfo(int id) {
        return pdao.getProductFullInfo(id);
    }

    public boolean updateProduct(Product p) {
        return pdao.updateProduct(p);
    }

    public boolean updateDescription(ProductDescriptions desc) {
        return descDao.update(desc);
    }

    public boolean deleteDescription(int id) {
        return descDao.delete(id);
    }

    public boolean deleteAllDescriptionsByProductId(int productId) {
        return descDao.deleteByProductId(productId);
    }

    public boolean updateProductDetail(ProductDetails detail) {
        return detailDao.update(detail);
    }

    public boolean deleteProductDetail(int id) {
        return detailDao.delete(id);
    }

    public void deleteAllDetailsByProductId(int productId) {
        detailDao.deleteByProductId(productId);
    }

    public boolean deleteProduct(int id) {
        return pdao.deleteProduct(id);
    }

    public int applyDiscountToCategory(int categoryId, int discountId) {
        return pdao.applyDiscountToCategory(categoryId, discountId);
    }

    public List<Product> searchWithFilters(String keyword, String[] brands, String[] priceRanges,String categoryId) {
        return pdao.searchWithFilters(keyword, brands, priceRanges,categoryId);
    }

    public List<Product> getProductsFromIds(List<Integer> viewedIds) {
        return pdao.getProductsFromIds(viewedIds);
    }

    public List<Product> searchByDiscountName(String discountName) {
        return pdao.searchByDiscountName(discountName);
    }

    public int removeDiscount(int discountId) {
        return pdao.removeDiscount(discountId);
    }

    // xử lý tồn kho
    public int getAvailableStock(int productId) {
        return pdao.getAvailableStock(productId);
    }
}

