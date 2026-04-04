package com.webgiadung.webgiadung.controller.method;

import com.webgiadung.webgiadung.dao.OrderDao;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "VnPayReturn", value = "/vnpay_return")
public class VnPayReturn extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        OrderDao orderDao = new OrderDao();
        String orderId = request.getParameter("orderId");
        String responseCode = request.getParameter("vnp_ResponseCode");

        int id = Integer.parseInt(orderId);

        if ("00".equals(responseCode)) {
            orderDao.updateStatusPayment(id, 2);
            response.sendRedirect(request.getContextPath() + "/checkout-success?orderId=" + orderId);
        } else {
            orderDao.updateStatusPayment(id, 4);
            response.sendRedirect(request.getContextPath() + "/checkout-error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}