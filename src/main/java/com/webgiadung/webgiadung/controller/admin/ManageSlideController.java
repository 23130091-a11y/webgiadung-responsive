package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.dao.SlideDao;
import com.webgiadung.webgiadung.model.Slide;
import com.webgiadung.webgiadung.utils.FileUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.format.DateTimeFormatter;
import java.util.List;
@WebServlet("/api/admin/manage-slide")

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class ManageSlideController extends HttpServlet {

    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");

        try {
            if ("detail".equals(action)) {
                getSingleSlideDetail(request, out);
            } else {
                getAllSlidesList(out);
            }
        } catch (Exception e) {
            response.setStatus(500);
            out.print("{\"status\":\"error\", \"message\": \"Lỗi hệ thống: " + escapeJson(e.getMessage()) + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        try {
            if("update".equals(action)) {
                handleUpdateSlide(request, out);
            } else if("delete".equals(action)) {
                handleDeleteSlide(request, out);
            } else {
                response.setStatus(400);
                out.print("{\"status\":\"error\", \"message\": \"Hành động không hợp lệ\"}");
            }
        } catch (Exception e) {
            response.setStatus(500);
            out.print("{\"status\":\"error\", \"message\": \"Lỗi xử lý dữ liệu: " + escapeJson(e.getMessage()) + "\"}");
        }
    }

    private void handleDeleteSlide(HttpServletRequest request, PrintWriter out) {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            out.print("{\"status\":\"error\", \"message\": \"ID xóa không hợp lệ\"}");
            return;
        }

        int id = Integer.parseInt(idParam.trim());

        boolean isSuccess = SlideDao.deleteSlide(id);
        if (isSuccess) {
            out.print("{\"status\":\"success\"}");
        } else {
            out.print("{\"status\":\"error\", \"message\": \"Xóa slide thất bại trong cơ sở dữ liệu\"}");
        }
    }

    private void handleUpdateSlide(HttpServletRequest request, PrintWriter out) throws ServletException, IOException {
        String idParam = request.getParameter("slideId");
        String title = request.getParameter("title");
        String statusParam = request.getParameter("status");

        if (idParam == null || idParam.trim().isEmpty()) {
            out.print("{\"status\":\"error\", \"message\": \"Không tìm thấy ID slide cần cập nhật\"}");
            return;
        }

        int id = Integer.parseInt(idParam.trim());
        int status = Integer.parseInt(statusParam);

        Slide slide = SlideDao.getById(id);
        if (slide == null) {
            out.print("{\"status\":\"error\", \"message\": \"Slide không tồn tại trên hệ thống\"}");
            return;
        }

        Part filePart = request.getPart("banner");
        String bannerPart = slide.getBanner();
        if(filePart != null && filePart.getSize() > 0) {
            String realPath = getServletContext().getRealPath("/");
            bannerPart = FileUtils.saveFile(filePart, realPath, "slides");
        }

        slide.setTitle(title);
        slide.setStatus(status);
        slide.setBanner(bannerPart);

        boolean isSuccess = SlideDao.updateSlide(slide);

        if (isSuccess) {
            out.print("{\"status\":\"success\"}");
        } else {
            out.print("{\"status\":\"error\", \"message\": \"Cập nhật cơ sở dữ liệu thất bại\"}");
        }
    }

    private void getAllSlidesList(PrintWriter out) {

        List<Slide> listSlides = SlideDao.getAllSlides();

        StringBuilder json = new StringBuilder();
        json.append("[");

        for (int i = 0; i < listSlides.size(); i++) {
            Slide s = listSlides.get(i);


            String createdAtStr = (s.getCreatedAt() != null) ? s.getCreatedAt().format(formatter) : "Chưa cập nhật";
            String updatedAtStr = (s.getUpdatedAt() != null) ? s.getUpdatedAt().format(formatter) : "Chưa cập nhật";

            json.append("{");
            json.append("\"id\": ").append(s.getId()).append(",");
            json.append("\"title\": \"").append(escapeJson(s.getTitle())).append("\",");
            json.append("\"banner\": \"").append(escapeJson(s.getBanner())).append("\",");
            json.append("\"status\": ").append(s.getStatus()).append(",");
            json.append("\"createdAt\": \"").append(createdAtStr).append("\",");
            json.append("\"updatedAt\": \"").append(updatedAtStr).append("\"");
            json.append("}");


            if (i < listSlides.size() - 1) {
                json.append(",");
            }
        }

        json.append("]");
        out.print(json.toString());
    }

    private void getSingleSlideDetail(HttpServletRequest request, PrintWriter out) {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            out.print("{\"status\":\"error\", \"message\": \"ID slide không hợp lệ\"}");
            return;
        }
        try {
            int id = Integer.parseInt(idParam.trim());
            Slide slide = SlideDao.getById(id);

            if (slide != null) {
                String createdAtStr = (slide.getCreatedAt() != null) ? slide.getCreatedAt().format(formatter) : "Chưa cập nhật";
                String updatedAtStr = (slide.getUpdatedAt() != null) ? slide.getUpdatedAt().format(formatter) : "Chưa cập nhật";
                StringBuilder json = new StringBuilder();
                json.append("{");
                json.append("\"status\": \"success\",");
                json.append("\"id\": ").append(slide.getId()).append(",");
                json.append("\"title\": \"").append(escapeJson(slide.getTitle())).append("\",");
                json.append("\"banner\": \"").append(escapeJson(slide.getBanner())).append("\",");
                json.append("\"description\": \"").append(escapeJson(slide.getDescription())).append("\",");
                json.append("\"statusValue\": ").append(slide.getStatus()).append(",");
                json.append("\"createdAt\": \"").append(createdAtStr).append("\",");
                json.append("\"updatedAt\": \"").append(updatedAtStr).append("\"");
                json.append("}");
                out.print(json.toString());
            } else {
                out.print("{\"status\":\"error\", \"message\": \"Không tìm thấy slide yêu cầu\"}");
            }
        } catch (NumberFormatException e) {
                out.print("{\"status\":\"error\", \"message\": \"Định dạng ID phải là số lẻ\"}");
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", " ")
                .replace("\r", "");
    }
}