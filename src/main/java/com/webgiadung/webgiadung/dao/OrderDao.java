package com.webgiadung.webgiadung.dao;

import com.webgiadung.webgiadung.model.OrderAdmin;
import com.webgiadung.webgiadung.model.Cart;
import com.webgiadung.webgiadung.model.CartItem;
import com.webgiadung.webgiadung.model.User;
import org.jdbi.v3.core.Handle;

import java.util.List;
import java.util.Map;
// Thảo luận lại OrderDao
public class OrderDao extends BaseDao {

    public int placeOrder(User user, Cart cart, int shipFee) {
        double total = cart.getTotalPrice() + shipFee;

        return get().inTransaction(handle -> {
            int orderId = insertOrder(handle,
                    user.getId(),
                    (user.getName() != null && !user.getName().trim().isEmpty()) ? user.getName() : user.getEmail(),
                    total
            );

            for (CartItem it : cart.getItems()) {
                insertOrderItem(handle,
                        orderId,
                        it.getProduct().getId(),
                        it.getProduct().getName(),
                        it.getDiscountPrice(),
                        it.getQuantity(),
                        it.getTotalPrice()
                );
            }
            return orderId;
        });
    }

    private int insertOrder(Handle h, int userId, String customerName, double totalPrice) {
        String sql = """
            INSERT INTO orders(user_id, customer_name, status_transport, status_payment, total_price)
            VALUES (:user_id, :customer_name, 0, 0, :total_price)
        """;

        // lấy id vừa insert
        return h.createUpdate(sql)
                .bind("user_id", userId)
                .bind("customer_name", customerName)
                .bind("total_price", totalPrice)
                .executeAndReturnGeneratedKeys("id")
                .mapTo(Integer.class)
                .one();
    }

    private void insertOrderItem(Handle h, int orderId, int productId, String productName,
                                 double price, int quantity, double totalPrice) {
        String sql = """
            INSERT INTO order_items(order_id, product_id, product_name, price, quantity, total_price)
            VALUES (:order_id, :product_id, :product_name, :price, :quantity, :total_price)
        """;

        h.createUpdate(sql)
                .bind("order_id", orderId)
                .bind("product_id", productId)
                .bind("product_name", productName)
                .bind("price", price)
                .bind("quantity", quantity)
                .bind("total_price", totalPrice)
                .execute();
    }

    public List<Map<String, Object>> findOrdersByUser(int userId) {
        String sql = """
            SELECT id, total_price, status_transport, status_payment, created_at
            FROM orders
            WHERE user_id = :user_id
            ORDER BY id DESC
        """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("user_id", userId)
                        .mapToMap()
                        .list()
        );
    }

    public List<Map<String, Object>> findItemsByOrder(int orderId) {
        String sql = """
            SELECT product_name, price, quantity, total_price
            FROM order_items
            WHERE order_id = :order_id
            ORDER BY id ASC
        """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("order_id", orderId)
                        .mapToMap()
                        .list()
        );
    }

    public boolean cancelOrder(int orderId, int userId) {
        String sql = """
        UPDATE orders
        SET status_transport = 3
        WHERE id = :id
          AND user_id = :user_id
          AND status_transport = 0
    """;

        int updated = get().withHandle(h ->
                h.createUpdate(sql)
                        .bind("id", orderId)
                        .bind("user_id", userId)
                        .execute()
        );
        return updated > 0;
    }

    public boolean isOrderOwnedByUser(int orderId, int userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE id=:id AND user_id=:user_id";
        Integer cnt = get().withHandle(h ->
                h.createQuery(sql)
                        .bind("id", orderId)
                        .bind("user_id", userId)
                        .mapTo(Integer.class)
                        .one()
        );
        return cnt != null && cnt > 0;
    }

    public List<Map<String, Object>> findItemsForRepurchase(int orderId) {
        String sql = """
        SELECT 
            oi.product_id   AS product_id,
            oi.product_name AS name,
            COALESCE(p.image, 'assets/img/no-image.png') AS image,
            oi.price        AS first_price,
            oi.price        AS total_price,
            oi.quantity     AS quantity
        FROM order_items oi
        LEFT JOIN products p ON p.id = oi.product_id
        WHERE oi.order_id = :order_id
        ORDER BY oi.id ASC
    """;

        return get().withHandle(h ->
                h.createQuery(sql)
                        .bind("order_id", orderId)
                        .mapToMap()
                        .list()
        );
    }
    public List<OrderAdmin> getAllOrders() {
        return get().withHandle(handle ->
                handle.createQuery(
                        "SELECT o.id, u.name AS customer_name, " +
                                "o.status_transport, o.status_payment, o.created_at, o.total_price " +
                                "FROM orders o " +
                                "JOIN users u ON o.user_id = u.id " +
                                "ORDER BY o.created_at DESC"
                ).mapToBean(OrderAdmin.class).list()
        );
    }

    public List<OrderAdmin> searchOrders(String keyword) {
        String searchPattern = "%" + (keyword == null ? "" : keyword.trim()) + "%";

        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT o.id, " +
                                        "u.name AS customer_name, " +
                                        "o.status_transport, " +
                                        "o.status_payment, " +
                                        "o.created_at, " +
                                        "o.total_price " +
                                        "FROM orders o " +
                                        "JOIN users u ON o.user_id = u.id " +
                                        "WHERE CAST(o.id AS CHAR) LIKE :kw " +
                                        "OR u.name LIKE :kw " +
                                        "ORDER BY o.created_at DESC"
                        )
                        .bind("kw", searchPattern)
                        .mapToBean(OrderAdmin.class)
                        .list()
        );
    }

    public void deleteOrders(List<Integer> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) return;

        get().useHandle(handle ->
                handle.createUpdate("DELETE FROM orders WHERE id IN (<ids>)")
                        .bindList("ids", orderIds)
                        .execute()
        );
    }

    public void updateStatusTransport(int orderId, int statusTransport) {
        get().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE orders SET status_transport = :status WHERE id = :id"
                        )
                        .bind("status", statusTransport)
                        .bind("id", orderId)
                        .execute()
        );
    }

    public void updateStatusPayment(int orderId, int statusPayment) {
        get().useHandle(handle ->
                handle.createUpdate(
                                "UPDATE orders SET status_payment = :status WHERE id = :id"
                        )
                        .bind("status", statusPayment)
                        .bind("id", orderId)
                        .execute()
        );
    }
}