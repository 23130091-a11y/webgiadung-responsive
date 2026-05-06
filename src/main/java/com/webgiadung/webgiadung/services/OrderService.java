package com.webgiadung.webgiadung.services;

import com.webgiadung.webgiadung.dao.OrderDao;

public class OrderService {
    OrderDao orderDao = new OrderDao();
    public boolean cancelOrder(int orderId, int id, String reason) {
        return orderDao.cancelOrder(orderId, id, reason);
    }
}
