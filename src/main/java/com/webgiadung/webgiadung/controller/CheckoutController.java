package com.webgiadung.webgiadung.controller;

import com.webgiadung.webgiadung.dao.OrderDao;
import com.webgiadung.webgiadung.model.Cart;
import com.webgiadung.webgiadung.model.CartItem;
import com.webgiadung.webgiadung.model.User;

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
import com.webgiadung.webgiadung.model.UserAddress;


import java.util.List;
import java.util.Optional;

@WebServlet("/checkout")
public class CheckoutController extends HttpServlet {

    private static final int SHIP_STANDARD = 25000;
    private static final int SHIP_EXPRESS  = 150000;
    private final OrderDao orderDao = new OrderDao();

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
        HttpSession session = req.getSession();

        Cart fullCart = (Cart) session.getAttribute("cart");
        if (fullCart == null) fullCart = new Cart();

        if (fullCart.getItems() == null || fullCart.getItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String idsParam = req.getParameter("ids");
        Cart orderCart = buildSelectedCart(fullCart, idsParam);

        req.setAttribute("items", orderCart.getItems());
        req.setAttribute("totalQuantity", orderCart.getTotalQuantity());
        req.setAttribute("totalPrice", orderCart.getTotalPrice());

        // mặc định hiển thị tiêu chuẩn
        req.setAttribute("ship", SHIP_STANDARD);
        req.setAttribute("shippingMethod", "standard");

        if (idsParam != null && !idsParam.isBlank()) {
            req.setAttribute("ids", idsParam);
        }

        // ================== ADDRESS (CHỈ GIỮ 1 BLOCK) ==================
        User user = (User) session.getAttribute("user");
        if (user != null) {
            UserAddressDao addrDao = new UserAddressDao();

            List<UserAddress> addresses = addrDao.findByUser(user.getId());
            req.setAttribute("addresses", addresses);

            Integer selectedId = (Integer) session.getAttribute("SELECTED_ADDR_ID");

            UserAddress selected = null;
            if (selectedId != null) {
                selected = addrDao.findById(user.getId(), selectedId).orElse(null);
            }

            if (selected == null) {
                // ưu tiên địa chỉ default
                selected = addrDao.findDefault(user.getId()).orElse(null);

                // có default thì lưu lại
                if (selected != null) session.setAttribute("SELECTED_ADDR_ID", selected.getId());
            }

            // nếu chưa có address trong bảng user_addresses
            if (selected == null && user.getAddress() != null && !user.getAddress().trim().isEmpty()) {
                UserAddress tmp = new UserAddress();
                tmp.setId(0);
                tmp.setUserId(user.getId());
                tmp.setFullName(user.getName());
                tmp.setPhone(user.getPhone());
                tmp.setAddress(user.getAddress());
                tmp.setIsDefault(1);
                selected = tmp;
            }

            req.setAttribute("selectedAddress", selected);
        }

        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession();

        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Integer selectedId = (Integer) session.getAttribute("SELECTED_ADDR_ID");
        boolean okAddress = (user.getAddress() != null && !user.getAddress().trim().isEmpty()) || (selectedId != null);
        if (!okAddress) {
            resp.sendRedirect(req.getContextPath() + "/checkout?needAddress=1");
            return;
        }


        Cart fullCart = (Cart) session.getAttribute("cart");
        if (fullCart == null) fullCart = new Cart();

        if (fullCart.getItems() == null || fullCart.getItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String idsParam = req.getParameter("ids");
        Cart orderCart = buildSelectedCart(fullCart, idsParam);

        if (orderCart.getItems() == null || orderCart.getItems().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/checkout?error=1");
            return;
        }

        //  LẤY SHIP THEO RADIO
        String shipMethod = req.getParameter("shipping-method"); // standard | express
        int shipFee = "express".equalsIgnoreCase(shipMethod) ? SHIP_EXPRESS : SHIP_STANDARD;

        try {
            orderDao.placeOrder(user, orderCart, shipFee);

            if (idsParam != null && !idsParam.isBlank()) {
                for (String p : idsParam.split(",")) {
                    try {
                        int pid = Integer.parseInt(p.trim());
                        fullCart.deleteItem(pid);
                    } catch (Exception ignored) {}
                }
                session.setAttribute("cart", fullCart);
            } else {
                session.setAttribute("cart", new Cart());
            }

            resp.sendRedirect(req.getContextPath() + "/account?tab=orders#orders-all");
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/checkout?error=1");
        }
    }
}