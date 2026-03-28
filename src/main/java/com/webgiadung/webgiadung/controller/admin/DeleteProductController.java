package com.webgiadung.webgiadung.controller.admin;

import com.webgiadung.webgiadung.services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

// Định nghĩa URL mapping. Frontend sẽ gọi vào đường dẫn này.
@WebServlet(urlPatterns = {"/admin/product-delete"})
public class DeleteProductController extends HttpServlet {

    private final ProductService productService = new ProductService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        PrintWriter out = resp.getWriter();

        try {

            String idParam = req.getParameter("id");

            if (idParam == null || idParam.isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"status\": \"error\", \"message\": \"Thiếu ID sản phẩm.\"}");
                return;
            }

            int id = Integer.parseInt(idParam);

            boolean isDeleted = productService.deleteProduct(id);

            if (isDeleted) {
                out.print("{\"status\": \"success\", \"message\": \"Xóa thành công.\"}");
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"status\": \"fail\", \"message\": \"Không thể xóa sản phẩm này. Có thể ID không tồn tại.\"}");
            }

        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\": \"error\", \"message\": \"ID không hợp lệ.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\": \"error\", \"message\": \"Lỗi Server: " + e.getMessage() + "\"}");
        } finally {
            out.flush();
        }
    }

}