package com.webgiadung.webgiadung.controller;

import com.webgiadung.webgiadung.dao.ProductReviewDao;
import com.webgiadung.webgiadung.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ReviewController", value = "/review")
public class ReviewController extends HttpServlet {

    private final ProductReviewDao reviewDao = new ProductReviewDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        int productId = 0;
        try { productId = Integer.parseInt(request.getParameter("productId")); } catch (Exception ignored) {}

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/product?id=" + productId + "#reviews");
            return;
        }

        if (!reviewDao.hasDeliveredOrder(user.getId(), productId)) {
            response.sendRedirect(request.getContextPath() + "/product?id=" + productId + "&cmt_err=not_bought#reviews");
            return;
        }

        String comment = request.getParameter("comment");
        if (comment == null || comment.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/product?id=" + productId + "&cmt_err=empty#reviews");
            return;
        }

        double rating = 5;
        try { rating = Double.parseDouble(request.getParameter("rating")); } catch (Exception ignored) {}
        if (rating < 1) rating = 1;
        if (rating > 5) rating = 5;

        reviewDao.insert(productId, user.getId(), rating, comment.trim());

        response.sendRedirect(request.getContextPath() + "/product?id=" + productId + "#reviews");
    }
}