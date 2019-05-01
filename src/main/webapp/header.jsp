<%@ page contentType="text/html;charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>头部</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">
    <script src="js/bootstrap.min.js" type="text/javascript"></script>
    <script src="js/layer.js" type="text/javascript"></script>
</head>
<body>
<!--导航栏部分-->
<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="main.jsp">回到首页</a>
        </div>

        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">

            <ul class="nav navbar-nav navbar-right">
                <c:if test="${empty currentUser}">
                    <li><a href="register.jsp" methods="post">注册</a></li>
                    <li><a href="index.jsp" methods="post">登录</a></li>
                </c:if>
                <c:if test="${not empty currentUser}">
                    <c:if test="${currentUser.userDetail.role == 1}">
                        <li><a href="control.jsp" methods="post">管理员</a></li>
                    </c:if>
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
                                ${currentUser.userDetail.nicheng}
                            <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <c:if test="${currentUser.userDetail.role != 1}">
                            <li><a href="shoopingCar.jsp">购物车</a></li>
                            <li><a href="#" onclick="findOrder()">我的订单</a></li>
                            </c:if>
                            <c:if test="${currentUser.userDetail.role == 1}">
                                <li><a href="findAllOrder">处理订单</a></li>
                            </c:if>
                            <li><a href="setInfo.jsp">个人资料修改</a></li>
                            <li><a href="exit">注销登录</a></li>
                        </ul>
                    </li>
                </c:if>
            </ul>

            <div class="navbar-form navbar-right">
                <div class="form-group">
                    <input type="text" class="form-control" placeholder="茉莉蜜茶" id="searchKeyWord"/>
                </div>
                <c:if test="${currentUser.userDetail.role == 1}">
                <button class="btn btn-default" onclick="searchProduct();" disabled>查找</button>
                </c:if>
            </div>
        </div>
    </div>
</nav>
<script type="text/javascript">
    $('.dropdown-toggle').dropdown();
    function searchProduct() {
        var search = {};
        search.searchKeyWord = document.getElementById("searchKeyWord").value;
        var searchResult = "";
        $.ajax({
            async : false,
            type : 'POST',
            url : 'searchPre',
            data : search,
            dataType : 'json',
            success : function(result) {
                searchResult = result.result;
            },
            error : function() {
                layer.alert('查询错误');
            }
        });
        if(searchResult == "success"){
            window.location.href = "search.jsp";
        }
        else{
            layer.alert(searchResult)
        }
    }
    function findOrder(){
        var nothing={};
        $.ajax({
            async : false, //设置同步
            type : 'POST',
            url : 'findMyOrder',
            data :nothing,
            dataType : 'json',
            success : function(result) {
                if (result.result!=null) {
                    window.location.href="myOrder.jsp"
                }
            },
        });
    }
</script>
</body>
</html>