package com.webgiadung.webgiadung.utils;

import com.webgiadung.webgiadung.model.UserAddress;

public class ShippingUtils {
    public static final long FEE_INTERNAL = 25000; // Nội thành (HCM)
    public static final long FEE_EXTERNAL = 68000; // Ngoại thành/Tỉnh
    public static final long SURCHARGE_EXPRESS = 150000; // Phụ phí hỏa tốc

    public static long calculateShippingFee(UserAddress selected, String method) {
        if(selected == null) return FEE_INTERNAL;
        long baseFee = 0;
        if(selected.getAddress().contains("Hồ Chí Minh") || selected.getAddress().contains("Hà Nội")) {
            baseFee = FEE_INTERNAL;
        } else {
            baseFee = FEE_EXTERNAL;
        }
        // hỏa tốc thì tính phụ thêm
        if ("express".equals(method)) {
            baseFee += SURCHARGE_EXPRESS;
        }
        return baseFee;
    }
}
