package com.webgiadung.webgiadung.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class WareHouseTransaction implements Serializable {
    private int id;
    private int productId;
    private Integer orderId; // Dùng Integer để có thể nhận giá trị null (nếu là nhập hàng)
    private String type; // IMPORT, EXPORT, DAMAGED, RETURN
    private String note;
    private Timestamp createdAt;

    public WareHouseTransaction() {}

    public WareHouseTransaction(int id, int productId, Integer orderId, String type, String note, Timestamp createdAt) {
        this.id = id;
        this.productId = productId;
        this.orderId = orderId;
        this.type = type;
        this.note = note;
        this.createdAt = createdAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
