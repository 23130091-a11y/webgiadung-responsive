package com.webgiadung.webgiadung.controller;

import com.webgiadung.webgiadung.model.Brands;
import com.webgiadung.webgiadung.model.Categories;
import com.webgiadung.webgiadung.model.Product;
import com.webgiadung.webgiadung.services.BrandService;
import com.webgiadung.webgiadung.services.CategoriesService;
import com.webgiadung.webgiadung.services.ProductService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "SearchServlet", value = "/search-product")
public class SearchServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String keyword = request.getParameter("keyword");

        if (keyword != null) {
            keyword = keyword.trim();
        }

        String categoryId = request.getParameter("categoryId");
        String[] brands = request.getParameterValues("brands");
        if (brands == null) brands = request.getParameterValues("brands[]");

        String[] priceRanges = request.getParameterValues("priceRanges");
        if (priceRanges == null) priceRanges = request.getParameterValues("priceRanges[]");

        String rating = request.getParameter("rating");

        boolean hasKeyword = (keyword != null && !keyword.isEmpty());
        boolean hasCategory = (categoryId != null && !categoryId.isEmpty());
        boolean hasFilter = (brands != null && brands.length > 0)
                || (priceRanges != null && priceRanges.length > 0)
                || (rating != null && !rating.trim().isEmpty());

        if (!hasKeyword && !hasFilter && !hasCategory) {
            request.setAttribute("message", "Vui lòng nhập từ khóa tìm kiếm hoặc chọn bộ lọc");
            request.getRequestDispatcher("/search.jsp").forward(request, response);
            return;
        }

        if (hasKeyword && keyword.length() < 2 && !hasFilter && !hasCategory) {
            request.setAttribute("message", "Từ khóa tìm kiếm quá ngắn");
            request.getRequestDispatcher("/search.jsp").forward(request, response);
            return;
        }

        if (hasCategory) {
            try {
                int id = Integer.parseInt(categoryId);
                CategoriesService catService = new CategoriesService();
                Categories cat = catService.getCategory(id);

                if (cat != null) {
                    request.setAttribute("category", cat);
                    request.setAttribute("categoryName", cat.getName());
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        if (hasKeyword) {
            HttpSession session = request.getSession();
            List<String> searchHistory = (List<String>) session.getAttribute("searchHistory");
            if (searchHistory == null) searchHistory = new ArrayList<>();
            searchHistory.remove(keyword);
            searchHistory.add(0, keyword);
            if (searchHistory.size() > 5) searchHistory = new ArrayList<>(searchHistory.subList(0, 5));
            session.setAttribute("searchHistory", searchHistory);
        }

        ProductService productsService = new ProductService();
        CategoriesService categoriesService = new CategoriesService();
        BrandService brandService = new BrandService();

        List<Product> products = productsService.searchWithFilters(keyword, brands, priceRanges, categoryId, rating);
        if(products == null || products.isEmpty()) {
            List<Product> recommendations = productsService.getTopSellingProducts(10);
            request.setAttribute("recommendations", recommendations);
            request.setAttribute("isNoResult", true);
        }

        List<Categories> pCategories = categoriesService.getCategoriesWithChildren();
        List<Brands> allBrands = brandService.getAllBrands();

        request.setAttribute("keyword", keyword);
        request.setAttribute("selectedCategoryId", categoryId);
        request.setAttribute("parentCategories", pCategories);
        request.setAttribute("allBrands", allBrands);
        request.setAttribute("products", products);
        request.setAttribute("selectedBrands", brands);
        request.setAttribute("selectedPrices", priceRanges);

        request.setAttribute("selectedRating", rating);

        request.getRequestDispatcher("/search.jsp").forward(request, response);
    }
}