<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt_rt" %>
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
</head>
<body>
<jsp:include page="header.jsp"/>
<div class="jumbotron">
    <h1 class="text-info">欢迎来到订单详情页</h1>
</div>
<div class="buyPageDiv">
        <h3 >订单详情</h3>
       <div id="autore">
           <div role="tabpanel" class="tab-pane active" id="all">
        <table class="table table-hover center">
            <thead>
            <tr>
                <th>商品</th>
                <th>商品名</th>
                <th>数量</th>
                <th>小计</th>
            </tr>
            </thead>
            <tbody >
            <c:set var="all" value="0"></c:set>
            <c:set var="count" value="0"></c:set>
            <c:set var="kind" value="0"></c:set>
                <c:forEach items="${orderItemList}" var="order">
                    <tr>
                        <td width="200px"><img src="${order.product.imgurl}" width="150" height="100"></td>
                        <td>
                             ${order.product.name}
                        </td>
                        <td>${order.number}</td>
                        <td>${order.number*order.product.price}</td>
                    </tr>
                    <c:set var="all" value="${all+order.number*order.product.price}"/>
                    <c:set var="count" value="${count+order.number}"/>
                    <c:set var="kind" value="${kind+1}"/>
                </c:forEach>
            </tbody>

        </table>
               <div class="row">
                   <div class="col-md-12 col-lg-12 col-sm-12">
                       <div style="border-top: solid gray;">
                           <div style="margin-left:20px;" class="pull-right total">
                               <label>累计金额:<span class="currency">￥</span><span id="priceTotal" class="large-bold-red">${all}</span>元</label>
                           </div>
                           <div class="pull-right">
                               <label>挑选了<span id="itemCount">${kind}</span>种商品，共计<span id="qtyCount" >${count}</span>件</label>
                           </div>
                           <div class="pull-right selected" id="selected">
                               <span id="selectedTotal"></span>
                           </div>
                       </div>
                   </div>
               </div>
               <div>
                   <p><label>收货人：</label>${orderxq.receiver}</p>
                   <p><label>收货地址：</label>${orderxq.address}</p>
                   <p><label>联系电话：</label>${orderxq.mobile}</p>
                   <p><label>下单时间：</label><fmt:formatDate  value="${orderxq.create_date}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
                   <p><label>付款时间：</label><fmt:formatDate  value="${orderxq.pay_date}" pattern="yyyy-MM-dd HH:mm:ss"/></p>
               </div>
           </div>

       </div>
</div>
</body>
</html>
