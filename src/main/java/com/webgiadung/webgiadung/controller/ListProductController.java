package com.webgiadung.webgiadung.controller;

import com.webgiadung.webgiadung.dao.CategoriesDao;
import com.webgiadung.webgiadung.model.Categories;
import com.webgiadung.webgiadung.model.Product;
import com.webgiadung.webgiadung.model.Slide;
import com.webgiadung.webgiadung.model.User;
import com.webgiadung.webgiadung.services.ProductService;
import com.webgiadung.webgiadung.services.SlideService;
import com.webgiadung.webgiadung.services.ProductFavoriteService;
import com.webgiadung.webgiadung.utils.CookieUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import com.webgiadung.webgiadung.services.BlogService;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "listProduct", value = "/list-product")
public class ListProductController extends HttpServlet {
    private CategoriesDao categoriesDao = new CategoriesDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProductService productService = new ProductService();
        List<Product> list = productService.getListProduct();

        List<Integer> viewedIds = CookieUtils.getIdsFromCookie(request, "viewed_products");
        List<Product> historyProducts = null;
        if (!viewedIds.isEmpty()) {
            historyProducts = productService.getProductsFromIds(viewedIds);
            request.setAttribute("historyProducts", historyProducts);
        }

        SlideService slideService = new SlideService();
        List<Slide> slides = slideService.getListSlide();

        List<Product> featuredProducts = productService.getFeaturedProducts();
        List<Product> promotionProducts = productService.getPromotionProducts();
        List<Product> suggestedProducts = productService.getSuggestedProducts();
        List<Product> limitedProducts = productService.getLimitedProducts();
        List<Product> newProducts = productService.getNewProducts();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");


        if (user != null) {
            ProductFavoriteService favoriteService = new ProductFavoriteService();
            int userId = user.getId();

            checkFavoriteStatus(list, favoriteService, userId);
            checkFavoriteStatus(featuredProducts, favoriteService, userId);
            checkFavoriteStatus(promotionProducts, favoriteService, userId);
            checkFavoriteStatus(suggestedProducts, favoriteService, userId);
            checkFavoriteStatus(limitedProducts, favoriteService, userId);
            checkFavoriteStatus(newProducts, favoriteService, userId);
            checkFavoriteStatus(historyProducts, favoriteService, userId);
        }

        request.setAttribute("list", list);
        request.setAttribute("slides", slides);
        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("promotionProducts", promotionProducts);
        request.setAttribute("suggestedProducts", suggestedProducts);
        request.setAttribute("limitedProducts", limitedProducts);
        request.setAttribute("newProducts", newProducts);

        List<Categories> parentCategories = categoriesDao.getCategoryTree();
        request.setAttribute("parentCategories", parentCategories);

        BlogService blogService = new BlogService();
        request.setAttribute("latestBlogs", blogService.getHomeBlogs());

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    }

    private void checkFavoriteStatus(List<Product> products, ProductFavoriteService service, int userId) {
        if (products != null && !products.isEmpty()) {
            for (Product p : products) {
                p.setFavorite(service.isFavorite(userId, p.getId()));

            }
        }
    }
}