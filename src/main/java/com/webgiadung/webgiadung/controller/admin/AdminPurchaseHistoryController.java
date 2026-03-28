package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.dao.AuthDao;
import com.webgiadung.webgiadung.dao.OrderDao;
import com.webgiadung.webgiadung.model.CustomerPurchaseStat;
import com.webgiadung.webgiadung.model.OrderAdmin;
import com.webgiadung.webgiadung.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/purchase-history")
public class AdminPurchaseHistoryController extends HttpServlet {

    private final AuthDao authDao = new AuthDao();
    private final OrderDao orderDao = new OrderDao();

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;

        Object obj = session.getAttribute("user");
        if (!(obj instanceof User)) obj = session.getAttribute("USER_LOGIN");
        if (!(obj instanceof User)) return false;

        User ses = (User) obj;
        User fresh = authDao.findByIdFull(ses.getId());
        if (fresh == null) return false;

        session.setAttribute("user", fresh);
        return fresh.getRole() == 1 && fresh.getStatus() == 1;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String q = request.getParameter("q");
        int userId = parseIntSafe(request.getParameter("userId"), -1);

        List<CustomerPurchaseStat> purchaseStats = orderDao.getCustomerPurchaseStats(q);
        request.setAttribute("purchaseStats", purchaseStats);
        request.setAttribute("q", q == null ? "" : q);

        if (userId > 0) {
            List<OrderAdmin> selectedOrders = orderDao.getOrdersByUserId(userId);
            request.setAttribute("selectedUserId", userId);
            request.setAttribute("selectedOrders", selectedOrders);
        }

        request.setAttribute("tab", "purchaseHistory");
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    private int parseIntSafe(String value, int defaultValue) {
        try {
            if (value == null || value.trim().isEmpty()) return defaultValue;
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}