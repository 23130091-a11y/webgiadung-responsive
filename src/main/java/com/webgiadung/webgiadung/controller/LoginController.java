package com.webgiadung.webgiadung.controller;

import com.webgiadung.webgiadung.dao.CartDao;
import com.webgiadung.webgiadung.model.Cart;
import com.webgiadung.webgiadung.model.Product;
import com.webgiadung.webgiadung.model.User;
import com.webgiadung.webgiadung.services.AuthService;
import com.webgiadung.webgiadung.services.ProductService;
import com.webgiadung.webgiadung.utils.SecurityUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "LoginController", value = "/login")
public class LoginController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String redirect = request.getParameter("redirect");
        request.setAttribute("redirect", redirect);
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        email = (email == null) ? "" : email.trim().toLowerCase();
        password = (password == null) ? "" : password;

        AuthService authService = new AuthService();
        String hashedInput = SecurityUtils.hashMD5(password);
        User user = authService.checkLogin(email, hashedInput);

        // kt tk
        if (user == null) {
            request.setAttribute("error", "Email hoặc mật khẩu không chính xác!");
            request.setAttribute("redirect", request.getParameter("redirect"));
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        if (user.getStatus() == 0) {
            request.setAttribute("error", "Tài khoản chưa được kích hoạt hoặc đã bị khóa.");
            request.setAttribute("redirect", request.getParameter("redirect"));
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("USER_LOGIN", user);

        CartDao cartDao = new CartDao();
        ProductService productService = new ProductService();

        Cart guestCart = (Cart) session.getAttribute("cart");

        if (guestCart != null && !guestCart.getItems().isEmpty()) {
            for (com.webgiadung.webgiadung.model.CartItem item : guestCart.getItems()) {
                if (item.getProduct() != null) {
                    cartDao.upsert(user.getId(), item.getProduct().getId(), item.getQuantity());
                }
            }
        }

        Cart cart = new Cart();
        List<Map<String, Object>> rows = cartDao.getCartRows(user.getId());
        for (Map<String, Object> row : rows) {
            int productId = ((Number) row.get("product_id")).intValue();
            int quantity  = ((Number) row.get("quantity")).intValue();
            Product product = productService.getProductFullInfo(productId);
            if (product != null) {
                // addItem cộng dồn nên set thẳng
                cart.addItem(product, quantity);
            }
        }


        session.setAttribute("cart", cart);

        // kt redirect trang trước nếu có hoặc admin
        String redirect = request.getParameter("redirect");

        if (redirect != null) redirect = redirect.trim();
        if (redirect != null && (!redirect.startsWith("/") || redirect.startsWith("//") || redirect.contains("://"))) {
            redirect = null;
        }
        if (redirect != null) {
            boolean isAdminPath = redirect.equals("/admin.jsp") || redirect.startsWith("/admin") || redirect.endsWith("-admin");
            if (isAdminPath && user.getRole() != 1) {
                redirect = null;
            }
        }

        if (redirect != null && !redirect.isBlank()) {
            String contextPath = request.getContextPath();
            if (redirect.startsWith(contextPath)) {
                response.sendRedirect(redirect);
            } else {
                if (!redirect.startsWith("/")) redirect = "/" + redirect;
                response.sendRedirect(contextPath + redirect);
            }
            return;
        }

        if (user.getRole() == 1) {
            response.sendRedirect(request.getContextPath() + "/admin/customers");
        } else {
            response.sendRedirect(request.getContextPath() + "/list-product");
        }
    }
}