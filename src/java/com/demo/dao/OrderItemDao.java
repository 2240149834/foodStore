package com.demo.dao;

import com.demo.entity.orderItem;

import java.util.List;

public interface OrderItemDao {
    // 添加订单项到数据库表orderitem中
    void addItem(orderItem orderItem);

    // 查询某一个订单的所有订单项
    List<orderItem> findOrderItem(int order_id);

    int deleteOrderItem(int[] id);

    List<orderItem> selectOrderItem(int id);
}