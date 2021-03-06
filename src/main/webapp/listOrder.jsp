<%@ page  contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>后台订单管理</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
    <link href="css/style.css" rel="stylesheet">

    <script src="js/jquery.min.js" type="text/javascript"></script>
    <script src="js/bootstrap.min.js" type="text/javascript"></script>
</head>
<style>
    a.disabled {
        pointer-events: none;
        filter: alpha(opacity=50); /*IE滤镜，透明度50%*/
        -moz-opacity: 0.5; /*Firefox私有，透明度50%*/
        opacity: 0.5; /*其他，透明度50%*/
    }
</style>
<script type="text/javascript">
    function orderDelivery(id) {
        $.ajax({
            async : false, //设置同步
            type : 'POST',
            url : 'orderDelivery',
            data : {"id":id},
            dataType : 'json',
            success : function(result) {
                if (result.result!=null){
                    window.location.href="findAllOrder";
                    layer.alert("成功发货",{icon:1,time:3000});
                }
            },
            error : function() {
                layer.alert('服务器异常');
            }
        });
    }

    function noagree(id) {
        $.ajax({
            async : false, //设置同步
            type : 'POST',
            url : 'noagree',
            data : {"id":id},
            dataType : 'json',
            success : function(result) {
                if (result.result!=null){
                    window.location.href="findAllOrder";
                    layer.alert("您已拒绝买家的申请",{icon:1,time:3000});
                }
            },
            error : function() {
                layer.alert('服务器异常');
            }
        });
    }

    function agree(id) {
        $.ajax({
            async : false, //设置同步
            type : 'POST',
            url : 'deleteOrder',
            data : {"id":id},
            dataType : 'json',
            success : function(result) {
                if (result.result!=null){
                    window.location.href="findAllOrder";
                    layer.alert("您已同意买家的申请",{icon:1,time:3000});
                }
            },
            error : function() {
                layer.alert('服务器异常');
            }
        });
    }
</script>
<body>
<jsp:include page="glhead.jsp"/>
<div id="wrapper">

    <!-- /. NAV SIDE  -->
    <div id="page-wrapper">
        <div id="page-inner">
            <div class="row">
                <div class="col-md-12">
                    <h1 class="page-header">
                        订单管理
                        <small></small>
                    </h1>
                </div>
            </div>

            <div class="row">
                <div class="col-md-12">
                    <!-- Advanced Tables -->
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            订单管理表
                        </div>
                        <div class="panel-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-hover" id="dataTables-example">
                                    <thead>
                                    <tr>
                                        <th>订单号</th>
                                        <th>商品信息</th>

                                        <th>收货人姓名</th>
                                        <th>手机号码</th>

                                        <th>订单创建时间</th>
                                        <th>订单支付时间</th>
                                        <th>订单发货时间</th>
                                        <th>确认收货时间</th>
                                        <th>订单状态</th>
                                        <th>操作</th>

                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${pageO.list}" var="o">
                                        <tr>
                                            <td>${o.order_code}</td>
                                            <td><a href="findOrderItem?id=${o.id}">点击查看</a></td>

                                            <td>${o.receiver}</td>
                                            <td>${o.mobile}</td>

                                            <td><fmt:formatDate type="both" value="${o.create_date}"/></td>
                                            <td><fmt:formatDate type="both" value="${o.pay_date}"/></td>
                                            <td><fmt:formatDate type="both" value="${o.delivery_date}"/></td>
                                            <td><fmt:formatDate type="both" value="${o.confirm_date}"/></td>
                                            <td>
                                                <c:if test="${o.status==0}">
                                                    待支付
                                                </c:if>
                                                <c:if test="${o.status==1}">
                                                    待发货
                                                </c:if>
                                                <c:if test="${o.status==2}">
                                                    待收货
                                                </c:if>
                                                <c:if test="${o.status==3}">
                                                    交易完成
                                                </c:if>
                                                <c:if test="${o.status==4}">
                                                    申请取消
                                                </c:if>
                                            </td>
                                            <td>

                                                        <c:if test="${o.status==1}">
                                                            <a href="#" onclick="orderDelivery(${o.id})">
                                                                <button class="btn btn-primary btn-xs">发货</button>
                                                            </a>
                                                        </c:if>

                                                <c:if test="${o.status==4}">
                                                    <a href="#" onclick="agree(${o.id})">
                                                        <button class="btn btn-primary btn-xs">同意</button>
                                                    </a>
                                                    <a href="#" onclick="noagree(${o.id})">
                                                        <button class="btn btn-danger btn-xs">不同意</button>
                                                    </a>
                                                </c:if>

                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <div class="center">
                                第${pageO.pageNum}/${pageO.pages}页,共${pageO.total}条数据
                                <a href="findAllOrder">首页</a>
                                <c:if test="${pageO.isFirstPage}">
                                <a href="" class="disabled">上一页</a>
                                </c:if>
                                <c:if test="${!pageO.isFirstPage}">
                                    <a href="findAllOrder?page=${pageO.prePage}">上一页</a>
                                </c:if>
                                <c:forEach items="${pageO.navigatepageNums}" var="navigatepageNums">
                                    <a href="findAllOrder?page=${navigatepageNums}">${navigatepageNums}</a>
                                </c:forEach>
                                <c:if test="${pageO.isLastPage}">
                                <a href="" class="disabled">下一页</a>
                                </c:if>
                                <c:if test="${!pageO.isLastPage}">
                                    <a href="findAllOrder?page=${pageO.nextPage}">下一页</a>
                                </c:if>
                                <a href="findAllOrder?page=${pageO.lastPage}">尾页</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
</body>
</html>
