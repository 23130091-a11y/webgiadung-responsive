package com.webgiadung.webgiadung.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class Cart implements Serializable {
    Map<Integer, CartItem> data;
    User user;

    public Cart() {
        data = new HashMap<>();
    }

    public void addItem(Product product, int quantity) {
        if(quantity <= 0) quantity = 1;

        double originalPrice = product.getFirstPrice();

        double discountPrice = product.getTotalPrice(); // giá sau giảm

        CartItem existing = data.get(product.getId());
        if (existing != null) {
            existing.upQuantity(quantity);
        } else {
            data.put(product.getId(), new CartItem(product, quantity, originalPrice, discountPrice));
        }
    }

    private CartItem get(int id) {
        return data.get(id);
    }

//    public boolean updateItem(int productId, int quantity) {
//        if(get(productId) == null) return false;
//        if(quantity <= 0) quantity = 1;
//        data.get(productId).setQuantity(quantity);
//        return true;
//    }

    public CartItem deleteItem(int productId) {
        if(get(productId) == null) return null;
        return data.remove(productId);
    }

//    public ArrayList<CartItem> deleteAll() {
//        ArrayList<CartItem> list = new ArrayList<>(data.values());
//        data.clear();
//        return list;
//    }

    public ArrayList<CartItem> getItems() {
        return new ArrayList<>(data.values());
    }

    public int getTotalQuantity() {
        return getItems()
                .stream()
                .mapToInt(CartItem::getQuantity)
                .sum();
    }

    public double getTotalPrice() {
        return getItems()
                .stream()
                .mapToDouble(CartItem::getTotalPrice)
                .sum();
    }

//    public void updateCustomerInfo(User user) {
//        this.user = user;
//    }

    public void increaseQuantity(int productId) {
        CartItem item = data.get(productId);
        if (item != null) {
            item.setQuantity(item.getQuantity() + 1);
        }
    }

    public void decreaseQuantity(int productId) {
        Iterator<CartItem> iterator = data.values().iterator();
        while (iterator.hasNext()) {
            CartItem item = iterator.next();
            if (item.getProduct().getId() == productId) {
                if (item.getQuantity() > 1) {
                    item.setQuantity(item.getQuantity() - 1);
                } else {
                    iterator.remove(); // quantity = 0 thì xóa
                }
                return;
            }
        }
    }

    public int getQuantityByProductId(int productId) {
        CartItem item = data.get(productId);

        if (item != null) {
            return item.getQuantity();
        }

        return 0;
    }
}