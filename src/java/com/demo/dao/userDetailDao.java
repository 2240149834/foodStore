package com.demo.dao;

import com.demo.entity.userDetail;

public interface userDetailDao {
//     userDetail getAddressAndphoneNumberAndlianxiren(int id);
     int addUserDetail(userDetail userDetail);
     userDetail getUserDetailById(int id);
     int updateInfo(userDetail userDetail);
     int deleteUser(int[] id);
}
