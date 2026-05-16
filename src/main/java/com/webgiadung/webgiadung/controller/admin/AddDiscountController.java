package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.model.Discounts;
import com.webgiadung.webgiadung.services.DiscountService;
import com.webgiadung.webgiadung.services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;

@WebServlet("/admin/add-discount")
@MultipartConfig
public class AddDiscountController extends HttpServlet {

    private final DiscountService discountService = new DiscountService();
    private final ProductService productService = new ProductService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String name = request.getParameter("eventName");
            String discountValueRaw = request.getParameter("discountValue");
            String startDateRaw = request.getParameter("startDate");
            String endDateRaw = request.getParameter("endDate");

            String scope = request.getParameter("applyScope");
            String safeScope = (scope != null) ? scope.trim().toLowerCase() : "";

            String type = request.getParameter("discountType");
            String catIdRaw = request.getParameter("applyCategories");

            if (name == null || name.isBlank() || discountValueRaw == null || startDateRaw == null || endDateRaw == null) {
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Vui lòng điền đầy đủ thông tin!\"}");
                return;
            }

            double value = Double.parseDouble(discountValueRaw);
            if (value <= 0) {
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Mức giảm phải lớn hơn 0!\"}");
                return;
            }

            if ("percentage".equals(type) && value > 100) {
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Giảm theo phần trăm không được quá 100%!\"}");
                return;
            }

            int idCate = 0;

            if ("category".equals(safeScope)) {
                if (catIdRaw == null || catIdRaw.isEmpty() || "0".equals(catIdRaw)) {
                    response.getWriter().write("{\"status\":\"error\", \"message\":\"Vui lòng chọn danh mục áp dụng!\"}");
                    return;
                }
                idCate = Integer.parseInt(catIdRaw);
            }

            LocalDateTime start = LocalDate.parse(startDateRaw).atStartOfDay();
            LocalDateTime end = LocalDate.parse(endDateRaw).atTime(23, 59, 59);
            LocalDateTime todayStart = LocalDate.now().atStartOfDay();

            if (start.isBefore(todayStart)) {
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Ngày bắt đầu không được nhỏ hơn ngày hôm nay!\"}");
                return;
            }

            if (start.isAfter(end)) {
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Lỗi: Ngày bắt đầu phải trước ngày kết thúc!\"}");
                return;
            }

            Discounts d = new Discounts();
            d.setName(name);
            d.setDiscountValue(value);
            d.setStartDate(start);
            d.setEndDate(end);
            d.setCategoryId(idCate);

            d.setStatus(1);

            if ("percentage".equals(type)) {
                d.setDiscountType("percentage");
            } else {
                d.setDiscountType("fixed");
            }

            int newDiscountId = discountService.insertDiscount(d);

            if (newDiscountId > 0) {
                if ("category".equals(safeScope) && idCate > 0) {
                    productService.applyDiscountToCategory(idCate, newDiscountId);
                } else if ("all".equals(safeScope)) {
                    productService.applyDiscountToAll(newDiscountId);
                }

                response.getWriter().write("{\"status\":\"success\"}");
            } else {
                response.getWriter().write("{\"status\":\"error\", \"message\":\"Lỗi hệ thống: Không thể lưu Discount vào database.\"}");
            }

        } catch (java.time.format.DateTimeParseException e) {
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Ngày tháng không đúng định dạng!\"}");
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Giá trị giảm giá phải là số!\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\", \"message\":\"Lỗi không xác định: " + e.getMessage() + "\"}");
        }
    }
}