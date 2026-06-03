package com.webgiadung.webgiadung.controller;

import com.webgiadung.webgiadung.model.User;
import com.webgiadung.webgiadung.services.ProductFavoriteService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/api/favorite/toggle")
public class FavoriteProductController extends HttpServlet {
    private ProductFavoriteService favoriteService = new ProductFavoriteService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        String reqProductId = request.getParameter("productId");
        System.out.println("[CLICK API] ProductId received from JS: " + reqProductId);

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Vui lòng đăng nhập để sử dụng chức năng này!\"}");
            return;
        }

        if (reqProductId == null || reqProductId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Không nhận được ID sản phẩm!\"}");
            return;
        }

        try {
            int productId = Integer.parseInt(reqProductId.trim());
            int userId = user.getId();

            boolean isFav = favoriteService.isFavorite(userId, productId);
            String action = "";

            if (isFav) {
                favoriteService.removeFavorite(userId, productId);
                action = "removed";
                System.out.println("[DATABASE] Removed product " + productId + " for User " + userId);
            } else {
                favoriteService.addFavorite(userId, productId);
                action = "added";
                System.out.println("[DATABASE] Added product " + productId + " for User " + userId);
            }

            response.getWriter().write("{\"status\": \"success\", \"action\": \"" + action + "\"}");

        } catch (Exception e) {
            System.out.println("[CONTROLLER ERROR] Exception occurred:");
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"Lỗi Server: " + e.getMessage() + "\"}");
        }
    }
}