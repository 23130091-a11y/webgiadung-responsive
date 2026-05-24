package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.dao.OrderDao;
import com.webgiadung.webgiadung.model.OrderAdmin;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderSearchServlet", value = "/order-search")
public class OrderSearchServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword       = request.getParameter("keyword");
        String statusFilter  = request.getParameter("statusFilter");
        String paymentFilter = request.getParameter("paymentFilter");

        OrderDao orderDao = new OrderDao();
        List<OrderAdmin> orders;

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasStatus  = statusFilter != null && !statusFilter.trim().isEmpty();
        boolean hasPayment = paymentFilter != null && !paymentFilter.trim().isEmpty();

        if (hasKeyword || hasStatus || hasPayment) {
            orders = orderDao.filterOrders(keyword, statusFilter, paymentFilter);
        } else {
            orders = orderDao.getAllOrders();
        }

        request.setAttribute("orders", orders);

        String xRequestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(xRequestedWith)) {
            request.getRequestDispatcher("/_order_list.jsp").forward(request, response);
        } else {
            request.setAttribute("keyword", keyword);
            request.getRequestDispatcher("/admin.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    }
}