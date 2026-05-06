package com.webgiadung.webgiadung.controller.method;

import com.webgiadung.webgiadung.model.User;
import com.webgiadung.webgiadung.services.OrderService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "AccountAgainServlet", value = "/account-again")
public class AccountAgainServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        OrderService orderService = new OrderService();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        if("cancelOrder".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                String reason = request.getParameter("reason");

                if(reason == null || reason.trim().isEmpty()) {
                    reason = "Người dùng không cung cấp lý do.";
                }

                boolean ok = orderService.cancelOrder(orderId, user.getId(), reason);

                // tạo nội dung json trả về
                String jsonResponse;
                if (ok) {
                    jsonResponse = "{\"status\": \"success\", \"message\": \"Đã hủy đơn hàng thành công!\"}";
                } else {
                    jsonResponse = "{\"status\": \"error\", \"message\": \"Hủy đơn thất bại. Đơn hàng có thể đã được giao hoặc không tồn tại.\"}";
                }

                response.getWriter().write(jsonResponse);
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Lỗi hệ thống khi hủy đơn.\"}");
            }
            return;
        }
    }
}