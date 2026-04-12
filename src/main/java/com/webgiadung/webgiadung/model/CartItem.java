package com.webgiadung.webgiadung.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class CartItem implements Serializable {
    private Product product;
    private int quantity;
    private double originalPrice;
    private double discountPrice;
    private LocalDateTime addedAt;

    public Product getProduct() { return product; }
    public int getQuantity() { return quantity; }
    public double getOriginalPrice() { return originalPrice; }
    public double getDiscountPrice() { return discountPrice; }
    public LocalDateTime getAddedAt() { return addedAt; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public CartItem() {}

    public CartItem(Product product, int quantity, double originalPrice, double discountPrice) {
        this.product = product;
        this.quantity = quantity <= 0 ? 1 : quantity;
        this.originalPrice = originalPrice;
        this.discountPrice = discountPrice;
        this.addedAt = LocalDateTime.now(); // thời gian hiện tại thêm vào giỏ hàng
    }

    // tổng giá
    public double getTotalPrice() {
        return discountPrice * quantity;
    }

    public void upQuantity(int quantity) {
        this.quantity += quantity;
    }
}
