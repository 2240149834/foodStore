<%@ page contentType="text/html;charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>购物车</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">

    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/bootstrap.min.js" type="text/javascript"></script>
    <script src="js/layer.js" type="text/javascript"></script>
    <script type="text/javascript">

        /*复选框全选或全不选效果*/
        function selectAll(){
            var checkInputs = document.getElementsByName("hotelName");
            var checkAllInputs = document.getElementById('checkAll');
            for(var i=0;i< checkInputs.length;i++){
                checkInputs[i].checked=checkAllInputs.checked;
            }
        }

        /*复选框全选或全不选效果*/
        function checkAll() {
            var checkInputs = document.getElementsByName("hotelName");
            var checkAllInputs = document.getElementById('checkAll');
            for (var i = 0; i < checkInputs.length; i++) {
                if (checkAllInputs.checked) {
                checkInputs[i].checked = true;
            }else
                checkInputs[i].checked = false;
            }
            dealFee()
        }

        /*根据单个复选框的选择情况确定全选复选框是否被选中*/
         function single(){
            var checkInputs = document.getElementsByName("hotelName");
            var checkAllInputs = document.getElementById('checkAll');
            var count=0;
            for(var i=0;i< checkInputs.length;i++){
                if(checkInputs[i].checked) {
                    count++;
                }
                if (count === checkInputs.length ) {//判断是否全选
                    checkAllInputs.checked = true;
                    selectAll();
                } else {
                    checkAllInputs.checked=false;
                }
            }
            dealFee();
        }
        function subCounts(id,count) {
            $.ajax({
                async : false, //设置同步
                type : 'POST',
                url : 'setShoopingCar',
                data : {"id":id,"count":count},
                dataType : 'json',
                success : function(result) {
                    if (result.result!=null){
                        $("#autore").load(location.href + " #autore");
                    }
                },
                error : function() {
                    layer.alert('服务器异常');
                }
            });
        }

        function addCounts(id,count) {
            $.ajax({
                async : false, //设置同步
                type : 'POST',
                url : 'setShoopingCar',
                data :{"id":id,"count":count},
                dataType : 'json',
                success : function(result) {
                    if (result.result!=null){
                        $("#autore").load(location.href + " #autore");
                    }
                },
                error : function() {
                    layer.alert('服务器异常');
                }
            });
        }

        function deleteshooping(id) {
            var ids=new Array();
            ids.push(id);
            $.ajax({
                async : false, //设置同步
                type : 'POST',
                url : 'delShoopingCar',
                data :{"id":ids.toString()},
                dataType : 'json',
                success : function(result) {
                    layer.alert(result.result)
                    $("#autore").load(location.href + " #autore");
                },
                error : function() {
                    layer.alert('删除失败');
                }
            });
        }
        function pldel1() {
            var ids=new Array();
            var checkInputs = document.getElementsByName("hotelName");
            for(var i=0;i< checkInputs.length;i++) {
                if (checkInputs[i].checked) {
                    ids.push(checkInputs[i].value);
                }
            }
            $.ajax({
                async : false,
                type : 'POST',
                url : 'delShoopingCar',
                data : {"id":ids.toString()},
                dataType : 'json',
                success : function(result) {
                    layer.alert(result.result);
                    $("#autore").load(location.href + " #autore");
                },
                error : function() {
                    layer.alert('删除失败');
                }
            });
        }
        function confirmPre() {
            var buyProducts = new Array;
            var buyProductsCounts = new Array;
            var buyCounts = 0;
            var checkInputs = document.getElementsByName("hotelName");
            var productCounts = document.getElementsByName("productCounts");
            for(var i=0;i<checkInputs.length;i++){
                if(checkInputs[i].checked){
                    buyProducts[buyCounts] =checkInputs[i].value;
                    buyProductsCounts[buyCounts] = parseInt(productCounts[i].innerHTML);
                    buyCounts++;
                }
            }
            if(buyCounts == 0){
                layer.msg("未选中商品",{icon:2});
            }
            else{
                // console.log(buyProducts.toString());
                // console.log(buyProductsCounts.toString());
                // console.log(buyPrices.toString());
                buyConfirm1(buyProducts,buyProductsCounts);
            }
        }
        function buyConfirm1(buyProducts,buyProductsCounts) {
                $.ajax({
                    async: false,
                    type: 'POST',
                    url: 'getOrderInfo',
                    data:{"productIds":buyProducts.toString(),"counts":buyProductsCounts.toString()},
                    dataType: 'json',
                    success: function (result) {
                        if (result.result!=null) {
                            window.location.href = "buyPage.jsp";
                        }
                    },
                    error: function () {
                        layer.alert('发生异常');
                    }
                });
        }

        function dealFee() {
            var chk = document.getElementsByName('hotelName');
            var price = $(".price");
            var productCounts= document.getElementsByName('productCounts');
            var total=0;
            var nums=0;
            var sums=0;
            for (var i = 0; i < chk.length; i++) {
                if (chk[i].checked) {
                    total += (parseFloat(productCounts[i].innerHTML) * parseFloat(price[i].innerHTML));
                    nums++;
                    sums+=parseInt(productCounts[i].innerHTML);
                }
            }
            document.getElementById('itemCount').innerText = nums;
            document.getElementById('priceTotal').innerText = total.toFixed(2);
            document.getElementById('qtyCount').innerText = sums;
        }
    </script>
