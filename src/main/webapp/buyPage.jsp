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
    <script src="js/distpicker.data.js" type="text/javascript"></script>
    <script src="js/distpicker.js" type="text/javascript"></script>
    <script src="js/main.js" type="text/javascript"></script>
    <script src="js/bootstrap.min.js" type="text/javascript"></script>
    <script src="js/layer.js" type="text/javascript"></script>
    <style type="text/css">
    div.buyPageDiv {
        margin: 100px auto;
        max-width: 1013px;
    }

</style>
    <script type="text/javascript">
        function topay() {
            var province=$("#Province").find("option:selected").text();
            var City=$("#City").find("option:selected").text();
            var Area=$("#Area").find("option:selected").text();
            var add=document.getElementById("address").value;
            if (add=="") {
                layer.msg("请填写详细地址");
            }
            var address=province+City+Area+add;
            var name=document.getElementById("name").value;
            if (name=="") {
                layer.msg("请填写收货人");
            }
            var phone=document.getElementById("phone").value;
            if (phone=="") {
                layer.msg("请填写收货人电话");
            }
            var productIds=new Array();
            <c:forEach items="${productList}" var="p">
            productIds.push("${p.key.id}"); //js中可以使用此标签，将EL表达式中的值push到数组中
            </c:forEach>

            var counts=new Array();
            <c:forEach items="${productList}" var="p">
            counts.push("${p.value}"); //js中可以使用此标签，将EL表达式中的值push到数组中
            </c:forEach>
            console.log(add);
            $.ajax({
                async : false, //设置同步
                type : 'POST',
                url : 'createOrder',
                data :{"message":"message","address":address,"name":name,"phone":phone,"productIds":productIds.toString(),"counts":counts.toString()},
                dataType : 'json',
                success : function(result) {
                    if (result.result!=null) {
                        window.location.href = "pay.jsp";
                    }else {
                        layer.alert("发生异常");
                    }
                },
            });
        }
    </script>
</head>
<body>
<jsp:include page="header.jsp"/>
<div class="buyPageDiv">
    <div class="form-horizontal">
        <h3>输入收货地址</h3>
        <div class="form-group">
            <label class="col-sm-2 control-label">地址</label>
            <div class="col-sm-10" data-toggle="distpicker">
                <select  name="cmbProvince" id="Province" style="width: 120px;"></select>
                <select  name="cmbCity"  id="City" style="width: 120px;"></select>
                <select  name="cmbArea" id="Area" style="width: 120px;"></select>
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">详细地址</label>
            <div class="col-sm-3">
                <input type="text" class="form-control" id="address" placeholder="请输入区县以后具体地址" >
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">收货人姓名</label>
            <div class="col-sm-3">
                <input type="text" class="form-control" id="name" placeholder="请输入名字">
            </div>
        </div>
        <div class="form-group">
            <label class="col-sm-2 control-label">手机号码</label>
            <div class="col-sm-3">
                <input type="text" class="form-control" id="phone" placeholder="请输入11位手机号码">
            </div>
        </div>
            <h3 >确认订单信息</h3>
            <table class="table table-responsive">
                <thead>
                <tr>
                    <th>
                        商品
                    </th>
                        <th>商品名</th>
                    <th>单价</th>
                    <th>数量</th>
                    <th>小计</th>
                </tr>
                </thead>
                <tbody >
                <c:set var="all" value="0"></c:set>
                <c:forEach items="${productList}" var="oi">
                    <tr >
                        <td style="width: 300px"><img src="${oi.key.imgurl}" style="width: 150px;height: 100px; ">
                        </td>
                        <td >
                            <a href="productDe?id=${oi.key.id}">
                                    ${oi.key.name}
                            </a>

                        </td>
                        <td>
                            <span>${oi.key.price}</span>
                        </td>
                        <td>
                            <span>${oi.value}</span>
                        </td>
                        <td>
                            <span>${oi.key.price*oi.value}</span>
                        </td>
                        <c:set var="all" value="${all+oi.key.price*oi.value}"/>
                    </tr>
                </c:forEach>
                </tbody>
                <tr class="rowborder">
                    <td colspan="2"></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
            </table>
        <div class="form-group">
            <div class="col-lg-10" style="margin-left: 830px">
        <c:if test="${productList!=null}">
                <label >
                    <input type="radio" value="" checked="checked">
                    普通配送
                </label>

                <select class="form-group" style="margin-left: 4px">
                    <option>快递 免邮费</option>
                </select>
            </div>
        </c:if>
        </div>
        <div class="form-group">
            <div class="col-lg-10 col-sm-offset-2">
                <span class="pull-right" style="margin-right: 10px">店铺合计(含运费): ￥${all}</span>
            </div>
        </div>

        <div class="form-group">
            <div class="col-lg-10 col-sm-offset-10">
                <span style="margin-left: 40px">实付款：</span>
                <span style="margin-right: 70px">￥${all}</span>
            </div>
        </div>

           <div class="form-group">
            <div class="col-sm-4 col-lg-offset-9">
                <button class="btn-danger col-lg-6 btn"  onclick="topay()" style="margin-left: 80px">去支付</button>
            </div>
           </div>
    </div>
</div>
</body>
</html>
