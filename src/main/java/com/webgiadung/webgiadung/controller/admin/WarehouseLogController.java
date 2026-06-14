package com.webgiadung.webgiadung.controller.admin;

import com.google.gson.Gson;
import com.webgiadung.webgiadung.dao.WarehouseTransactionDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/api/admin/warehouse/logs")
public class WarehouseLogController extends HttpServlet {

    private final WarehouseTransactionDao warehouseDao = new WarehouseTransactionDao();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String orderId = request.getParameter("orderId");
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");


            List<Map<String, Object>> list = warehouseDao.getOrderLogTransactions(orderId, fromDate, toDate);

            response.getWriter().write(gson.toJson(list));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("[]");
        }
    }
}