package com.demo.dao;

import com.demo.entity.Product;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Created by 14437 on 2017/3/1.
 */
public interface ProductDao {
    Product getProduct(int id);
   List<Product> getAllProduct();
   List<Product> searchProduct(@Param("name") String name);
   int deleteProduct(int id);
   int addProduct(Product product);
   int updatePnum(Product product);
}
