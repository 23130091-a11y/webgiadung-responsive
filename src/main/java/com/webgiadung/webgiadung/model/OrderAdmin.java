package com.webgiadung.webgiadung.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class OrderAdmin implements Serializable {
    private int id; // Mã đơn
    private int userId; // Mã khách
    private String customerName; // Tên khách
    private String customerPhone; // sdt khách
    private String shippingAddress; // địa chỉ ship
    private int statusTransport; // Trạng thái đơn hàng (0=Đơn hàng mới,1=Đã xác nhận,2=Đang giao,3=Đã giao,4=Đã hủy,5=Trả hàng)
    private String paymentMethod; // pttt
    private int statusPayment; // Trạng thái thanh toán (0=Chưa thanh toán,1=Đang xử lý,2=Đã thanh toán,3=Đã hoàn tiền,4=Thanh toán lỗi)
    private double shippingFee; // phí ship
    private LocalDateTime createdAt; // Ngày tạo
    private double totalPrice; // Tổng tiền đơn

    public OrderAdmin(int id, int userId, String customerName, String customerPhone, String shippingAddress, int statusTransport, String paymentMethod, int statusPayment, double shippingFee, LocalDateTime createdAt, double totalPrice) {
        this.id = id;
        this.userId = userId;
        this.customerName = customerName;
        this.customerPhone = customerPhone;
        this.shippingAddress = shippingAddress;
        this.statusTransport = statusTransport;
        this.paymentMethod = paymentMethod;
        this.statusPayment = statusPayment;
        this.shippingFee = shippingFee;
        this.createdAt = createdAt;
        this.totalPrice = totalPrice;
    }

    public OrderAdmin() {}

    @Override
    public String toString() {
        return "OrderAdmin{" +
                "id=" + id +
                ", userId=" + userId +
                ", customerName='" + customerName + '\'' +
                ", customerPhone='" + customerPhone + '\'' +
                ", shippingAddress='" + shippingAddress + '\'' +
                ", statusTransport=" + statusTransport +
                ", paymentMethod='" + paymentMethod + '\'' +
                ", statusPayment=" + statusPayment +
                ", shippingFee=" + shippingFee +
                ", createdAt=" + createdAt +
                ", totalPrice=" + totalPrice +
                '}';
    }

    // row (hủy đơn)
    public String getRowClass() {
        return statusTransport == 4 ? "order-table__row--cancelled" : "";
    }

    // Text
    public String getStatusTransportText() {
        return switch (statusTransport) {
            case 0 -> "Đơn hàng mới";
            case 1 -> "Đã xác nhận";
            case 2 -> "Đang giao";
            case 3 -> "Đã giao";
            case 4 -> "Đã hủy";
            case 5 -> "Trả hàng";
            default -> "Không xác định";
        };
    }

    // Class
    public String getStatusTransportClass() {
        return switch (statusTransport) {
            case 3 -> "order-table__status--completed";
            case 4 -> "order-table__status--cancelled";
            default -> "";
        };
    }

    // Text
    public String getStatusPaymentText() {
        return switch (statusPayment) {
            case 0 -> "Chưa thanh toán";
            case 1 -> "Đang xử lý";
            case 2 -> "Đã thanh toán";
            case 3 -> "Đã hoàn tiền";
            case 4 -> "Thanh toán lỗi";
            default -> "Không xác định";
        };
    }

    // Class
    public String getStatusPaymentClass() {
        return switch (statusPayment) {
            case 0 -> "order-table__payment--pending";
            case 2->  "order-table__payment--paid";
            default -> "";
        };
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public int getStatusTransport() {
        return statusTransport;
    }

    public void setStatusTransport(int statusTransport) {
        this.statusTransport = statusTransport;
    }

    public int getStatusPayment() {
        return statusPayment;
    }

    public void setStatusPayment(int statusPayment) {
        this.statusPayment = statusPayment;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public double getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(double shippingFee) {
        this.shippingFee = shippingFee;
    }

    public String getPaymentMethodText() {
        return switch (paymentMethod) {
            case "cod" -> "Thanh toán khi nhận hàng";
            case "e-wallet" -> "VNPay";
            case "bank" -> "Chuyển khoản";
            default -> "Không xác định";
        };
    }
}
