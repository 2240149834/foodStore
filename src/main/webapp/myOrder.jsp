<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>我的订单</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">

    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/bootstrap.min.js" type="text/javascript"></script>
    <script src="js/layer.js" type="text/javascript"></script>
    <style type="text/css">
        div.buyPageDiv {
            margin: 100px auto;
            max-width: 1013px;
        }
        .jumbotron{
            width: 1000px;
            margin-left: 440px;
        }
    </style>
    <script type="text/javascript">

        function quxiaoOrder(id) {
            $.ajax({
                async : false, //设置同步
                type : 'POST',
                url : 'quxiaoOrder',
                data :{"id":id},
                dataType : 'json',
                success : function(result) {
                    if (result.result!=null) {
                        layer.msg('申请成功,卖家同意后自动删除', {icon: 1,time: 2000});
                    }
                },
                error : function() {
                    layer.alert('服务器异常');
                }
            });
            allOrders();
        }

        function deleteOrder(id) {
            $.ajax({
                async : false, //设置同步
                type : 'POST',
                url : 'deleteOrder',
                data :{"id":id},
                dataType : 'json',
                success : function(result) {
                    if (result.result!=null) {
                        layer.msg('删除成功', {icon: 1,time: 500});
                    }
                },
                error : function() {
                    layer.alert('服务器异常');
                }
            });
            allOrders();
        }
        function comfire(id) {
            $.ajax({
                async : false, //设置同步
                type : 'POST',
                url : 'comfire',
                data :{"id":id},
                dataType : 'json',
                success : function(result) {
                    if (result.result!=null) {
                        layer.msg('已收货', {icon: 1,time: 1000});
                    }
                },
                error : function() {
                    layer.alert('服务器异常');
                }
            });
            allOrders();
        }
    </script>
</head>
<body>
<jsp:include page="header.jsp"/>
<div class="jumbotron">
    <h1 class="text-info">欢迎来到订单页</h1>
    <p class="text-primary">你的所有订单如下</p>
</div>
<div class="buyPageDiv">
        <h3 >订单信息</h3>
       <div id="autore">
           <div role="tabpanel" class="tab-pane active" id="all">
        <table class="table table-hover center">
            <thead>
            <tr>
                <th>订单号</th>
                <th>订单信息</th>
                <th>订单用户</th>
                <th>订单状态</th>
                <th>订单操作</th>
            </tr>
            </thead>
            <tbody >
                <c:forEach items="${myorderList}" var="order">
                    <tr>
                        <td>${order.order_code }</td>
                        <td>
                             <a href="findOrderItem?id=${order.id}">查看详情</a>
                        </td>
                        <td>${order.receiver}</td>
                        <td><c:if test="${order.status==0}">
                            <a href="orderPay?id=${order.id}">待支付</a>
                        </c:if>
                            <c:if test="${order.status==1}">
                            待发货
                           </c:if>
                            <c:if test="${order.status==2}">
                                <button class="btn-danger btn" onclick="comfire(${order.id})">确认收货</button>
                            </c:if>
                            <c:if test="${order.status==3}">
                                交易完成
                            </c:if>
                            <c:if test="${order.status==4}">
                                申请中,等待卖家处理
                            </c:if>
                        </td>

                        <td>
                            <c:if test="${order.status<2}">
                            <button class="btn-danger btn" onclick="quxiaoOrder(${order.id})" >申请取消订单</button>
                            </c:if>
                            <c:if test="${order.status==3}">
                                <button class="btn-danger btn" onclick="deleteOrder(${order.id})" >删除订单</button>
                            </c:if>
                        </td>
                    </tr>

                </c:forEach>
            </tbody>

        </table>
           </div>

       </div>
</div>
<script type="text/javascript">
    allOrders();
    function allOrders(){
        var nothing={};
        $.ajax({
            async : false, //设置同步
            type : 'POST',
            url : 'findMyOrder',
            data :nothing,
            dataType : 'json',
            success : function(result) {
                if (result.result!=null) {
                    $("#autore").load(location.href + " #autore");
                }
            },
            error : function() {
                layer.alert('服务器异常');
            }
        });
    }
</script>
</body>
</html>
