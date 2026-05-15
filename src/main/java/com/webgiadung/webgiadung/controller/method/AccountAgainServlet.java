package com.webgiadung.webgiadung.controller.method;

import com.webgiadung.webgiadung.model.Cart;
import com.webgiadung.webgiadung.model.OrderAdmin;
import com.webgiadung.webgiadung.model.Product;
import com.webgiadung.webgiadung.model.User;
import com.webgiadung.webgiadung.services.OrderService;
import com.webgiadung.webgiadung.services.ProductService;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AccountAgainServlet", value = "/account-again")
public class AccountAgainServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        OrderService orderService = new OrderService();
        ProductService productService = new ProductService();

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String orderIdStr = request.getParameter("orderId");
        if("cancelOrder".equals(action)) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");

            try {
                int orderId = Integer.parseInt(orderIdStr);
                String reason = request.getParameter("reason");

                if(reason == null || reason.trim().isEmpty()) {
                    reason = "Người dùng không cung cấp lý do.";
                }

                boolean ok = orderService.cancelOrder(orderId, user.getId(), reason);

                // tạo nội dung json trả về
                String jsonResponse;
                if (ok) {
                    jsonResponse = "{\"status\": \"success\", \"message\": \"Đã hủy đơn hàng thành công!\"}";
                } else {
                    jsonResponse = "{\"status\": \"error\", \"message\": \"Hủy đơn thất bại. Đơn hàng có thể đã được giao hoặc không tồn tại.\"}";
                }

                response.getWriter().write(jsonResponse);
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().write("{\"status\": \"error\", \"message\": \"Lỗi hệ thống khi hủy đơn.\"}");
            }
        } else if("repurchase".equals(action) && orderIdStr != null) {
            try {
                int orderId = Integer.parseInt(orderIdStr);
                List<Map<String, Object>> listItems = orderService.findItemsForRepurchase(orderId);

                Cart cart = (Cart) session.getAttribute("cart");
                if (cart == null) cart = new Cart();

                StringBuilder errorLog = new StringBuilder();
                int addedCount = 0;

                for(Map<String, Object> item : listItems) {
                    int productId = ((Number) item.get("product_id")).intValue();
                    int oldQuantity = ((Number) item.get("quantity")).intValue();
                    String productName = (String) item.get("name");

                    Product p = productService.getProductFullInfo(productId);

                    if (p == null || p.getStatus() == 0) {
                        errorLog.append("- ").append(productName).append(": Sản phẩm đã ngừng bán.\n");
                        continue;
                    }

                    int stockAvailable = productService.getAvailableStock(productId);
                    int currentInCart = cart.getQuantityByProductId(productId);

                    // tổng số lượng yêu cầu sau khi thêm món cũ vào giỏ hiện tại
                    int totalRequested = currentInCart + oldQuantity;
                    int purchaseLimit = 10;

                    // kt giới hạn mua
                    if (currentInCart >= purchaseLimit) {
                        errorLog.append("- ").append(productName).append(": Đã đạt giới hạn mua tối đa (10).\n");
                        continue;
                    }

                    if (totalRequested > purchaseLimit) {
                        oldQuantity = purchaseLimit - currentInCart; // Chỉ lấy thêm cho đủ 10
                        errorLog.append("- ").append(productName).append(": Chỉ thêm được ").append(oldQuantity).append(" để đạt giới hạn 10.\n");
                    }

                    // kt tồn kho
                    if (stockAvailable <= 0) {
                        errorLog.append("- ").append(productName).append(": Hiện đã hết hàng.\n");
                        continue;
                    }

                    if (currentInCart + oldQuantity > stockAvailable) {
                        oldQuantity = stockAvailable - currentInCart; // Chỉ lấy thêm số lượng còn lại trong kho
                        if (oldQuantity > 0) {
                            errorLog.append("- ").append(productName).append(": Kho chỉ còn đủ để thêm ").append(oldQuantity).append(" sản phẩm.\n");
                        } else {
                            errorLog.append("- ").append(productName).append(": Giỏ hàng đã chứa toàn bộ số lượng trong kho.\n");
                            continue;
                        }
                    }

                    // thêm vào giỏ hàng
                    if (oldQuantity > 0) {
                        cart.addItem(p, oldQuantity);
                        addedCount++;
                    }
                }

                session.setAttribute("cart", cart);

                // Gửi thông báo về trang Cart
                if (addedCount > 0) {
                    session.setAttribute("successMsg", "Đã thêm lại " + addedCount + " sản phẩm vào giỏ hàng.");
                }
                if (errorLog.length() > 0) {
                    session.setAttribute("errorMsg", "Một số thay đổi:\n" + errorLog.toString());
                }

                response.sendRedirect(request.getContextPath() + "/cart");
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/account?tab=delivered");
            }
        }
    }
}