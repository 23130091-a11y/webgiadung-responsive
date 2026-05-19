package com.webgiadung.webgiadung.controller.cart;

import com.webgiadung.webgiadung.dao.CartDao;
import com.webgiadung.webgiadung.model.Cart;
import com.webgiadung.webgiadung.model.CartItem;
import com.webgiadung.webgiadung.model.Product;
import com.webgiadung.webgiadung.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DecimalFormat;

@WebServlet(name = "DeleteCart", value = "/delete-cart")
public class DeleteCart extends HttpServlet {

    private boolean isAjax(HttpServletRequest req) {
        String x = req.getHeader("X-Requested-With");
        return "XMLHttpRequest".equalsIgnoreCase(x) || "1".equals(req.getParameter("ajax"));
    }

    private static String jsonEscape(String s) {
        if (s == null) return "";
        StringBuilder sb = new StringBuilder(s.length() + 16);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '\\': sb.append("\\\\"); break;
                case '"': sb.append("\\\""); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (c < 32) sb.append(String.format("\\u%04x", (int) c));
                    else sb.append(c);
            }
        }
        return sb.toString();
    }

    private static String htmlEscape(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String buildMiniCartHtml(HttpServletRequest request, Cart cart) {
        String ctx = request.getContextPath();
        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            return """
                <div class="cart-list--no-cart">
                    <img src="%s/assets/img/no-cart_img.png" class="header-cart__img" alt="">
                    <span class="header-cart__msg">Chưa có sản phẩm</span>
                </div>
            """.formatted(ctx);
        }

        DecimalFormat df = new DecimalFormat("###,###");
        StringBuilder sb = new StringBuilder();
        sb.append("<div class=\"cart-list__wrap\">")
                .append("<h3 class=\"cart-list__header\">Sản phẩm đã thêm</h3>")
                .append("<ul class=\"cart-list__list\">");

        for (CartItem item : cart.getItems()) {
            if (item == null || item.getProduct() == null) continue;
            Product p = item.getProduct();
            int pid = p.getId();
            String name = htmlEscape(p.getName());
            String img = htmlEscape(p.getImage());
            String cate = String.valueOf(p.getCategoriesId());
            String totalPrice;
            try { totalPrice = df.format(item.getTotalPrice()) + " đ"; }
            catch (Exception e) { totalPrice = item.getTotalPrice() + " đ"; }

            sb.append("<li class=\"cart-list__item\" id=\"mini-cart-item-").append(pid).append("\">")
                    .append("<a href=\"").append(ctx).append("/product?id=").append(pid).append("\" ")
                    .append("style=\"display:flex; gap:10px; align-items:center; text-decoration:none; color:inherit; width:100%;\">")
                    .append("<img src=\"").append(ctx).append("/assets/img/products/").append(img).append("\" ")
                    .append("alt=\"").append(name).append("\" class=\"cart-list__img\">")
                    .append("<section class=\"cart-list__body\">")
                    .append("<div class=\"cart-list__info\">")
                    .append("<h4 class=\"cart-list__heading\">").append(name).append("</h4>")
                    .append("<div class=\"cart-list__price-wrap\">")
                    .append("<span class=\"cart-list__price\">").append(totalPrice).append("</span>")
                    .append("<span class=\"cart-list__multiply\">x</span>")
                    .append("<span class=\"cart-list__qnt\">").append(item.getQuantity()).append("</span>")
                    .append("</div></div>")
                    .append("<div class=\"cart-list__desc\">")
                    .append("<span class=\"cart-list__product-cate\">Phân loại: ").append(htmlEscape(cate)).append("</span>")
                    .append("</div></section></a>")
                    .append("<a href=\"").append(ctx).append("/delete-cart?id=").append(pid).append("\" ")
                    .append("class=\"cart-list__remove\" ")
                    .append("onclick=\"event.preventDefault(); removeMiniCartItem(").append(pid).append(");\">Xóa</a>")
                    .append("</li>");
        }

        sb.append("</ul>")
                .append("<a href=\"").append(ctx).append("/cart\" class=\"cart-list__view btn btn--default-color\">Xem giỏ hàng</a>")
                .append("</div>");
        return sb.toString();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processDelete(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processDelete(request, response);
    }

    private void processDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String pId = request.getParameter("id");
        int productId;
        try {
            productId = Integer.parseInt(pId);
        } catch (Exception e) {
            if(isAjax(request)) {
                response.setStatus(400);
                response.getWriter().print("{\"status\":\"error\"}");
            }
            else {
                response.sendRedirect(request.getContextPath() + "/cart");
            }
            return;
        }

        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) cart = new Cart();

        cart.deleteItem(productId);
        session.setAttribute("cart", cart);

        User user = (User) session.getAttribute("user");
        if (user != null) {
            CartDao cartDao = new CartDao();
            cartDao.delete(user.getId(), productId);
        }

        if (isAjax(request)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String miniHtml = buildMiniCartHtml(request, cart);
            DecimalFormat df = new DecimalFormat("###,###");
            String formattedTotal = df.format(cart.getTotalPrice()) + " đ";
            PrintWriter out = response.getWriter();
            out.print("{"
                    + "\"status\":\"success\","
                    + "\"cartQty\":" + cart.getTotalQuantity() + ","
                    + "\"miniCartHtml\":\"" + jsonEscape(miniHtml) + "\","
                    + "\"cartTotal\":\"" + formattedTotal + "\""
                    + "}");
            out.flush();
            return;
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}