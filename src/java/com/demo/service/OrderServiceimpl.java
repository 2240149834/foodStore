package com.demo.service;

import com.demo.dao.OrderDao;
import com.demo.dao.OrderItemDao;
import com.demo.dao.ProductDao;
import com.demo.entity.Order;
import com.demo.entity.Product;
import com.demo.entity.orderItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderServiceimpl implements OrderService {
    @Autowired
    private OrderDao orderDao ;
    @Autowired
    private OrderItemDao orderItemDao;
    @Autowired
    private ProductDao productDao;

    // 添加订单和订单项
    public String addOrder(Order order) {
            // 添加订单
            orderDao.add(order);
            // 获取订单项的集合
            List<orderItem> list = order.getOrderItems();
            int count=0;
            // 遍历订单项目，依次将它们插入orderitem表中
            for (orderItem orderItem : list) {
                // 添加订单项
                orderItem.setOrder_id(order.getId());
                orderItemDao.addItem(orderItem);
                count++;
            }
           if (list.size()==count) {
               return "success";
           }
           return "fail";
    }

    // 查看所有的订单
    public List<Order> findAllOrder() {
            return orderDao.findAllOrder();
    }

    // 根据用户查询订
    public List<Order> findMyOrder(int user_id) {
            return orderDao.findOrderByUser_id(user_id);
    }

    // 查看某个订单
    public List<orderItem> findOrderItem(int order_id) {
            return orderItemDao.findOrderItem(order_id);
    }

    // 删除某个订单
    public boolean delete(int id) {
         Order order=orderDao.getOrderBuyId(id);
        List<orderItem> list =order.getOrderItems();
        int[] ids=new int[list.size()];
        for (int i = 0; i <list.size(); i++) {
            ids[i]=list.get(i).getOrder_id();
        }
        orderItemDao.deleteOrderItem(ids);
        int num=orderDao.deleteById(id);
        if (num>0){
           return true;
        }
        return false;
    }

    @Override
    public boolean updateOrder(Order order) {
        List<orderItem> list=order.getOrderItems();
        for (int i = 0; i <list.size(); i++) {
            orderItem orderItem = list.get(i);
            productDao.updatePnum(orderItem.getProduct());
        }
        int num=orderDao.updateOrder(order);
        if (num>0){
            return true;
        }
        return false;
    }

    @Override
    public Order getOrderBuyId(int order_id) {
        Order order=orderDao.getOrderBuyId(order_id);
        return order;
    }

    @Override
    public Product getProductBuyId(int product_id) {
        Product product=productDao.getProduct(product_id);
        return product;
    }

    @Override
    public boolean updateStatus(Order order) {
        int num=orderDao.updateStatus(order);
        if (num>0){
            return  true;
        }
        return false;
    }

    @Override
    public Order getOrderByorderCode(String orderCode) {
        Order order=orderDao.getOrderByorderCode(orderCode);
        if (order!=null){
            return order;
        }
        return null;
    }
}
