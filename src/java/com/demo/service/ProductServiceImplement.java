package com.demo.service;

import com.demo.dao.ProductDao;
import com.demo.entity.Product;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class ProductServiceImplement implements ProductService {
    @Autowired
    private ProductDao productDao;

    @Override
    public Product getProduct(int id) {
        Product product=productDao.getProduct(id);
        if (product!=null){
            return product;
        }
        return null;
    }

    @Override
    public List<Product> getAllProduct() {
        List<Product> list=productDao.getAllProduct();
        if(list.size()>0){
            return list;
        }
        return list;
    }

    @Override
    public List<Product> searchProduct(String name) {
        List<Product> list=productDao.searchProduct(name);
        if(list.size()>0){
            return list;
        }
        return list;
    }

    @Override
    public boolean deleteProduct(int id) {
        int num=productDao.deleteProduct(id);
        if (num>0){
            return true;
        }
        return false;
    }

    @Override
    public boolean addProduct(Product product) {
        int num=productDao.addProduct(product);
        if (num>0){
            return true;
        }
        return false;
    }

    @Override
    public void updatePnum(Product product) {
        productDao.updatePnum(product);
    }
}
