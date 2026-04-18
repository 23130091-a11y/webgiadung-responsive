package com.webgiadung.webgiadung.controller.cart;

import com.webgiadung.webgiadung.model.Cart;
import com.webgiadung.webgiadung.model.CartItem;

import com.webgiadung.webgiadung.services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "UpdateCart", value = "/update-cart")
public class UpdateCart extends HttpServlet {

    private boolean isAjax(HttpServletRequest req) {
        String x = req.getHeader("X-Requested-With");
        return "XMLHttpRequest".equalsIgnoreCase(x) || "1".equals(req.getParameter("ajax"));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId;
        String action = request.getParameter("action");

        ProductService productService = new ProductService();

        try {
            productId = Integer.parseInt(request.getParameter("productId"));
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid productId");
            return;
        }

        // kiểm tra đăng nhập của thằng user
        HttpSession session = request.getSession();
        if (session.getAttribute("user") == null) {
            if (isAjax(request)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().print("{\"status\":\"unauthorized\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        // lấy cart từ session
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) cart = new Cart();

        // upgrade kt kho và giới hạn mua khi tăng số lượng sp
        //todo

        // update, inc là tăng, dec là giảm
        if ("inc".equals(action)) {
            int stockAvailable = productService.getAvailableStock(productId);
            int currentQtyInCart = cart.getQuantityByProductId(productId);

            if(currentQtyInCart + 1 > stockAvailable) {
                if (isAjax(request)) {
                    sendError(response, "Rất tiếc, kho hàng chỉ còn " + stockAvailable + " sản phẩm!", cart);
                }
                return;
            }

            int limit = 10;
            if (currentQtyInCart + 1 > limit) {
                if (isAjax(request)) {
                    sendError(response, "Mỗi khách hàng chỉ được mua tối đa " + limit + " sản phẩm!", cart);
                }
                return;
            }
            cart.increaseQuantity(productId);

        }
        else if ("dec".equals(action)) cart.decreaseQuantity(productId);

        // cập nhật lại session
        session.setAttribute("cart", cart);

        int newQuantity = 0; // số lượng mới
        double newSubtotal = 0; // tổng tiền của riêng sp
        boolean removed = true; // nếu ko tìm thấy sp trong ds cart => đơn bị xóa

        for (CartItem item : cart.getItems()) {
            if (item.getProduct().getId() == productId) {
                newQuantity = item.getQuantity();
                newSubtotal = item.getTotalPrice();
                removed = false;
                break;
            }
        }

        double cartTotal = cart.getTotalPrice(); // tổng tiền tất cả sp
        int cartQty = cart.getTotalQuantity(); // tổng số lượng

        // trả về sau cập nhật dạng json
        java.text.DecimalFormat df = new java.text.DecimalFormat("###,###");
        if (isAjax(request)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"status\":\"success\",");
            json.append("\"newQuantity\":").append(newQuantity).append(",");
            json.append("\"newSubtotal\":\"").append(df.format(newSubtotal)).append(" đ\",");
            json.append("\"rawSubtotal\":").append(newSubtotal).append(",");
            json.append("\"cartTotal\":\"").append(df.format(cartTotal)).append(" đ\",");
            json.append("\"cartQty\":").append(cartQty).append(",");
            json.append("\"removed\":").append(removed);
            json.append("}");

            PrintWriter out = response.getWriter();
            out.print(json.toString());
            out.flush();
        } else {
            response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void sendError(HttpServletResponse response, String message, Cart cart) throws IOException {
        response.setStatus(400);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        int currentTotalQty = (cart != null) ? cart.getTotalQuantity() : 0;

        response.getWriter().print("{\"status\":\"error\", \"message\":\"" + message + "\", \"cartQty\":" + currentTotalQty + "}");
    }
}
