package com.webgiadung.webgiadung.controller.method;

import com.webgiadung.webgiadung.dao.OrderDao;
import com.webgiadung.webgiadung.model.User;
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
        OrderDao orderDao = new OrderDao();

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

            int orderId = Integer.parseInt(request.getParameter("orderId"));

            boolean ok = orderDao.cancelOrder(orderId, user.getId());

            // tạo nội dung json trả về
            String jsonResponse;
            if (ok) {
                jsonResponse = "{\"status\": \"success\", \"message\": \"Đã hủy đơn hàng thành công!\"}";
            } else {
                jsonResponse = "{\"status\": \"error\", \"message\": \"Hủy đơn thất bại. Đơn hàng có thể đã được giao hoặc không tồn tại.\"}";
            }

            response.getWriter().write(jsonResponse);
            return;
        }
    }
}