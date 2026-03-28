package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.model.*;
import com.webgiadung.webgiadung.services.BrandService;
import com.webgiadung.webgiadung.services.DiscountService;
import com.webgiadung.webgiadung.services.KeywordService;
import com.webgiadung.webgiadung.services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.StringJoiner;

@WebServlet("/api/product-detail")
public class ProductViewController extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final DiscountService discountService = new DiscountService(); // Khởi tạo DiscountService
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    private final BrandService brandService = new BrandService();
    private final KeywordService keywordService = new KeywordService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        String idParam = request.getParameter("id");

        try {
            if (idParam != null && !idParam.isEmpty()) {
                int id = Integer.parseInt(idParam);
                Product p = productService.getProductFullInfo(id);

                if (p != null) {
                    String name = escapeJson(p.getName());
                    String image = escapeJson(p.getImage());
                    Brands brand = brandService.getBrandById(p.getBrandsId());
                    String brandName = (brand != null) ? escapeJson(brand.getName()) : "Chưa cập nhật";

                    String createdAt = (p.getCreatedAt() != null) ? p.getCreatedAt().format(formatter) : "";
                    String updatedAt = (p.getUpdatedAt() != null) ? p.getUpdatedAt().format(formatter) : "";

                    double discountPercent = 0;
                    if (p.getDiscountsId() > 0) {
                        Discounts d = discountService.getDiscountById(p.getDiscountsId());
                        if (d != null) {
                            discountPercent = d.getDiscountValue(); // Lấy giá trị % từ bảng discounts
                        }
                    }

                    long firstPrice = (long) p.getFirstPrice();
                    long currentPrice = (long) p.getTotalPrice();

                    StringBuilder json = new StringBuilder();
                    json.append("{");

                    json.append("\"id\": ").append(p.getId()).append(",");
                    json.append("\"name\": \"").append(name).append("\",");
                    json.append("\"image\": \"").append(image).append("\",");

                    json.append("\"brandId\": ").append(p.getBrandsId()).append(",");

                    // JSON trả về dữ liệu lấy từ Service
                    json.append("\"firstPrice\": ").append(firstPrice).append(",");
                    json.append("\"price\": ").append(currentPrice).append(",");
                    json.append("\"discountPercent\": ").append(discountPercent).append(",");

                    json.append("\"quantity\": ").append(p.getQuantity()).append(",");
                    json.append("\"quantitySaled\": ").append(p.getSoldQuantity()).append(",");
                    json.append("\"post\": ").append(p.getIsVisible()).append(",");

                    json.append("\"brandName\": \"").append(brandName).append("\",");

                    json.append("\"createdAt\": \"").append(createdAt).append("\",");
                    json.append("\"updatedAt\": \"").append(updatedAt).append("\",");

                    // Xử lý Descriptions
                    json.append("\"descriptions\": [");
                    List<ProductDescriptions> descList = p.getDescriptions();
                    if (descList != null && !descList.isEmpty()) {
                        StringJoiner sjDesc = new StringJoiner(",");
                        for (ProductDescriptions d : descList) {
                            String dTitle = escapeJson(d.getAttrName());
                            String dContent = escapeJson(d.getValue());
                            sjDesc.add("{\"id\":" + d.getId() + ", \"title\":\"" + dTitle + "\", \"description\":\"" + dContent + "\"}");
                        }
                        json.append(sjDesc.toString());
                    }
                    json.append("],");

                    // Xử lý Details
                    json.append("\"details\": [");
                    List<ProductDetails> detailList = p.getDetails();
                    if (detailList != null && !detailList.isEmpty()) {
                        StringJoiner sjDetail = new StringJoiner(",");
                        for (ProductDetails d : detailList) {
                            String dtTitle = escapeJson(d.getTitle());
                            String dtContent = escapeJson(d.getDescription());
                            String dtImage = escapeJson(d.getImage());
                            sjDetail.add("{\"id\":" + d.getId() + ", \"title\":\"" + dtTitle + "\", \"description\":\"" + dtContent + "\", \"image\":\"" + dtImage + "\"}");
                        }
                        json.append(sjDetail.toString());
                    }
                    json.append("],");
                    json.append("\"keywords\": [");
                    List<Keywords> keywordList = p.getKeywords();
                    if (keywordList != null && !keywordList.isEmpty()) {
                        StringJoiner sjKeyword = new StringJoiner(",");
                        for (Keywords k : keywordList) {
                            String kName = escapeJson(k.getName());

                            sjKeyword.add("{\"id\":" + k.getId() + ", \"name\":\"" + kName + "\"}");

                        }
                        json.append(sjKeyword.toString());
                    }
                    json.append("]");
                    json.append("}");


                    out.print(json.toString());
                } else {
                    response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                    out.print("{\"error\": \"Không tìm thấy sản phẩm\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\": \"Thiếu ID sản phẩm\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Lỗi Server: " + escapeJson(e.getMessage()) + "\"}");
        } finally {
            out.flush();
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", "")
                .replace("\t", " ");
    }
}