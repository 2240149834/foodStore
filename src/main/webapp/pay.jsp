<%@ page contentType="text/html;charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>订单确认</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">

    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/bootstrap.min.js" type="text/javascript"></script>
    <script src="js/layer.js" type="text/javascript"></script>
</head>

<style type="text/css">
    div.jumbotron{
        width: 1000px;
        margin-left: 440px;
    }
    div.aliPayPageDiv{
        text-align: center;
        padding-bottom: 40px;
        max-width: 1013px;
        margin: 10px auto;
    }
    div.aliPayPageLogo{
        margin: 20px;
    }
    span.confirmMoneyText{
        color: #4D4D4D;
    }
    span.confirmMoney{
        display: block;
        color: #FF6600;
        font-weight: bold;
        font-size: 20px;
        margin: 10px;
    }
    button.confirmPay{
        background-color: #00AAEE;
        border: 1px solid #00AAEE;
        text-align: center;
        line-height: 31px;
        font-size: 14px;
        font-weight: 700;
        color: white;
        width: 107px;
        margin-top: 20px;
    }

    img.aliPayImg {
        width: 300px;
        height: 300px;
    }
</style>
<script type="text/javascript">
    function comPay() {
        var succResult="";
        var order_id=new Array();
        <c:forEach items="${orderItemList}" var="oi">
        order_id.push("${oi.order_id}"); //js中可以使用此标签，将EL表达式中的值push到数组中
        </c:forEach>
        console.log(order_id);
        $.ajax({
            async : false, //设置同步
            type : 'POST',
            url : 'payed',
            data :{"order_id":order_id.toString()},
            dataType : 'json',
            success : function(result) {
                succResult=result.result;
            },
        });
        if (succResult=='success'){
            allOrders1();
        }if (succResult=='fail'){
            layer.alert('库存不足,购买失败',{icon: 2, time: 1500});
        }
    }
    function allOrders1(){
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
<body>
<jsp:include page="header.jsp"/>
<div class="jumbotron">
    <h2 align="center">订单支付页面</h2>
</div>
<div class="aliPayPageDiv">
    <div class="aliPayPageLogo">
        <img class="pull-left" src="img/fore/simpleLogo.png">
        <div style="clear:both"></div>
    </div>
    <c:set var="all" value="0"></c:set>
     <c:forEach var="oi" items="${orderItemList}">
         <c:set var="all" value="${all+oi.number*oi.product.price}"></c:set>
     </c:forEach>

    <div>
        <span class="confirmMoneyText">扫一扫付款（元）</span>
        <span class="confirmMoney">
		￥${all}</span>

    </div>
    <div>
        <img class="aliPayImg" src="imgs/spbeijin.jpg">
    </div>
    <div>
            <button class="confirmPay" onclick="comPay()">确认支付</button>
    </div>

</div>
</body>
</html>