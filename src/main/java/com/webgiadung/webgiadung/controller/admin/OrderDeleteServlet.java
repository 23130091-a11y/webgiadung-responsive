package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.dao.OrderDao;
import com.webgiadung.webgiadung.model.OrderAdmin;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "OrderDeleteServlet", value = "/order-delete")
public class OrderDeleteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String[] ids = request.getParameterValues("orderIds");
        OrderDao orderAdminDao = new OrderDao();

        if(ids != null && ids.length > 0) {
            List<Integer> orderIds = Arrays.stream(ids)
                    .map(Integer::parseInt)
                    .collect(Collectors.toList());
            OrderDao dao = new OrderDao();
            dao.deleteOrders(orderIds);
        }

        // Kiểm tra nếu là yêu cầu AJAX
        String xRequestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(xRequestedWith)) {
            // Lấy lại danh sách mới sau khi đã xóa
            OrderDao dao = new OrderDao();
            List<OrderAdmin> orders = dao.getAllOrders();
            request.setAttribute("orders", orders);
            // Trả về cái "ruột" bảng để AJAX cập nhật giao diện
            request.getRequestDispatcher("/_order_list.jsp").forward(request, response);
        } else {
            // Nếu xóa theo kiểu cũ thì redirect
            response.sendRedirect("order-admin");
        }
    }
}