<%@ page pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<head>
    <meta charset="UTF-8">
    <title>登录页面</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/bootstrap.min.js" type="text/javascript"></script>
    <script src="js/layer.js" type="text/javascript"></script>
    <script type="text/javascript">

        function changeImage() {
            document.getElementById("verifyCodeImage").src = "getCode?time"
                + new Date().getTime();
        };
        function login() {
            var user = {};
            user.username= document.getElementById("inputEmail").value;
            user.password = document.getElementById("inputPassword").value;
            user.verifyCode=$("#verifyCode").val();
            if (user.username== "") {
                layer.msg('请输入用户名',{icon:2});
                return false;
            }

            if (user.password== "") {
                layer.msg('请输入密码',{icon:2});
                return false;
            }
            if (user.verifyCode== "") {
                layer.msg('请输入验证码',{icon:2});
                return false;
            }
            $.ajax({
                async : false, //设置同步
                type : 'POST',
                url : 'gllogin',
                data : user,
                dataType : 'json',
                success : function(result) {
                    if (result.message=='success') {
                        layer.alert('登录成功',{icon: 1, time: 2000});
                        window.location.href="control.jsp"
                    }
                    else if (result.message=='fail') {
                        layer.alert('用户名或密码错误',{icon: 2, time: 1500});
                    }else {
                        layer.alert('验证码错误',{icon: 2, time: 1500});
                    }
                },
                error : function() {
                    layer.alert('登录出错');
                }
            });
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
<jsp:include page="header.jsp"/>
<div class="container-fluid" style="padding-top: 80px;padding-bottom: 80px" >

    <h1 class="title center">后台管理系统</h1>
    <br/>
    <div class="col-sm-offset-4 col-md-offest-4">
        <!-- 表单输入 -->
        <div  class="form-horizontal">
            <div class="form-group">
                <label for="inputEmail" class="col-sm-2 col-md-2 control-label">邮箱/用户名</label>
                <div class="col-sm-8 col-md-3">
                    <input type="text" class="form-control" id="inputEmail" placeholder="请输入用户名"/>
                </div>
            </div>
            <div class="form-group">
                <label for="inputPassword" class="col-sm-2 col-md-2 control-label">密码</label>
                <div class="col-sm-8 col-md-3">
                    <input type="password" class="form-control" id="inputPassword" placeholder="请输入密码" />
                </div>
            </div>
            <div class="form-group">
                <label for="verifyCode" class="col-sm-2 col-md-2 control-label">验证码</label>
                <div class="col-sm-8 col-md-1">
                <input type="text" class="form-control" id="verifyCode" placeholder="验证码" maxlength="4">
                </div>
                <span class="code_img"> <img src="/getCode" id="verifyCodeImage" onclick="changeImage();"></span>
            </div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-3">
                    <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="login()">登录</button>
                </div>
            </div>
        </div>
        <br/>
    </div>
</div>
<script type="text/javascript">
    changeImage();
</script>
</body>
</html>
