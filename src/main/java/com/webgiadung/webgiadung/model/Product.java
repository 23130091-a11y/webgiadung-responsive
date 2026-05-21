package com.webgiadung.webgiadung.model;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Product implements Serializable {
    private int id; // id p

    private String name; // tên sp

    private String image; // ảnh chính

    private double firstPrice; // giá gốc

    private int discountsId; // id giảm giá (bảng discounts)

    private int categoriesId; // id danh mục

    private int brandsId; // id thương hiệu

    private int isVisible; // 0 - không hiển thị, 1 - hiển thị sp trên trang

    private int status; // 0 - tạm ngừng / ngừng bán hẳn, 1 - đang bán, 2 - hết hàng

    private int quantity; // số lượng kho

    private int soldQuantity; // số lượng đã bán

    private LocalDateTime createdAt; // ngày tạo

    private LocalDateTime updatedAt; // ngày update

    // Liên kết các bảng phụ
    private List<ProductDescriptions> descriptions = new ArrayList<>(); // mô tả sp

    private List<ProductDetails> details = new ArrayList<>(); // chi tiết sp

    private List<ProductImage> images = new ArrayList<>(); // Các ảnh khác của sp

    private List<ProductReview> reviews = new ArrayList<>(); // Đánh giá

    private List<Keywords> keywords = new ArrayList<>();

    // rating tính sẵn từ SQL (dùng cho trang list)

    private Double ratingAvg;

    public Double getRatingAvg() {
        return (ratingAvg != null) ? ratingAvg : 0.0;

    }

    public void setRatingAvg(Double ratingAvg) {
        this.ratingAvg = ratingAvg;

    }

    // Tính toán lại dùng đến sau
    private Double discountPercent;

    private String discountType;

    public void setStatus(int status) {
        this.status = status;
    }

    public Double getDiscountPercent() {
        return discountPercent != null ? discountPercent : 0.0;

    }

    public void setDiscountPercent(Double discountPercent) {
        this.discountPercent = discountPercent;

    }

    public String getDiscountType() {
        return discountType;

    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;

    }

    public int getStatus() {
        return status;
    }

    // tính rating lấy từ review trong trang product details
    public double getRating() {

        if (reviews == null || reviews.isEmpty()) return 0.0;

        double avg = reviews.stream()
                .mapToDouble(ProductReview::getRating)
                .average()
                .orElse(0.0);

        return Math.round(avg * 10.0) / 10.0; // làm tròn 1 chữ số
    }

    // làm tròn để hiển thị sao
    public int getRatingInt() {
        return (int) Math.round(getRating());

    }

    public boolean getIsDiscounted() {
        return discountPercent != null && discountPercent > 0;

    }

    public Product() {}

    public Product(int id, String name, String image, double firstPrice, int discountsId, int categoriesId, int brandsId, int isVisible, int status, int quantity, int soldQuantity, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.id = id;
        this.name = name;
        this.image = image;
        this.firstPrice = firstPrice;
        this.discountsId = discountsId;
        this.categoriesId = categoriesId;
        this.brandsId = brandsId;
        this.isVisible = isVisible;
        this.status = status;
        this.quantity = quantity;
        this.soldQuantity = soldQuantity;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;

    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public int getDiscountsId() {
        return discountsId;
    }

    public void setDiscountsId(int discountsId) {
        this.discountsId = discountsId;
    }

    public double getFirstPrice() {
        return firstPrice;
    }

    public void setFirstPrice(double firstPrice) {
        this.firstPrice = firstPrice;
    }

    public int getCategoriesId() {
        return categoriesId;
    }

    public void setCategoriesId(int categoriesId) {
        this.categoriesId = categoriesId;
    }

    public int getBrandsId() {
        return brandsId;
    }

    public void setBrandsId(int brandsId) {
        this.brandsId = brandsId;
    }

    public int getIsVisible() {
        return isVisible;
    }

    public void setIsVisible(int isVisible) {
        this.isVisible = isVisible;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getSoldQuantity() {
        return soldQuantity;
    }

    public void setSoldQuantity(int soldQuantity) {
        this.soldQuantity = soldQuantity;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<ProductImage> getImages() {
        return images;
    }

    public void setImages(List<ProductImage> images) {
        this.images = images;
    }

    public List<ProductReview> getReviews() {
        return reviews;
    }

    public void setReviews(List<ProductReview> reviews) {
        this.reviews = reviews;
    }

    public List<ProductDescriptions> getDescriptions() {
        return descriptions;
    }

    public void setDescriptions(List<ProductDescriptions> descriptions) {
        this.descriptions = descriptions;
    }

    public List<ProductDetails> getDetails() {
        return details;
    }

    public void setDetails(List<ProductDetails> details) {
        this.details = details;
    }

    public List<Keywords> getKeywords() {
        return keywords;
    }

    public void setKeywords(List<Keywords> keywords) {
        this.keywords = keywords;
    }

    @Override
    public String toString() {
        return "Product{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", image='" + image + '\'' +
                ", firstPrice=" + firstPrice +
                ", discountsId=" + discountsId +
                ", categoriesId=" + categoriesId +
                ", brandsId=" + brandsId +
                ", post=" + isVisible +
                ", quantity=" + quantity +
                ", soldQuantity=" + soldQuantity +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }

    // hàm tính tổng tiền
    public double getTotalPrice() {
        double price = firstPrice;
        if(getIsDiscounted()) {
            if("percentage".equalsIgnoreCase(discountType)) {
                price = firstPrice * (1 - discountPercent / 100);
            }
            else if("fixed".equalsIgnoreCase(discountType)) {
                price = firstPrice - discountPercent;
            }
        }
        return Math.max(price, 0);
    }
}
