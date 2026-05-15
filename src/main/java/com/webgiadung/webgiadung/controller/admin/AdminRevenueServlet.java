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

        request.setAttribute("revenueSummary",
                orderDao.getRevenueSummary(fromDate, toDate, status, monthA, monthB));

        request.setAttribute("dailyRevenueList",
                orderDao.getRevenueByDate(fromDate, toDate, status));

        request.setAttribute("topSellingProducts",
                orderDao.getTopSellingProducts(fromDate, toDate, status, 10));

        request.setAttribute("orderStatusStats",
                orderDao.getOrderStatusStats(fromDate, toDate));

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