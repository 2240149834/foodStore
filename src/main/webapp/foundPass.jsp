<%@ page contentType="text/html;charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>密码修改</title>
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
    <h1 class="title center">修改密码</h1>
    <br/>
    <div class="col-sm-offset-4 col-md-offest-4">
        <!-- 表单输入 -->
        <div  class="form-horizontal">
            <div class="form-group">
                <label for="inputPassword" class="col-sm-2 col-md-2 control-label">密码</label>
                <div class="col-sm-8 col-md-3">
                    <input type="text" class="form-control" id="inputPassword" placeholder="密码" />
                </div>
            </div>
            <div class="form-group">
                <label for="reinputPassword" class="col-sm-2 col-md-2 control-label">确认密码</label>
                <div class="col-sm-8 col-md-3">
                    <input type="password" class="form-control" id="reinputPassword" placeholder="请再次输入密码" />
                </div>
            </div>
            <div class="form-group">
                <label for="verifyCode" class="col-sm-2 col-md-2 control-label">验证码</label>
                <div class="col-sm-8 col-md-1">
                    <input type="text" class="form-control" id="verifyCode" placeholder="验证码" maxlength="4">
                </div>
                <span class="code_img"> <img src="/getCode" id="verifyCodeImage" onclick="changeImage1();"></span>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-3">
                    <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="updatePass()">确认修改</button>
                </div>
            </div>
        </div>
        <br/>
    </div>
</div>

<script type="text/javascript">
    changeImage1();
    function changeImage1() {
        document.getElementById("verifyCodeImage").src = "getCode?time"
            + new Date().getTime();
    };
    function updatePass() {
        var loading = layer.load(0);
        var user = {};
        user.password = document.getElementById("inputPassword").value;
        user.reinputPassword = document.getElementById("reinputPassword").value;
        user.id="${founduser.id}";
        if(user.password == ''){
            layer.msg('密码不能为空',{icon:2});
            return;
        }
        if(user.password.length>= 20){
            layer.msg('密码长度不能超过20个字符',{icon:2});
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
            url : 'foundpass',
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
</script>
</body>
</html>