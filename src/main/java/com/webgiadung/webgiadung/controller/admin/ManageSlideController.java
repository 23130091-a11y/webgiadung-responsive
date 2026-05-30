package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.dao.SlideDao;
import com.webgiadung.webgiadung.model.Slide;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.format.DateTimeFormatter;
import java.util.List;
@WebServlet("/api/admin/manage-slide")
public class ManageSlideController extends HttpServlet {

    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

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

        int id = Integer.parseInt(idParam.trim());
        Slide slide = SlideDao.getById(id);

        if (slide != null) {
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"status\": \"success\",");
            json.append("\"id\": ").append(slide.getId()).append(",");
            json.append("\"title\": \"").append(escapeJson(slide.getTitle())).append("\",");
            json.append("\"banner\": \"").append(escapeJson(slide.getBanner())).append("\",");
            json.append("\"description\": \"").append(escapeJson(slide.getDescription())).append("\",");
            json.append("\"statusSlide\": ").append(slide.getStatus());
            json.append("}");
            out.print(json.toString());
        } else {
            out.print("{\"status\":\"error\", \"message\": \"Không tìm thấy slide yêu cầu\"}");
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