package com.webgiadung.webgiadung.controller.admin;

import com.google.gson.Gson;
import com.webgiadung.webgiadung.dao.WarehouseTransactionDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/api/admin/warehouse/damage")
public class WarehouseDamageController extends HttpServlet {
    private final WarehouseTransactionDao transactionDao = new WarehouseTransactionDao();
    private final Gson gson = new Gson();

    private static class DamageRequest {
        int productId;
        int quantity;
        String note;
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {

            List<Map<String, Object>> listDamage = transactionDao.getDamagedTransactions();

            response.getWriter().write(gson.toJson(listDamage));
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Map<String, Object> resultMap = new HashMap<>();

        try {
            DamageRequest reqData = gson.fromJson(request.getReader(), DamageRequest.class);

            if (reqData == null || reqData.productId <= 0 || reqData.quantity <= 0) {
                throw new Exception("Dữ liệu sản phẩm hoặc số lượng hư hỏng không hợp lệ.");
            }


            boolean success = transactionDao.handleDamagedTransaction(
                    reqData.productId,
                    reqData.quantity,
                   reqData.note
            );

            if (success) {
                resultMap.put("success", true);
                resultMap.put("message", "Báo cáo sản phẩm hư hỏng và cập nhật kho thành công!");
            } else {
                resultMap.put("success", false);
                resultMap.put("message", "Không thể hoàn tất thao tác giao dịch kho.");
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