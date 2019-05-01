<%@ page contentType="text/html;charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zh-CN">
  <head>
      <meta charset="utf-8">
      <meta http-equiv="X-UA-Compatible" content="IE=edge">
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <title>注册页面</title>
      <link href="css/bootstrap.min.css" rel="stylesheet">
      <link href="css/style.css" rel="stylesheet">

      <script src="js/jquery.min.js" type="text/javascript"></script>
      <script src="js/bootstrap.min.js" type="text/javascript"></script>
      <script src="js/layer.js" type="text/javascript"></script>
      <script type="text/javascript">
          function startRegister() {
              var user = {};
              user.username = document.getElementById("inputUserName").value;
              user.email = document.getElementById("inputEmail").value;
              user.nickName = document.getElementById("inputNickname").value;
              user.password = document.getElementById("inputPassword").value;
              user.reinputPassword = document.getElementById("reinputPassword").value;
              // console.log(user);
              if(user.username == ''){
                  layer.msg('用户名不能为空',{icon:2});
                  return;
              }
              else if(user.username.length >= 12){
                  layer.msg('用户名长度不能超过12个字符',{icon:2});
                  return;
              }
              if(user.nickName == ''){
                  layer.msg('昵称不能为空',{icon:2});
                  return;
              }
              else if(user.nickName.length >= 15){
                  layer.msg('昵称长度不能超过15个字符',{icon:2});
                  return;
              }
              if(user.password == ''){
                  layer.msg('密码不能为空',{icon:2});
                  return;
              }
              else if(user.password.length<6){
                  layer.msg('密码长度不能小于6位',{icon:2});
                  return;
              }
              if(user.password !=user.reinputPassword){
                  layer.msg('两次密码不一致',{icon:2});
                  return;
              }
              var registerResult = null;
              $.ajax({
                  async : false, //设置同步
                  type : 'POST',
                  url : 'zhuce',
                  data : user,
                  dataType : 'json',
                  success : function(result) {
                      registerResult = result.result;
                  },
                  error : function() {
                      layer.alert('出现异常');
                  }
              });
              if(registerResult == 'success'){
                  layer.alert('注册成功',{icon:1});
                  location.href="index.jsp";
              }
              else if(registerResult == 'nameExist'){
                  layer.msg('用户名已存在',{icon:2});
              }
              else if(registerResult == 'fail'){
                  layer.msg('注册失败',{icon:2});
              }
          }
      </script>
      <style type="text/css">
          body{
              background-image: url("imgs/login.jpg");
              background-position: center 0;
              background-repeat: no-repeat;
              background-attachment: fixed;
              background-size: cover;
              -webkit-background-size: cover;
              -o-background-size: cover;
              -moz-background-size: cover;
              -ms-background-size: cover;
          }
      </style>
  </head>
  <body>
    <!--导航栏部分-->
    <jsp:include page="header.jsp"/>

    <!-- 中间内容 -->
    <div class="container-fluid">
        <h1 class="title center">用户注册</h1>
        <br/>
        <div class="col-sm-offset-4 col-md-offest-3">
            <!-- 表单输入 -->
            <div  class="form-horizontal">
                <div class="form-group">
                    <label for="inputEmail" class="col-sm-2 col-md-2 control-label">用户名</label>
                    <div class="col-sm-6 col-md-3">
                        <input type="text" class="form-control" id="inputUserName" placeholder="请输入数字"/>
                    </div>
                </div>
                <div class="form-group">
                    <label for="inputEmail" class="col-sm-2 col-md-2 control-label">邮箱</label>
                    <div class="col-sm-6 col-md-3">
                        <input type="email" class="form-control" id="inputEmail" placeholder="请输入正确的邮箱格式"/>
                    </div>
                </div>
                <div class="form-group">
                    <label for="inputNickname" class="col-sm-2 col-md-2 control-label">昵称</label>
                    <div class="col-sm-6 col-md-3">
                        <input type="text" class="form-control" id="inputNickname" placeholder="XXXXXXXX" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="inputPassword" class="col-sm-2 col-md-2 control-label">密码</label>
                    <div class="col-sm-6 col-md-3">
                        <input type="password" class="form-control" id="inputPassword" placeholder="请输入密码" />
                    </div>
                </div>
                <div class="form-group">
                    <label for="inputPassword" class="col-sm-2 col-md-2 control-label">确认密码</label>
                    <div class="col-sm-6 col-md-3">
                        <input type="password" class="form-control" id="reinputPassword" placeholder="请输入密码" />
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-sm-offset-2 col-sm-3">
                        <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="startRegister()">注册</button>
                    </div>
                </div>
            </div>
            <br/>
        </div>
    </div>
  </body>
</html>