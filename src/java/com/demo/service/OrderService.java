package com.demo.service;

import com.demo.entity.Order;
import com.demo.entity.Product;
import com.demo.entity.orderItem;

import java.util.List;

public interface OrderService {
    String addOrder(Order order);
    List<Order> findAllOrder();
    List<Order> findMyOrder(int user_id);
    List<orderItem> findOrderItem(int order_id);
    boolean delete(int id);
    boolean updateOrder(Order order);
    Order getOrderBuyId(int Order_id);
    Product getProductBuyId(int product_id);
    boolean updateStatus(Order order);
}
