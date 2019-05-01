<%@ page contentType="text/html;charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>信息修改</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">

    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/bootstrap.min.js" type="text/javascript"></script>
    <script src="js/layer.js" type="text/javascript"></script>
</head>
<body>
<!--导航栏部分-->
<jsp:include page="header.jsp"/>

<!-- 中间内容 -->
<div class="container-fluid">
    <h1 class="title center">修改个人信息</h1>
    <br/>
    <div class="col-sm-offset-2 col-md-offest-2">
        <!-- 表单输入 -->
        <div  class="form-horizontal">
            <div class="form-group">
                <label for="inputEmail" class="col-sm-2 col-md-2 control-label">用户名</label>
                <div class="col-sm-6 col-md-6">
                    <input type="text" class="form-control" id="inputUserName" placeholder="14121047" readonly>
                </div>
            </div>
            <div class="form-group">
                <label for="inputEmail" class="col-sm-2 col-md-2 control-label">邮箱</label>
                <div class="col-sm-6 col-md-6">
                    <input type="email" class="form-control" id="inputEmail" placeholder="xxxxxx@xx.com">
                </div>
            </div>
            <div class="form-group">
                <label for="inputNickname" class="col-sm-2 col-md-2 control-label">昵称</label>
                <div class="col-sm-6 col-md-6">
                    <input type="text" class="form-control" id="inputNickname" placeholder="高帅富" />
                </div>
            </div>
            <div class="form-group">
                <label for="inputPassword" class="col-sm-2 col-md-2 control-label">密码</label>
                <div class="col-sm-6 col-md-6">
                    <input type="password" class="form-control" id="inputPassword" placeholder="禁止输入非法字符"  readonly/>
                </div>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-6">
                    <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="startUpdate()">确认修改</button>
                </div>
            </div>
        </div>
        <br/>
    </div>
</div>

<script type="text/javascript">
    initData();
    function initData() {
        var userId ="${currentUser.id}";
        var user = getUserById(userId);
        var userDetail = getUserDetailById(userId);
        document.getElementById("inputUserName").value = user.username;
        document.getElementById("inputEmail").value = userDetail.email;
        document.getElementById("inputNickname").value = userDetail.nicheng;
        document.getElementById("inputPassword").value = user.password;
    }
    function startUpdate() {
        var loading = layer.load(0);
        var user = {};
        user.nickName = document.getElementById("inputNickname").value;
        user.email = document.getElementById("inputEmail").value;
        user.id="${currentUser.id}";
        if(user.nickName == ''){
            layer.msg('昵称不能为空',{icon:2});
            return;
        }
        if(user.nickName.length >= 15){
            layer.msg('用户名长度不能超过15个字符',{icon:2});
            return;
        }
        if(user.email == ''){
            layer.msg('邮箱不能为空',{icon:2});
            return;
        }
        var registerResult = null;
        $.ajax({
            async : false, //设置同步
            type : 'POST',
            url : 'updateInfo',
            data : user,
            dataType : 'json',
            success : function(result) {
                registerResult = result.result;
            },
            error : function() {
                layer.msg('修改失败',{icon:2});
            }
        });
        if(registerResult == 'success'){
            layer.close(loading);
            layer.msg('修改成功',{icon:1});
            window.location.href="exit";
        }
        else{
            layer.msg('修改失败',{icon:2});
        }
    }

    function getUserById(id) {
        var userResult = "";
        var user = {};
        user.id = id;
        $.ajax({
            async : false, //设置同步
            type : 'POST',
            url : 'getUserById',
            data : user,
            dataType : 'json',
            success : function(result) {
                userResult = result.result;
            },
            error : function() {
                layer.alert('查询错误');
            }
        });
        userResult = JSON.parse(userResult);
        return userResult;
    }

    function getUserDetailById(id) {
        var userDetailResult = "";
        var user = {};
        user.id = id;
        $.ajax({
            async : false, //设置同步
            type : 'POST',
            url : 'getUserDetailById',
            data : user,
            dataType : 'json',
            success : function(result) {
                userDetailResult = result.result;
            },
            error : function() {
                layer.alert('查询错误');
            }
        });
        userDetailResult = JSON.parse(userDetailResult);
        return userDetailResult;
    }
</script>
</body>
</html>