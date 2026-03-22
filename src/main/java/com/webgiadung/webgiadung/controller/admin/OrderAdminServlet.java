package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.dao.OrderDao;
import com.webgiadung.webgiadung.model.OrderAdmin;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
/* Load danh sách order vào quản lý*/
@WebServlet(name = "OrderAdminServlet", value = "/order-admin")
public class OrderAdminServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy tất cả đơn hàng từ DB
        OrderDao orderAdminDao = new OrderDao();; List<OrderAdmin> orders = orderAdminDao.getAllOrders();
        // 2. Đặt attribute để JSP hiển thị
        request.setAttribute("orders", orders);
        // 3. Forward sang JSP quản lý đơn hàng Admin
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}