package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.dao.OrderDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminRevenueExportServlet", value = "/admin/revenue/export")
public class AdminRevenueExportServlet extends HttpServlet {

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
        if (monthB.isBlank()) monthB = now.toString();
        if (monthA.isBlank()) monthA = now.minusMonths(1).toString();

        Map<String, Object> revenueSummary = orderDao.getRevenueSummary(fromDate, toDate, status, monthA, monthB);
        Map<String, Object> orderStatusStats = orderDao.getOrderStatusStats(fromDate, toDate);
        List<Map<String, Object>> dailyRevenueList = orderDao.getRevenueByDate(fromDate, toDate, status);
        List<Map<String, Object>> topSellingProducts = orderDao.getTopSellingProducts(fromDate, toDate, status, 10);
        List<Map<String, Object>> productMonthCompareList = orderDao.getProductMonthComparison(monthA, monthB, 20);
        List<Map<String, Object>> importBatchSalesList = orderDao.getImportBatchSalesReport(50);

        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/vnd.ms-excel; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=bao-cao-doanh-thu.xls");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");

        try (PrintWriter out = response.getWriter()) {
            writeWorkbookStart(out);
            writeStyles(out);

            writeOverviewSheet(out, fromDate, toDate, status, monthA, monthB, revenueSummary, orderStatusStats);
            writeDailyRevenueSheet(out, dailyRevenueList);
            writeTopProductSheet(out, topSellingProducts);
            writeProductCompareSheet(out, monthA, monthB, productMonthCompareList);
            writeImportBatchSheet(out, importBatchSalesList);

            writeWorkbookEnd(out);
        }
    }

    private void writeWorkbookStart(PrintWriter out) {
        out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        out.println("<?mso-application progid=\"Excel.Sheet\"?>");
        out.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        out.println(" xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
        out.println(" xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
        out.println(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
        out.println(" xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
        out.println("<DocumentProperties xmlns=\"urn:schemas-microsoft-com:office:office\">");
        out.println("<Author>WebGiaDung</Author>");
        out.println("<Title>Báo cáo doanh thu cửa hàng</Title>");
        out.println("</DocumentProperties>");
        out.println("<ExcelWorkbook xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        out.println("<WindowHeight>9000</WindowHeight>");
        out.println("<WindowWidth>16000</WindowWidth>");
        out.println("<ProtectStructure>False</ProtectStructure>");
        out.println("<ProtectWindows>False</ProtectWindows>");
        out.println("</ExcelWorkbook>");
    }

    private void writeWorkbookEnd(PrintWriter out) {
        out.println("</Workbook>");
    }

    private void writeStyles(PrintWriter out) {
        out.println("<Styles>");

        out.println("<Style ss:ID=\"Default\" ss:Name=\"Normal\">");
        out.println("<Alignment ss:Vertical=\"Center\"/>");
        out.println("<Font ss:FontName=\"Arial\" ss:Size=\"11\" ss:Color=\"#222222\"/>");
        out.println("</Style>");

        out.println("<Style ss:ID=\"Title\">");
        out.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        out.println("<Font ss:FontName=\"Arial\" ss:Size=\"18\" ss:Bold=\"1\" ss:Color=\"#FFFFFF\"/>");
        out.println("<Interior ss:Color=\"#E88900\" ss:Pattern=\"Solid\"/>");
        out.println("</Style>");

        out.println("<Style ss:ID=\"SubTitle\">");
        out.println("<Alignment ss:Vertical=\"Center\"/>");
        out.println("<Font ss:FontName=\"Arial\" ss:Size=\"10\" ss:Color=\"#666666\"/>");
        out.println("</Style>");

        out.println("<Style ss:ID=\"Section\">");
        out.println("<Alignment ss:Vertical=\"Center\"/>");
        out.println("<Font ss:FontName=\"Arial\" ss:Size=\"13\" ss:Bold=\"1\" ss:Color=\"#D97706\"/>");
        out.println("<Interior ss:Color=\"#FFF3DD\" ss:Pattern=\"Solid\"/>");
        out.println("<Borders>");
        out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" ss:Color=\"#EADFC9\"/>");
        out.println("</Borders>");
        out.println("</Style>");

        out.println("<Style ss:ID=\"Header\">");
        out.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        out.println("<Font ss:FontName=\"Arial\" ss:Size=\"11\" ss:Bold=\"1\" ss:Color=\"#FFFFFF\"/>");
        out.println("<Interior ss:Color=\"#F6A500\" ss:Pattern=\"Solid\"/>");
        out.println("<Borders>");
        borderAll(out, "#D9A441");
        out.println("</Borders>");
        out.println("</Style>");

        out.println("<Style ss:ID=\"Text\">");
        out.println("<Alignment ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        out.println("<Borders>");
        borderAll(out, "#E5E7EB");
        out.println("</Borders>");
        out.println("</Style>");

        out.println("<Style ss:ID=\"TextCenter\">");
        out.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        out.println("<Borders>");
        borderAll(out, "#E5E7EB");
        out.println("</Borders>");
        out.println("</Style>");

        out.println("<Style ss:ID=\"Number\">");
        out.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        out.println("<NumberFormat ss:Format=\"#,##0\"/>");
        out.println("<Borders>");
        borderAll(out, "#E5E7EB");
        out.println("</Borders>");
        out.println("</Style>");

        out.println("<Style ss:ID=\"Money\">");
        out.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        out.println("<NumberFormat ss:Format=\"#,##0\"/>");
        out.println("<Borders>");
        borderAll(out, "#E5E7EB");
        out.println("</Borders>");
        out.println("</Style>");

        out.println("<Style ss:ID=\"Percent\">");
        out.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        out.println("<NumberFormat ss:Format=\"0.00%\"/>");
        out.println("<Borders>");
        borderAll(out, "#E5E7EB");
        out.println("</Borders>");
        out.println("</Style>");

        out.println("<Style ss:ID=\"KpiLabel\">");
        out.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\" ss:WrapText=\"1\"/>");
        out.println("<Font ss:FontName=\"Arial\" ss:Size=\"10\" ss:Bold=\"1\" ss:Color=\"#9A5A00\"/>");
        out.println("<Interior ss:Color=\"#FFF8EC\" ss:Pattern=\"Solid\"/>");
        out.println("<Borders>");
        borderAll(out, "#EADFC9");
        out.println("</Borders>");
        out.println("</Style>");

        out.println("<Style ss:ID=\"KpiValue\">");
        out.println("<Alignment ss:Horizontal=\"Center\" ss:Vertical=\"Center\"/>");
        out.println("<Font ss:FontName=\"Arial\" ss:Size=\"14\" ss:Bold=\"1\" ss:Color=\"#1F2937\"/>");
        out.println("<Interior ss:Color=\"#FFFFFF\" ss:Pattern=\"Solid\"/>");
        out.println("<Borders>");
        borderAll(out, "#EADFC9");
        out.println("</Borders>");
        out.println("</Style>");

        out.println("<Style ss:ID=\"DangerText\">");
        out.println("<Alignment ss:Horizontal=\"Right\" ss:Vertical=\"Center\"/>");
        out.println("<Font ss:FontName=\"Arial\" ss:Size=\"11\" ss:Bold=\"1\" ss:Color=\"#D93025\"/>");
        out.println("<NumberFormat ss:Format=\"#,##0\"/>");
        out.println("<Borders>");
        borderAll(out, "#E5E7EB");
        out.println("</Borders>");
        out.println("</Style>");

        out.println("</Styles>");
    }

    private void borderAll(PrintWriter out, String color) {
        out.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" ss:Color=\"" + color + "\"/>");
        out.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" ss:Color=\"" + color + "\"/>");
        out.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" ss:Color=\"" + color + "\"/>");
        out.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\" ss:Color=\"" + color + "\"/>");
    }

    private void writeOverviewSheet(PrintWriter out, String fromDate, String toDate, String status,
                                    String monthA, String monthB,
                                    Map<String, Object> revenueSummary,
                                    Map<String, Object> orderStatusStats) {
        startSheet(out, "Tong quan");
        columns(out, 160, 160, 160, 160, 160, 160);

        titleRow(out, "BÁO CÁO DOANH THU CỬA HÀNG", 5);
        subtitleRow(out, "Từ ngày: " + emptyDash(fromDate)
                + " | Đến ngày: " + emptyDash(toDate)
                + " | Trạng thái: " + statusText(status)
                + " | Tháng A: " + formatMonthLabel(monthA)
                + " | Tháng B: " + formatMonthLabel(monthB), 5);
        emptyRow(out);

        sectionRow(out, "1. Tổng quan doanh thu", 5);
        out.println("<Row ss:Height=\"26\">");
        cell(out, "Doanh thu hôm nay", "KpiLabel");
        cell(out, "Doanh thu " + formatMonthLabel(monthA), "KpiLabel");
        cell(out, "Doanh thu " + formatMonthLabel(monthB), "KpiLabel");
        cell(out, "Tổng số đơn", "KpiLabel");
        cell(out, "Số đơn hủy", "KpiLabel");
        cell(out, "Tỷ lệ hủy", "KpiLabel");
        out.println("</Row>");

        out.println("<Row ss:Height=\"34\">");
        cellNumber(out, revenueSummary.get("today_revenue"), "KpiValue");
        cellNumber(out, revenueSummary.get("month_a_revenue"), "KpiValue");
        cellNumber(out, revenueSummary.get("month_b_revenue"), "KpiValue");
        cellNumber(out, revenueSummary.get("total_orders"), "KpiValue");
        cellNumber(out, revenueSummary.get("cancelled_orders"), "KpiValue");
        cellPercent(out, revenueSummary.get("cancel_rate"), "KpiValue");
        out.println("</Row>");

        emptyRow(out);
        sectionRow(out, "2. Thống kê trạng thái đơn hàng", 5);
        tableHeader(out, "Trạng thái", "Số đơn", "", "", "", "");
        rowTextNumber(out, "Chờ xử lý", orderStatusStats.get("pending_orders"));
        rowTextNumber(out, "Đang giao", orderStatusStats.get("shipping_orders"));
        rowTextNumber(out, "Hoàn tất", orderStatusStats.get("completed_orders"));
        rowTextNumber(out, "Đã hủy", orderStatusStats.get("cancelled_orders"));

        endSheet(out, 6);
    }

    private void writeDailyRevenueSheet(PrintWriter out, List<Map<String, Object>> dailyRevenueList) {
        startSheet(out, "Doanh thu ngay");
        columns(out, 120, 100, 130, 100, 130, 130);

        titleRow(out, "DOANH THU THEO NGÀY", 5);
        subtitleRow(out, "Bảng này thể hiện doanh thu gộp, giá trị đơn hủy và doanh thu thực theo từng ngày.", 5);
        emptyRow(out);

        tableHeader(out, "Ngày", "Tổng đơn", "Doanh thu gộp", "Đơn hủy", "Giá trị hủy", "Doanh thu thực");

        if (dailyRevenueList.isEmpty()) {
            emptyDataRow(out, "Không có dữ liệu", 5);
        } else {
            for (Map<String, Object> r : dailyRevenueList) {
                out.println("<Row>");
                cell(out, formatDateText(r.get("order_date")), "TextCenter");
                cellNumber(out, r.get("total_orders"), "Number");
                cellNumber(out, r.get("gross_revenue"), "Money");
                cellNumber(out, r.get("cancelled_orders"), "Number");
                cellNumber(out, r.get("cancelled_value"), "DangerText");
                cellNumber(out, r.get("net_revenue"), "Money");
                out.println("</Row>");
            }
        }

        endSheet(out, 4);
    }

    private void writeTopProductSheet(PrintWriter out, List<Map<String, Object>> topSellingProducts) {
        startSheet(out, "Top san pham");
        columns(out, 90, 360, 120, 140);

        titleRow(out, "TOP SẢN PHẨM BÁN CHẠY", 3);
        subtitleRow(out, "Danh sách sản phẩm có số lượng bán tốt nhất trong bộ lọc doanh thu.", 3);
        emptyRow(out);

        tableHeader(out, "Mã SP", "Tên sản phẩm", "Số lượng bán", "Doanh thu");

        if (topSellingProducts.isEmpty()) {
            emptyDataRow(out, "Không có dữ liệu", 3);
        } else {
            for (Map<String, Object> r : topSellingProducts) {
                out.println("<Row>");
                cellNumber(out, r.get("product_id"), "Number");
                cell(out, r.get("product_name"), "Text");
                cellNumber(out, r.get("sold_qty"), "Number");
                cellNumber(out, r.get("revenue"), "Money");
                out.println("</Row>");
            }
        }

        endSheet(out, 4);
    }

    private void writeProductCompareSheet(PrintWriter out, String monthA, String monthB,
                                          List<Map<String, Object>> productMonthCompareList) {
        startSheet(out, "So sanh thang");
        columns(out, 90, 360, 120, 120, 150, 150);

        titleRow(out, "SO SÁNH SẢN PHẨM THEO THÁNG", 5);
        subtitleRow(out, "So sánh số lượng bán và doanh thu giữa " + formatMonthLabel(monthA)
                + " và " + formatMonthLabel(monthB) + ".", 5);
        emptyRow(out);

        tableHeader(out,
                "Mã SP",
                "Tên sản phẩm",
                "SL " + formatMonthLabel(monthA),
                "SL " + formatMonthLabel(monthB),
                "Doanh thu " + formatMonthLabel(monthA),
                "Doanh thu " + formatMonthLabel(monthB));

        if (productMonthCompareList.isEmpty()) {
            emptyDataRow(out, "Không có dữ liệu", 5);
        } else {
            for (Map<String, Object> r : productMonthCompareList) {
                out.println("<Row>");
                cellNumber(out, r.get("product_id"), "Number");
                cell(out, r.get("product_name"), "Text");
                cellNumber(out, r.get("month_a_qty"), "Number");
                cellNumber(out, r.get("month_b_qty"), "Number");
                cellNumber(out, r.get("month_a_revenue"), "Money");
                cellNumber(out, r.get("month_b_revenue"), "Money");
                out.println("</Row>");
            }
        }

        endSheet(out, 4);
    }

    private void writeImportBatchSheet(PrintWriter out, List<Map<String, Object>> importBatchSalesList) {
        startSheet(out, "Dot nhap hang");
        columns(out, 150, 160, 80, 350, 110, 100, 120, 140, 150, 130, 100, 130);

        titleRow(out, "HIỆU QUẢ THEO ĐỢT NHẬP HÀNG", 11);
        subtitleRow(out, "Theo dõi lượng bán, số đơn bán và tồn ước tính từ từng đợt nhập.", 11);
        emptyRow(out);

        tableHeader(out,
                "Mã phiếu", "Nhà cung cấp", "Mã SP", "Tên sản phẩm",
                "SL trước nhập", "SL nhập", "Giá nhập", "Tổng tiền nhập",
                "Ngày nhập", "SL bán từ đợt nhập", "Số đơn bán", "Ước tính còn lại");

        if (importBatchSalesList.isEmpty()) {
            emptyDataRow(out, "Không có dữ liệu", 11);
        } else {
            for (Map<String, Object> r : importBatchSalesList) {
                out.println("<Row>");
                cell(out, r.get("receipt_code"), "Text");
                cell(out, r.get("supplier_name"), "Text");
                cellNumber(out, r.get("product_id"), "Number");
                cell(out, r.get("product_name"), "Text");
                cellNumber(out, r.get("pre_stock_qty"), "Number");
                cellNumber(out, r.get("import_qty"), "Number");
                cellNumber(out, r.get("unit_cost"), "Money");
                cellNumber(out, r.get("total_price"), "Money");
                cell(out, formatDateText(r.get("imported_at")), "TextCenter");
                cellNumber(out, r.get("sold_qty_since_import"), "Number");
                cellNumber(out, r.get("sold_order_count"), "Number");
                cellNumber(out, r.get("estimated_remaining_qty"), "Number");
                out.println("</Row>");
            }
        }

        endSheet(out, 4);
    }

    private void startSheet(PrintWriter out, String name) {
        out.println("<Worksheet ss:Name=\"" + escAttr(limitSheetName(name)) + "\">");
        out.println("<Table>");
    }

    private void endSheet(PrintWriter out, int frozenRow) {
        out.println("</Table>");
        out.println("<WorksheetOptions xmlns=\"urn:schemas-microsoft-com:office:excel\">");
        out.println("<FreezePanes/>");
        out.println("<FrozenNoSplit/>");
        out.println("<SplitHorizontal>" + frozenRow + "</SplitHorizontal>");
        out.println("<TopRowBottomPane>" + frozenRow + "</TopRowBottomPane>");
        out.println("<ProtectObjects>False</ProtectObjects>");
        out.println("<ProtectScenarios>False</ProtectScenarios>");
        out.println("</WorksheetOptions>");
        out.println("</Worksheet>");
    }

    private void columns(PrintWriter out, int... widths) {
        for (int width : widths) {
            out.println("<Column ss:Width=\"" + width + "\"/>");
        }
    }

    private void titleRow(PrintWriter out, String title, int mergeAcross) {
        out.println("<Row ss:Height=\"34\">");
        out.println("<Cell ss:MergeAcross=\"" + mergeAcross + "\" ss:StyleID=\"Title\"><Data ss:Type=\"String\">" + esc(title) + "</Data></Cell>");
        out.println("</Row>");
    }

    private void subtitleRow(PrintWriter out, String title, int mergeAcross) {
        out.println("<Row ss:Height=\"24\">");
        out.println("<Cell ss:MergeAcross=\"" + mergeAcross + "\" ss:StyleID=\"SubTitle\"><Data ss:Type=\"String\">" + esc(title) + "</Data></Cell>");
        out.println("</Row>");
    }

    private void sectionRow(PrintWriter out, String title, int mergeAcross) {
        out.println("<Row ss:Height=\"26\">");
        out.println("<Cell ss:MergeAcross=\"" + mergeAcross + "\" ss:StyleID=\"Section\"><Data ss:Type=\"String\">" + esc(title) + "</Data></Cell>");
        out.println("</Row>");
    }

    private void emptyRow(PrintWriter out) {
        out.println("<Row ss:Height=\"8\"/>");
    }

    private void tableHeader(PrintWriter out, String... headers) {
        out.println("<Row ss:Height=\"28\">");
        for (String header : headers) {
            if (header == null || header.isBlank()) {
                cell(out, "", "Header");
            } else {
                cell(out, header, "Header");
            }
        }
        out.println("</Row>");
    }

    private void rowTextNumber(PrintWriter out, String label, Object value) {
        out.println("<Row>");
        cell(out, label, "Text");
        cellNumber(out, value, "Number");
        out.println("</Row>");
    }

    private void emptyDataRow(PrintWriter out, String text, int mergeAcross) {
        out.println("<Row>");
        out.println("<Cell ss:MergeAcross=\"" + mergeAcross + "\" ss:StyleID=\"TextCenter\"><Data ss:Type=\"String\">" + esc(text) + "</Data></Cell>");
        out.println("</Row>");
    }

    private void cell(PrintWriter out, Object value, String styleId) {
        out.println("<Cell ss:StyleID=\"" + styleId + "\"><Data ss:Type=\"String\">" + esc(value == null ? "" : value.toString()) + "</Data></Cell>");
    }

    private void cellNumber(PrintWriter out, Object value, String styleId) {
        double number = toDouble(value);
        out.println("<Cell ss:StyleID=\"" + styleId + "\"><Data ss:Type=\"Number\">" + plainNumber(number) + "</Data></Cell>");
    }

    private void cellPercent(PrintWriter out, Object value, String styleId) {
        double number = toDouble(value) / 100.0;
        out.println("<Cell ss:StyleID=\"" + styleId + "\"><Data ss:Type=\"Number\">" + plainNumber(number) + "</Data></Cell>");
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private String emptyDash(String value) {
        return value == null || value.isBlank() ? "Tất cả" : value;
    }

    private String formatMonthLabel(String ym) {
        try {
            YearMonth yearMonth = YearMonth.parse(ym);
            return yearMonth.format(DateTimeFormatter.ofPattern("MM/yyyy"));
        } catch (Exception e) {
            return ym == null ? "" : ym;
        }
    }

    private String statusText(String status) {
        if (status == null || status.isBlank()) return "Tất cả";
        return switch (status) {
            case "pending" -> "Chờ xử lý";
            case "shipping" -> "Đang giao";
            case "done" -> "Hoàn tất";
            case "cancelled" -> "Đã hủy";
            default -> status;
        };
    }

    private String formatDateText(Object value) {
        if (value == null) return "";
        return value.toString()
                .replace("T", " ")
                .replace(".0", "");
    }

    private String limitSheetName(String name) {
        if (name == null || name.isBlank()) return "Sheet";
        String cleaned = name.replace("[", "")
                .replace("]", "")
                .replace("*", "")
                .replace("?", "")
                .replace("/", "-")
                .replace("\\", "-");
        return cleaned.length() > 31 ? cleaned.substring(0, 31) : cleaned;
    }

    private double toDouble(Object value) {
        if (value == null) return 0;
        try {
            return new BigDecimal(value.toString()).doubleValue();
        } catch (Exception e) {
            return 0;
        }
    }

    private String plainNumber(double value) {
        if (Math.floor(value) == value) {
            return String.valueOf((long) value);
        }
        return BigDecimal.valueOf(value).stripTrailingZeros().toPlainString();
    }

    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String escAttr(String s) {
        return esc(s);
    }
}