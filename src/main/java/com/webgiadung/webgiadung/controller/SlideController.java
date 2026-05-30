package com.webgiadung.webgiadung.controller;

import com.webgiadung.webgiadung.model.Product;
import com.webgiadung.webgiadung.model.Slide;
import com.webgiadung.webgiadung.services.ProductService;
import com.webgiadung.webgiadung.services.SlideService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "SlideController", value = "/view-slide")
public class SlideController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String slideIdStr = request.getParameter("id");

        if (slideIdStr != null && !slideIdStr.trim().isEmpty()) {
            try {
                int slideId = Integer.parseInt(slideIdStr.trim());

                SlideService slideService = new SlideService();
                Slide slide = slideService.getById(slideId);

                if (slide != null) {

                    String discountName = slide.getTitle();

                    ProductService productService = new ProductService();
                    List<Product> products = productService.searchByDiscountName(discountName);

                    request.setAttribute("slide", slide);
                    request.setAttribute("productList", products);
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy chương trình khuyến mãi.");
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "ID chương trình không hợp lệ.");
            }
        } else {
            request.setAttribute("errorMessage", "Thiếu ID chương trình khuyến mãi.");
        }


        request.getRequestDispatcher("/slide.jsp").forward(request, response);
    }
}