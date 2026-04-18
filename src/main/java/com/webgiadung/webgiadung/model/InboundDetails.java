package com.webgiadung.webgiadung.model;

import java.time.LocalDateTime;

public class InboundDetails {
    private int id;
    private String receiptCode;
    private String supplierName;
    private int productId;
    private int preStockQty;
    private int importQty;
    private double unitCost;
    private double totalPrice;
    private LocalDateTime createdAt;

    public InboundDetails(int id, String receiptCode, String supplierName, int productId, int preStockQty, int importQty, double unitCost, double totalPrice, LocalDateTime createdAt) {
        this.id = id;
        this.receiptCode = receiptCode;
        this.supplierName = supplierName;
        this.productId = productId;
        this.preStockQty = preStockQty;
        this.importQty = importQty;
        this.unitCost = unitCost;
        this.totalPrice = totalPrice;
        this.createdAt = createdAt;
    }

    public InboundDetails() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getReceiptCode() {
        return receiptCode;
    }

    public void setReceiptCode(String receiptCode) {
        this.receiptCode = receiptCode;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public int getPreStockQty() {
        return preStockQty;
    }

    public void setPreStockQty(int preStockQty) {
        this.preStockQty = preStockQty;
    }

    public int getImportQty() {
        return importQty;
    }

    public void setImportQty(int importQty) {
        this.importQty = importQty;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public double getUnitCost() {
        return unitCost;
    }

    public void setUnitCost(double unitCost) {
        this.unitCost = unitCost;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}

