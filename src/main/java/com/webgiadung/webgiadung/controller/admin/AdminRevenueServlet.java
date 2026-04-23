package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.dao.OrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
@WebServlet(name = "AdminRevenueServlet", value = "/admin/revenue")
public class AdminRevenueServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fromDate = trim(request.getParameter("fromDate"));
        String toDate = trim(request.getParameter("toDate"));
        String status = trim(request.getParameter("status"));

        String monthA = trim(request.getParameter("monthA"));
        String monthB = trim(request.getParameter("monthB"));

        YearMonth now = YearMonth.now();
        if (monthB.isBlank()) {
            monthB = now.toString();
        }
        if (monthA.isBlank()) {
            monthA = now.minusMonths(1).toString();
        }

        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("status", status);

        request.setAttribute("monthA", monthA);
        request.setAttribute("monthB", monthB);
        request.setAttribute("monthALabel", formatMonthLabel(monthA));
        request.setAttribute("monthBLabel", formatMonthLabel(monthB));

        Map<String, Object> revenueSummary =
                orderDao.getRevenueSummary(fromDate, toDate, status, monthA, monthB);

        Map<String, Object> orderStatusStats =
                orderDao.getOrderStatusStats(fromDate, toDate);

        double totalOrders = 0;
        double completedOrders = 0;

        if (revenueSummary.get("total_orders") != null) {
            totalOrders = ((Number) revenueSummary.get("total_orders")).doubleValue();
        }

        if (orderStatusStats.get("completed_orders") != null) {
            completedOrders = ((Number) orderStatusStats.get("completed_orders")).doubleValue();
        }

        double completionRate = totalOrders == 0 ? 0 : (completedOrders * 100.0 / totalOrders);

        List<Map<String, Object>> monthlyRevenueChart = orderDao.getMonthlyRevenueChart(12);
        double maxMonthlyRevenue = 0;

        for (Map<String, Object> item : monthlyRevenueChart) {
            double revenue = item.get("revenue") == null ? 0 : ((Number) item.get("revenue")).doubleValue();
            if (revenue > maxMonthlyRevenue) {
                maxMonthlyRevenue = revenue;
            }
        }

        for (Map<String, Object> item : monthlyRevenueChart) {
            double revenue = item.get("revenue") == null ? 0 : ((Number) item.get("revenue")).doubleValue();
            double heightPercent = maxMonthlyRevenue == 0 ? 8 : Math.max(8, revenue * 100.0 / maxMonthlyRevenue);
            item.put("heightPercent", heightPercent);
        }

        request.setAttribute("revenueSummary", revenueSummary);

        request.setAttribute("dailyRevenueList",
                orderDao.getRevenueByDate(fromDate, toDate, status));

        request.setAttribute("topSellingProducts",
                orderDao.getTopSellingProducts(fromDate, toDate, status, 10));

        request.setAttribute("orderStatusStats", orderStatusStats);
        request.setAttribute("completionRate", completionRate);
        request.setAttribute("monthlyRevenueChart", monthlyRevenueChart);

        request.setAttribute("productMonthCompareList",
                orderDao.getProductMonthComparison(monthA, monthB, 20));

        request.setAttribute("importBatchSalesList",
                orderDao.getImportBatchSalesReport(50));
        request.setAttribute("tab", "config");
        request.getRequestDispatcher("/admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private String formatMonthLabel(String ym) {
        YearMonth yearMonth = YearMonth.parse(ym);
        return yearMonth.format(DateTimeFormatter.ofPattern("MM/yyyy"));
    }
}