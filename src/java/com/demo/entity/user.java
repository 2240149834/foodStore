package com.demo.entity;

public class user {
    private  int id;
    private  String username;
    private  String password;

    private  userDetail userDetail;

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public com.demo.entity.userDetail getUserDetail() {
        return userDetail;
    }

    public void setUserDetail(com.demo.entity.userDetail userDetail) {
        this.userDetail = userDetail;
    }
}
