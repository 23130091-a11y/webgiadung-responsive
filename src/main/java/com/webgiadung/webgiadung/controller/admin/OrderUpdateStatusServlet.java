package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.dao.OrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "OrderUpdateStatusServlet", value = "/order-update-status")
public class OrderUpdateStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/order-admin");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        OrderDao orderAdminDao = new OrderDao();

        String orderIdParam = firstNotBlank(
                request.getParameter("orderId"),
                request.getParameter("id"),
                request.getParameter("orderIds")
        );

        String type = firstNotBlank(
                request.getParameter("type"),
                request.getParameter("updateType")
        );

        String statusParam = firstNotBlank(
                request.getParameter("status"),
                request.getParameter("statusTransport"),
                request.getParameter("statusPayment")
        );

        if (isBlank(type)) {
            if (!isBlank(request.getParameter("statusTransport"))) {
                type = "transport";
            } else if (!isBlank(request.getParameter("statusPayment"))) {
                type = "payment";
            }
        }

        if (isBlank(orderIdParam) || isBlank(type) || isBlank(statusParam)) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(
                    "Thiếu dữ liệu cập nhật đơn hàng: orderId=" + safe(orderIdParam)
                            + ", type=" + safe(type)
                            + ", status=" + safe(statusParam)
            );
            return;
        }

        int orderId;
        int status;

        try {
            orderId = Integer.parseInt(orderIdParam.trim());
            status = Integer.parseInt(statusParam.trim());
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Dữ liệu orderId hoặc status không hợp lệ");
            return;
        }

        if ("transport".equals(type)) {
            orderAdminDao.updateStatusTransport(orderId, status);
        } else if ("payment".equals(type)) {
            orderAdminDao.updateStatusPayment(orderId, status);
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Loại cập nhật không hợp lệ: " + type);
            return;
        }

        String xRequestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(xRequestedWith)) {
            request.setAttribute("orders", orderAdminDao.getAllOrders());
            request.getRequestDispatcher("/_order_list.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/order-admin");
        }
    }

    private static String firstNotBlank(String... values) {
        if (values == null) return null;
        for (String v : values) {
            if (!isBlank(v)) return v;
        }
        return null;
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private static String safe(String value) {
        return value == null ? "null" : value;
    }
}