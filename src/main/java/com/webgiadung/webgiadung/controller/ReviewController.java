package com.webgiadung.webgiadung.controller;

import com.webgiadung.webgiadung.dao.ProductReviewDao;
import com.webgiadung.webgiadung.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.util.UUID;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, //10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)

@WebServlet(name = "ReviewController", value = "/review")
public class ReviewController extends HttpServlet {

    private static final String UPLOAD_DIR = "C:\\webgiadung_data\\uploads";

    private final ProductReviewDao reviewDao = new ProductReviewDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        int productId = 0;
        try { productId = Integer.parseInt(request.getParameter("productId")); } catch (Exception ignored) {}

        if (user == null) {
            String targetUrl = "/product?id=" + productId + "#reviews";
            String encodedTarget = URLEncoder.encode(targetUrl, StandardCharsets.UTF_8);

            response.sendRedirect(request.getContextPath() + "/login?redirect=" + encodedTarget);
            return;
        }

        String fileName = "";
        try {
            Part part = request.getPart("reviewImage");
            if(part != null && part.getSize() > 0) {
                // lấy ra tên file gốc
                fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
                String extension = fileName.substring(fileName.lastIndexOf("."));
                fileName = UUID.randomUUID().toString() + extension;

                part.write(UPLOAD_DIR + File.separator + fileName);
            }
        } catch (Exception e) {
            System.out.println("User không upload ảnh hoặc lỗi upload: " + e.getMessage());
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

        reviewDao.insert(productId, user.getId(), rating, comment.trim(), fileName);

        response.sendRedirect(request.getContextPath() + "/product?id=" + productId + "#reviews");
    }
}
