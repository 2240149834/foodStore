package com.demo.service;

import com.demo.entity.user;

import java.util.List;

public interface userservice {
    user islogin(String username, String password);
    boolean iszhuce(user user);
    user getUserByName(String username);
    List<user> getalluser();
    boolean updateInfo(user user);
    boolean deleteUser(int[] id);
    user getUserByemail(String email);
    user getUserById(int id);
}
