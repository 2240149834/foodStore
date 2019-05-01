package com.demo.service;

import com.demo.dao.userDetailDao;
import com.demo.entity.userDetail;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class userdetailimpl  implements userdetail{
    @Autowired
    private userDetailDao userDetailDao;

//    @Override
//    public String getAddress(int id) {
//        userDetail userDetail=userDetailDao.getAddressAndphoneNumberAndlianxiren(id);
//        String address=userDetail.getAddress();
//        if (address!=null&&address!=""){
//            return address;
//        }
//        return null;
//    }

//    @Override
//    public String phoneNumber(int id) {
//        userDetail userDetail=userDetailDao.getAddressAndphoneNumberAndlianxiren(id);
//        String phoneNumber=userDetail.getPhoneNumber();
//        if(phoneNumber!=null){
//            return  phoneNumber;
//        }
//        return null;
//    }

//    @Override
//    public String lianxiren(int id) {
//        userDetail userDetail=userDetailDao.getAddressAndphoneNumberAndlianxiren(id);
//        String lianxiren=userDetail.getLianxiren();
//        if (lianxiren!=null){
//            return lianxiren;
//        }
//        return null;
//    }

    @Override
    public boolean addUserDetail(userDetail userDetail) {
         int num=userDetailDao.addUserDetail(userDetail);
         if (num>0){
             return true;
         }
         return false;
    }

    @Override
    public userDetail getUserDetailById(int id) {
        userDetail userDetail=userDetailDao.getUserDetailById(id);
        if (userDetail!=null) {
            return userDetail;
        }
        return  null;
    }

    @Override
    public boolean updateInfo(userDetail userDetail) {
        int num=userDetailDao.updateInfo(userDetail);
        if (num>0){
            return  true;
        }
        return false;
    }

    @Override
    public boolean deleteUser(int[] id) {
        int num=userDetailDao.deleteUser(id);
        if(num>0){
            return true;
        }
        return false;
    }

}
