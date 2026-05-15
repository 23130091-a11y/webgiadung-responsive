package com.webgiadung.webgiadung.controller;

import com.webgiadung.webgiadung.dao.OrderDao;
import com.webgiadung.webgiadung.model.*;

import com.webgiadung.webgiadung.services.ProductService;
import com.webgiadung.webgiadung.utils.ShippingUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashSet;
import java.util.Set;

import com.webgiadung.webgiadung.dao.UserAddressDao;

import java.util.List;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private static final int SHIP_STANDARD = 25000;
    private static final int SHIP_EXPRESS  = 150000;
    private final OrderDao orderDao = new OrderDao();

    // lấy sản phẩm mua
    private Cart buildSelectedCart(Cart fullCart, String idsParam) {
        if (idsParam == null || idsParam.isBlank()) return fullCart;

        Set<Integer> idSet = new HashSet<>();
        for (String p : idsParam.split(",")) {
            try {
                idSet.add(Integer.parseInt(p.trim()));
            } catch (Exception ignored) {}
        }

        Cart selected = new Cart();
        for (CartItem ci : fullCart.getItems()) {
            if (ci != null && ci.getProduct() != null && idSet.contains(ci.getProduct().getId())) {
                selected.addItem(ci.getProduct(), ci.getQuantity());
            }
        }
        return selected;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ProductService productService = new ProductService();
        HttpSession session = req.getSession();

        User u = (User) req.getSession().getAttribute("user");

        if (u == null) {
            String currentUrl = req.getServletPath(); // "/checkout"
            String query = req.getQueryString(); // "ids=2&qty=1"

            if (query != null) {
                currentUrl += "?" + query;
            }

            resp.sendRedirect(req.getContextPath() + "/login?redirect=" + java.net.URLEncoder.encode(currentUrl, "UTF-8"));
            return;
        }

        Cart fullCart = (Cart) session.getAttribute("cart");
        if (fullCart == null) fullCart = new Cart();

        String idsParam = req.getParameter("ids");
        String buyNowQty = req.getParameter("qty");

        boolean isBuyNow = (idsParam != null && buyNowQty != null);
        boolean isCartEmpty = (fullCart.getItems() == null || fullCart.getItems().isEmpty());

        if (isCartEmpty && !isBuyNow) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        Cart orderCart = new Cart();

        if(buyNowQty != null && idsParam != null && !idsParam.contains(",")) {
            int pid = Integer.parseInt(idsParam);
            Product p = productService.getProductFullInfo(pid);
            orderCart.addItem(p, Integer.parseInt(buyNowQty));
        } else {
            orderCart = buildSelectedCart(fullCart, idsParam);
        }

        if (orderCart.getItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        //todo
        StringBuilder stockWarning = new StringBuilder();
        boolean isStockOk = true;

        for (CartItem item : orderCart.getItems()) {
            int available = productService.getAvailableStock(item.getProduct().getId());
            if (item.getQuantity() > available) {
                isStockOk = false;
                stockWarning.append("Sản phẩm '").append(item.getProduct().getName())
                        .append("' chỉ còn ").append(available).append(" cái. ");
            }
        }

        if (!isStockOk) {
            req.setAttribute("stockError", stockWarning.toString());
            // Bạn vẫn cho vào trang checkout nhưng sẽ khóa nút "Đặt hàng" ở JSP
        }

        UserAddressDao addrDao = new UserAddressDao();
        List<UserAddress> addresses = addrDao.findByUser(u.getId());
        req.setAttribute("addresses", addresses);

        // lấy địa chỉ đang chọn hoặc mặc định
        UserAddress selectedAddr = addrDao.findDefault(u.getId()).orElse(null);
        if (selectedAddr == null && !addresses.isEmpty()) {
            selectedAddr = addresses.get(0);
        }
        req.setAttribute("selectedAddress", selectedAddr);

        long shipFee = ShippingUtils.calculateShippingFee(selectedAddr, "standard");

        // đẩy dữ liệu ra view
        req.setAttribute("items", orderCart.getItems());
        req.setAttribute("totalQuantity", orderCart.getTotalQuantity());
        req.setAttribute("totalPrice", orderCart.getTotalPrice());
        req.setAttribute("shipFee", shipFee);
        req.setAttribute("shippingMethod", "standard");
        req.setAttribute("ids", idsParam); // Cần thiết để gửi sang ProcessCheckout

        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

    }
}