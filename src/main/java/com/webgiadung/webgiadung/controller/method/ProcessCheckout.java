package com.webgiadung.webgiadung.controller.method;

import com.webgiadung.webgiadung.dao.OrderDao;
import com.webgiadung.webgiadung.dao.UserAddressDao;
import com.webgiadung.webgiadung.model.Cart;
import com.webgiadung.webgiadung.model.CartItem;
import com.webgiadung.webgiadung.model.User;
import com.webgiadung.webgiadung.model.UserAddress;
import com.webgiadung.webgiadung.utils.ShippingUtils;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "ProcessCheckout", value = "/process-checkout")
public class ProcessCheckout extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String productIds = request.getParameter("ids");
            String addressId = request.getParameter("addressId");
            String method = request.getParameter("shippingMethod");
            String payMethod = request.getParameter("payment");

            // lấy thông tin ông user
            User u = (User) request.getSession().getAttribute("user");
            if (u == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            try {
                int id = Integer.parseInt(addressId);
                // lấy ông cart ra từ session lọc theo id product đc chọn lấy tổng tiền
                HttpSession session = request.getSession();

                Cart fullCart = (Cart) session.getAttribute("cart");
                if (fullCart == null) fullCart = new Cart();

                if (fullCart.getItems() == null || fullCart.getItems().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/cart");
                    return;
                }

                Cart orderCart = buildSelectedCart(fullCart, productIds);
                // kiểm tra tồn kho một lần nunawx trước khi gọi insert order đó vào bảng
                // todo

                // lấy tổng tiền từ cart
                double subTotal = orderCart.getTotalPrice();
                // lấy ôg địa chỉ đc chọn ra
                UserAddressDao addrDao = new UserAddressDao();
                UserAddress selectedAddr = addrDao.findById(u.getId(), id).orElse(null);
                long fee = ShippingUtils.calculateShippingFee(selectedAddr, method);

                double finalTotal = subTotal + fee;

                OrderDao orderDao = new OrderDao();
                int orderId = orderDao.placeOrder(u, selectedAddr, method, fee, payMethod, finalTotal, orderCart);

                if("e-wallet".equals(payMethod)) {
                    orderDao.updateStatusPayment(orderId, 1);

                    response.sendRedirect(request.getContextPath() + "/ajax-vnpay?orderId=" + orderId);
                    return;
                } else if ("viet-qr".equals(payMethod)) {
                    // ToDo
                } else {
                    // Mặc định là COD
                    // Xóa các sản phẩm đã mua khỏi giỏ hàng chính trong session
                    for (String idStr : productIds.split(",")) {
                        fullCart.deleteItem(Integer.parseInt(idStr.trim()));
                    }
                    response.sendRedirect(request.getContextPath() + "/account?tab=processing");
                }
            }
            catch (Exception e){
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/checkout-error");
            }
        }

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
}