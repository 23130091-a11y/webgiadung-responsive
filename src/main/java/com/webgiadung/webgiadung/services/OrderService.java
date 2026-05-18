package com.webgiadung.webgiadung.services;

import com.webgiadung.webgiadung.dao.OrderDao;
import com.webgiadung.webgiadung.model.OrderAdmin;

import java.util.List;
import java.util.Map;

public class OrderService {
    OrderDao orderDao = new OrderDao();
    public boolean cancelOrder(int orderId, int id, String reason) {
        return orderDao.cancelOrder(orderId, id, reason);
    }

    public List<Map<String, Object>> findItemsForRepurchase(int orderId) {
        return orderDao.findItemsForRepurchase(orderId);
    }
}
