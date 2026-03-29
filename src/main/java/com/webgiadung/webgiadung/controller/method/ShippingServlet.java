package com.webgiadung.webgiadung.controller.method;

import com.webgiadung.webgiadung.dao.UserAddressDao;
import com.webgiadung.webgiadung.model.User;
import com.webgiadung.webgiadung.model.UserAddress;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "ShippingServlet", value = "/shipping-calculate")
public class ShippingServlet extends HttpServlet {
    public static final long FEE_INTERNAL = 25000; // Nội thành (HCM)
    public static final long FEE_EXTERNAL = 68000; // Ngoại thành/Tỉnh
    public static final long SURCHARGE_EXPRESS = 150000; // Phụ phí hỏa tốc
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // lấy thông tin ông user và add
        User u = (User) request.getSession().getAttribute("user");
        if (u == null) {
            response.getWriter().write("{\"ok\":false,\"msg\":\"not_login\"}");
            return;
        }

        String idStr = request.getParameter("addressId");
        int id;
        try {
            id = Integer.parseInt(idStr);
        }
        catch (Exception e){
            response.getWriter().write("{\"ok\":false,\"msg\":\"invalid\"}");
            return;
        }

        UserAddressDao dao = new UserAddressDao();

        UserAddress selected = dao.findById(u.getId(), id).orElse(null);
        if (selected == null) {
            response.getWriter().write("{\"ok\":false,\"msg\":\"not_found\"}");
            return;
        }

        String method = request.getParameter("method");

        // tính phí
        long shippingFee = calculateShippingFee(selected, method);

        // trả về json
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"fee\": " + shippingFee + "}");
    }

    private long calculateShippingFee(UserAddress selected, String method) {
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}