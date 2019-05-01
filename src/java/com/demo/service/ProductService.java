package com.demo.service;

import com.demo.entity.Product;

import java.util.List;

public interface ProductService {
    Product getProduct(int id);

    List<Product> getAllProduct();

    List<Product> searchProduct(String name);
    boolean deleteProduct(int id);
    boolean addProduct(Product product);
    void updatePnum(Product product);
}
