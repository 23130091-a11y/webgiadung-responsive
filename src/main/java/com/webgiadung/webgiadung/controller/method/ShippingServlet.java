package com.webgiadung.webgiadung.controller.method;

import com.webgiadung.webgiadung.dao.UserAddressDao;
import com.webgiadung.webgiadung.model.User;
import com.webgiadung.webgiadung.model.UserAddress;
import com.webgiadung.webgiadung.utils.ShippingUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "ShippingServlet", value = "/shipping-calculate")
public class ShippingServlet extends HttpServlet {
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
        long shippingFee = ShippingUtils.calculateShippingFee(selected, method);

        // trả về json
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"fee\": " + shippingFee + "}");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}