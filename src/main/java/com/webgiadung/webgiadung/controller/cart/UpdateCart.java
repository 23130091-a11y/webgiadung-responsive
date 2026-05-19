package com.webgiadung.webgiadung.controller.cart;

import com.webgiadung.webgiadung.dao.CartDao;
import com.webgiadung.webgiadung.model.Cart;
import com.webgiadung.webgiadung.model.CartItem;
import com.webgiadung.webgiadung.model.User;
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

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            if (isAjax(request)) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().print("{\"status\":\"unauthorized\"}");
            } else {
                response.sendRedirect(request.getContextPath() + "/login");
            }
            return;
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) cart = new Cart();

        if ("inc".equals(action)) {
            int stockAvailable = productService.getAvailableStock(productId);
            int currentQtyInCart = cart.getQuantityByProductId(productId);

            if(currentQtyInCart + 1 > stockAvailable) {
                if (isAjax(request)) sendError(response, "Rất tiếc, kho hàng chỉ còn " + stockAvailable + " sản phẩm!", cart);
                return;
            }

            int limit = 10;
            if (currentQtyInCart + 1 > limit) {
                if (isAjax(request)) sendError(response, "Mỗi khách hàng chỉ được mua tối đa " + limit + " sản phẩm!", cart);
                return;
            }
            cart.increaseQuantity(productId);

        } else if ("dec".equals(action)) {
            cart.decreaseQuantity(productId);
        }

        session.setAttribute("cart", cart);


        CartDao cartDao = new CartDao();
        int newQtyInCart = cart.getQuantityByProductId(productId);
        cartDao.setQuantity(user.getId(), productId, newQtyInCart);

        int newQuantity = 0;
        double newSubtotal = 0;
        boolean removed = true;

        for (CartItem item : cart.getItems()) {
            if (item.getProduct().getId() == productId) {
                newQuantity = item.getQuantity();
                newSubtotal = item.getTotalPrice();
                removed = false;
                break;
            }
        }

        double cartTotal = cart.getTotalPrice();
        int cartQty = cart.getTotalQuantity();

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