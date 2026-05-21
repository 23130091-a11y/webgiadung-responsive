package com.webgiadung.webgiadung.controller;

import com.webgiadung.webgiadung.dao.ProductReviewDao;
import com.webgiadung.webgiadung.model.Categories;
import com.webgiadung.webgiadung.model.Product;
import com.webgiadung.webgiadung.model.ProductReview;
import com.webgiadung.webgiadung.model.User;
import com.webgiadung.webgiadung.services.CategoriesService;
import com.webgiadung.webgiadung.services.ProductService;
import com.webgiadung.webgiadung.utils.CookieUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductController", value = "/product")
public class ProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        int id;
        try {
            id = Integer.parseInt(request.getParameter("id"));
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid id");
            return;
        }

        ProductService pService = new ProductService();
        CategoriesService cService = new CategoriesService();

        Product p = pService.getProductFullInfo(id);
        if (p == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        // cookie lịch sử xem
        CookieUtils.addIdToCookie(request, response, "viewed_products", id);

        Categories category = cService.getCategory(p.getCategoriesId());
        List<Categories> parentCategories = cService.getCategoriesByParentId(p.getCategoriesId());

        ProductReviewDao reviewDao = new ProductReviewDao();
        List<ProductReview> reviews = reviewDao.findByProductId(id);

        // kiểm tra quyền đánh giá
        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");
        boolean canReview = (user != null) && reviewDao.hasDeliveredOrder(user.getId(), id);

        request.setAttribute("product", p);
        request.setAttribute("category", category);
        request.setAttribute("parentCategories", parentCategories);
        request.setAttribute("reviews", reviews);
        request.setAttribute("canReview", canReview); // thêm mới

        request.getRequestDispatcher("/product.jsp").forward(request, response);
    }
}