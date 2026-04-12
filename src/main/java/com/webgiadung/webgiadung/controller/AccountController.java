package com.webgiadung.webgiadung.controller;

import com.webgiadung.webgiadung.dao.OrderDao;
import com.webgiadung.webgiadung.dao.AuthDao;
import com.webgiadung.webgiadung.model.User;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.*;

import com.webgiadung.webgiadung.model.Cart;
import com.webgiadung.webgiadung.model.Product;

@WebServlet("/account")
public class AccountController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final AuthDao authDao = new AuthDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            // tab hiện tại (để JSP dùng highlight)
            String tab = req.getParameter("tab");
            if (tab == null || tab.isBlank()) tab = "all";
            req.setAttribute("tab", tab);

            // Lấy tất cả đơn của user
            List<Map<String, Object>> ordersAll = orderDao.findOrdersByUser(user.getId());

            // Chia theo trạng thái (0 đơn mới, 1 xác nhận, 2 vận chuyển, 3 đã giao, 4 đã hủy, 5 trả hàng/hoàn tiền)
            List<Map<String, Object>> ordersNew = new ArrayList<>();
            List<Map<String, Object>> ordersShipping = new ArrayList<>();
            List<Map<String, Object>> ordersDelivered  = new ArrayList<>();
            List<Map<String, Object>> ordersCancelled  = new ArrayList<>();

            for (Map<String, Object> oItem : ordersAll) {
                int st = toInt(oItem.get("status_transport"));

                switch (st) {
                    case 1:
                    case 2:
                        ordersShipping.add(oItem);
                        break;
                    case 3:
                        ordersDelivered.add(oItem);
                        break;
                    case 4:
                    case 5:
                        ordersCancelled.add(oItem);
                        break;
                    default:
                        ordersNew.add(oItem);
                        break;
                }
            }

            // Map items theo orderId
            Map<Integer, List<Map<String, Object>>> orderItemsMap = new HashMap<>();
            for (Map<String, Object> o : ordersAll) {
                int orderId = toInt(o.get("id"));
                orderItemsMap.put(orderId, orderDao.findItemsByOrder(orderId));
            }

            // Đẩy dữ liệu sang JSP
            req.setAttribute("ordersAll", ordersAll);
            req.setAttribute("ordersNew", ordersNew);
            req.setAttribute("ordersShipping", ordersShipping);
            req.setAttribute("ordersDelivered", ordersDelivered);
            req.setAttribute("ordersCancelled", ordersCancelled);
            req.setAttribute("orderItemsMap", orderItemsMap);

            req.getRequestDispatcher("/account.jsp").forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if("updateProfile".equals(action)) {
            String currentTab = req.getParameter("tab");
            boolean success = false;
            if("info".equals(currentTab)) {
                String name = req.getParameter("name");
                String phone = req.getParameter("phone");

                if (name == null || name.trim().isEmpty()) {
                    req.setAttribute("profileError", "Họ và tên không được để trống");
                } else if (phone != null && !phone.matches("^[0-9]{10}$")) {
                    req.setAttribute("profileError", "Số điện thoại phải có 10 chữ số");
                } else {
                    success = authDao.updateInfo(user.getId(), name, phone);
                    if (success) {
                        user.setName(name);
                        user.setPhone(phone);
                        req.setAttribute("profileMsg", "Cập nhật thông tin cá nhân thành công!");
                    }
                }
            } else if("address".equals(currentTab)) {
                String province = req.getParameter("provinceName");
                String district = req.getParameter("district");
                String detail = req.getParameter("detailAddress");

                if (province == null || province.isEmpty() || district == null || district.isEmpty()) {
                    req.setAttribute("profileError", "Bạn cần chọn lại Tỉnh/Thành và Quận/Huyện để cập nhật địa chỉ!");
                    success = false;
                } else {
                    String fullAddress = detail + ", " + district + ", " + province;
                    success = authDao.updateAddress(user.getId(), fullAddress);
                    if (success) {
                        user.setAddress(fullAddress);
                        req.setAttribute("profileMsg", "Cập nhật địa chỉ thành công!");
                    }
                }
            }

            if (!success && req.getAttribute("profileError") == null) {
                req.setAttribute("profileError", "Có lỗi xảy ra trong quá trình lưu dữ liệu.");
            }

            // Giữ đúng tab người dùng đang đứng
            req.setAttribute("tab", currentTab);
            req.getRequestDispatcher("/account.jsp").forward(req, resp);
        }
    }

    //
    private String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private int toInt(Object v) {
        if (v == null) return 0;
        if (v instanceof Number) return ((Number) v).intValue();
        try { return Integer.parseInt(v.toString()); } catch (Exception e) { return 0; }
    }

    private double toDouble(Object v) {
        if (v == null) return 0.0;
        if (v instanceof Number) return ((Number) v).doubleValue();
        try { return Double.parseDouble(v.toString()); } catch (Exception e) { return 0.0; }
    }
}
