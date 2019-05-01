package com.demo.service;

import com.demo.entity.userDetail;

public interface userdetail {
//    String getAddress(int id);
//    String phoneNumber(int id);
//    String lianxiren(int id);
    boolean addUserDetail(userDetail userDetail);
    userDetail getUserDetailById(int id);
    boolean updateInfo(userDetail userDetail);
    boolean deleteUser(int[] id);
}