</head>
<body >
<jsp:include page="header.jsp"/>
<div class="col-sm-10 col-sm-offset-4 col-md-15 col-md-offset-1 main">
    <div class="jumbotron">
        <h1 class="text-info">欢迎来到购物车</h1>
        <p class="text-primary">你的购物清单如下</p>
    </div>
    <div id="autore">
<table id="cartTable" class="cart table table-condensed" >
    <thead>
    <a href="main.jsp" type="button" class="btn btn-info">继续购物</a>
    <tr>
        <th style="width:60px;"><label><input class="check-all check" type="checkbox" onclick="checkAll()" id="checkAll"/> 全选</label></th>
        <th><label>商品名</label></th>
        <th style="width:100px;"><label>单价</label></th>
        <th style="width:120px;"><label>数量</label></th>
        <th style="width:100px;"><label>小计</label></th>
        <th style="width:40px;"><label>操作</label></th>
    </tr>
    </thead>

    <div class="form-group">
    <c:forEach items="${cart}" var="carts">
    <tr >
        <td ><input class="check-one check" type="checkbox" name="hotelName" value="${carts.key.id}" onClick="single()"/> </td>
        <td width="300px">
                <img src="${carts.key.imgurl}" width="150" height="100"><label>${carts.key.name}</label>
        </td>
        <td class="number small-bold-red"><span class="price">${carts.key.price}</span></td>
        <td >
            <button type="button" class="btn btn-default" onclick="subCounts('${carts.key.id }','${carts.value-1}')">-</button>
            <button name="productCounts" type="button" class="btn btn-default">${carts.value}</button>
            <button type="button" class="btn btn-default" onclick="addCounts('${carts.key.id }','${carts.value+1}')">+</button>
        </td>
        <td class="subtotal number small-bold-red">${carts.key.price*carts.value}</td>
        <td class="operation"><button type="button" class="btn btn-danger" onclick="deleteshooping('${carts.key.id }')">删除</button></td>
    </tr>
    </c:forEach>
    </div>

</table>
<div class="row">
    <div class="col-md-12 col-lg-12 col-sm-12">
        <div style="border-top: solid gray;">
            <button type="button"  class="btn btn-danger btn-sm" onclick="pldel1()">批量删除</button>
            <div class="pull-right">
                <button type="button" class="btn btn-danger"  style="margin-left: 20px; " onclick="confirmPre()">结算</button>
            </div>
            <div style="margin-left:20px;" class="pull-right total">
                <label>金额合计:<span class="currency">￥</span><span id="priceTotal" class="large-bold-red">0</span>元</label>
            </div>
            <div class="pull-right">
                <label>您选择了<span id="itemCount">0</span>种商品，共计<span id="qtyCount" >0</span>件</label>
            </div>
            <div class="pull-right selected" id="selected">
                <span id="selectedTotal"></span>
            </div>
        </div>
    </div>
     </div>
    </div>
</div>
</body>
</html>