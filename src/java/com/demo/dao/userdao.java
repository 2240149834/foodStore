package com.demo.dao;

import com.demo.entity.user;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface userdao {
     user login(@Param("username") String username, @Param("password") String password);
     int zhuce(user user);
     user getUserByName(@Param("username") String username);
     List<user> getalluser();
     int updateInfo(user user);
     int deleteUser(int[] id);
     user getUserByemail(String email);
     user getUserById(int id);
}
