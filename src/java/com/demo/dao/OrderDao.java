package com.demo.dao;

import com.demo.entity.Order;
import com.demo.entity.Product;

import java.util.List;

public interface OrderDao {
    // 添加订单到数据库表order中
        void add(Order order);

    // 查看所有用户的订单
    List<Order> findAllOrder();

    // 根据user_id查看用户的订单
     List<Order> findOrderByUser_id(int user_id);
    // 根据user_id删除用户的订单
    int deleteById(int id);
    //更新订单
    int updateOrder(Order order);

    //分步查询订单和订单项
    Order getOrderBuyId(int order_id);

    Product getProductBuyId(int product_id);
    int updateStatus(Order order);
}
