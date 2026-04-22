package com.webgiadung.webgiadung.controller.admin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializer;
import com.webgiadung.webgiadung.model.InboundDetails;
import com.webgiadung.webgiadung.model.Product;
import com.webgiadung.webgiadung.services.InboundDetailsService;
import com.webgiadung.webgiadung.services.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "GetListInboundAPI", urlPatterns = {"/api/admin/warehouse/history"})
public class GetListInboundController extends HttpServlet {

    private final InboundDetailsService inboundDetailsService = new InboundDetailsService();
    private final ProductService productService = new ProductService();

    // Khởi tạo Gson với Adapter xử lý ngày tháng giống WarehouseImportController
    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                    new JsonPrimitive(src.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss"))))
            .create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<InboundDetails> historyList = inboundDetailsService.getImportHistory();
            Map<Integer, Product> productCache = new HashMap<>();
            List<Map<String, Object>> responseData = new ArrayList<>();

            for (InboundDetails item : historyList) {
                int pId = item.getProductId();

                // Cache sản phẩm để tránh gọi Database liên tục trong vòng lặp
                if (!productCache.containsKey(pId)) {
                    productCache.put(pId, productService.getProductFullInfo(pId));
                }
                Product prod = productCache.get(pId);

                Map<String, Object> row = new HashMap<>();
                row.put("receiptCode", item.getReceiptCode());
                row.put("createdAt", item.getCreatedAt()); // Để Gson tự format qua Adapter
                row.put("importQty", item.getImportQty());
                row.put("preStockQty", item.getPreStockQty());
                row.put("totalPrice", item.getTotalPrice());
                row.put("unitCost", item.getUnitCost());
                row.put("supplierName", item.getSupplierName());
                row.put("productName", prod != null ? prod.getName() : "Không xác định");
                row.put("productImage", prod != null ? prod.getImage() : "default.png");

                responseData.add(row);
            }

            response.getWriter().print(gson.toJson(responseData));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().print("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}