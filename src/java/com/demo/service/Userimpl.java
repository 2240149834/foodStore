package com.demo.service;

import com.demo.dao.userdao;
import com.demo.entity.user;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class Userimpl implements userservice {

    @Autowired
    userdao userdao;
    @Override
    public user islogin(String username, String password) {
        user currentUser = userdao.login(username,password);
        if (currentUser!=null){
            return currentUser;
        }
        return currentUser;
    }

    @Override
    public boolean iszhuce(user user) {
        int num= userdao.zhuce(user);
        if (num>0){
            return true;
        }
        return false;
    }

    @Override
    public user getUserByName(String username) {
        user user= userdao.getUserByName(username);
        if (user!=null){
            return  user;
        }
        return null;
    }

    @Override
    public List<user> getalluser() {
        List<user> list= userdao.getalluser();
        if (list.size()>0){
            return list;
        }
        return list;
    }

    @Override
    public boolean updateInfo(user user) {
        int num=userdao.updateInfo(user);
        if (num>0){
            return true;
        }
        return false;
    }

    @Override
    public boolean deleteUser(int[] id) {
        int num=userdao.deleteUser(id);
        if (num>0){
            return  true;
        }
        return false;
    }

    @Override
    public user getUserByemail(String email) {
        user user=userdao.getUserByemail(email);
        if (user!=null){
            return user;
        }
        return null;
    }

    @Override
    public user getUserById(int id) {
        user user=userdao.getUserById(id);
        if (user!=null){
            return user;
        }
        return null;
    }
}
