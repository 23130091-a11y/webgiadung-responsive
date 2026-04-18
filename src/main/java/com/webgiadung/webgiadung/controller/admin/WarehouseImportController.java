package com.webgiadung.webgiadung.controller.admin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializer;
import com.webgiadung.webgiadung.model.InboundDetails;
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
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/admin/warehouse/import")
public class WarehouseImportController extends HttpServlet {
    private final InboundDetailsService inboundService = new InboundDetailsService();
    private final ProductService productService = new ProductService();

    // Khởi tạo Gson với adapter cho LocalDateTime tương tự controller cũ của bạn
    private final Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDateTime.class, (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) ->
                    new JsonPrimitive(src.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)))
            .create();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> resultMap = new HashMap<>();

        try {

            InboundDetails details = gson.fromJson(request.getReader(), InboundDetails.class);

            if (details == null || details.getProductId() <= 0) {
                throw new Exception("Dữ liệu nhập kho không hợp lệ.");
            }

            boolean isInserted = inboundService.insertInbound(details);

            if (isInserted) {

                boolean isProductUpdated = productService.updateStockAndPrice(
                        details.getProductId(),
                        details.getImportQty(),
                        details.getUnitCost()
                );

                if (isProductUpdated) {
                    resultMap.put("success", true);
                    resultMap.put("message", "Nhập kho và cập nhật sản phẩm thành công!");
                } else {
                    resultMap.put("success", false);
                    resultMap.put("message", "Lưu lịch sử thành công nhưng cập nhật kho thất bại.");
                }
            } else {
                resultMap.put("success", false);
                resultMap.put("message", "Không thể lưu thông tin phiếu nhập.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resultMap.put("success", false);
            resultMap.put("message", "Lỗi: " + e.getMessage());
        }

        response.getWriter().write(gson.toJson(resultMap));
    }
}