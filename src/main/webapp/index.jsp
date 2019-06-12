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

        function foundpass() {
                $('#myModal').modal();
             };
                function checkemail() {
                    var email=document.getElementById("txt_departmentname").value;
                    if (email==''){
                        layer.msg("请输入邮箱",{icon:5});
                    }else {
                        $.ajax({
                            async : false, //设置同步
                            type : 'POST',
                            url : 'getUserByemail',
                            data : {"email":email},
                            dataType : 'json',
                            success : function(result) {
                                if (result.result=='success') {
                                    window.location.href="foundPass.jsp"
                                }else {
                                    layer.alert('没有此用户邮箱',{icon:2});
                                }
                            },
                            error : function() {
                                layer.alert('查询出错');
                            }
                        });
                    }

                }
        function changeImage() {
            document.getElementById("verifyCodeImage").src = "getCode?time"
                + new Date().getTime();
        };
        window.onload = function() {
            var oUser = document.getElementById('inputEmail');
            var oPswd = document.getElementById('inputPassword');
            var oRemember = document.getElementById('remebers');
            //页面初始化时，如果帐号密码cookie存在则填充
            if (getCookie('user') && getCookie('pswd')) {
                oUser.value = getCookie('user');
                oPswd.value = getCookie('pswd');
                oRemember.checked = true;
            }
            //复选框勾选状态发生改变时，如果未勾选则清除cookie
            oRemember.onchange = function () {
                if (!this.checked) {
                    delCookie('user');
                    delCookie('pswd');
                }
            };
        }
        //设置cookie
        function setCookie(name,value,day){
            var date = new Date();
            date.setDate(date.getDate() + day);
            document.cookie = name + '=' + value + ';expires='+ date;
        };
        //获取cookie
        function getCookie(name){
            var reg = RegExp(name+'=([^;]+)');
            var arr = document.cookie.match(reg);
            if(arr){
                return arr[1];
            }else{
                return '';
            }
        };
        //删除cookie
        function delCookie(name){
            setCookie(name,null,-1);
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
                url : 'login',
                data : user,
                dataType : 'json',
                success : function(result) {
                    if (result.message=='success') {
                        if(document.getElementById('remebers').checked){
                            setCookie('user',user.username,7); //保存帐号到cookie，有效期7天
                            setCookie('pswd',user.password,7); //保存密码到cookie，有效期7天
                        }
                        layer.alert('登录成功',{icon: 1, time: 2000});
                        window.location.href="main.jsp"
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

    <h1 class="title center">用户登录</h1>
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
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-6">
                    <input  type="checkbox" id="remebers" style="margin-top: 5px">记住我</input>
                    <a href="register.jsp" style="margin-top:-5px;margin-left: 42px">立即注册</a>
                    <a href="#" onclick="foundpass()" style="margin-top:-5px;margin-left: 70px">忘记密码</a>
                </div>
            </div>
        </div>
        <br/>
    </div>
</div>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
             <div class="modal-dialog" role="document">
                 <div class="modal-content">
                     <div class="modal-header">
                         <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                         <h4 class="modal-title" id="myModalLabel">请填写注册时的邮箱</h4>
                     </div>
                     <div class="modal-body">

                         <div class="form-group">
                             <label for="txt_departmentname">邮箱</label>
                             <input type="text" name="txt_departmentname" class="form-control" id="txt_departmentname" placeholder="邮箱">
                         </div>

                     <div class="modal-footer">
                         <button type="button" class="btn btn-default" data-dismiss="modal"><span  aria-hidden="true"></span>取消</button>
                         <button type="button" id="btn_submit" class="btn btn-primary" data-dismiss="modal" onclick="checkemail()"><span  aria-hidden="true"></span>确定</button>
                     </div>
                 </div>
             </div>
         </div>
</div>
<script type="text/javascript">
    changeImage();
</script>
</body>
</html>
