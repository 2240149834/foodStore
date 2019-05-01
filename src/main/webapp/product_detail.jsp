<%@ page contentType="text/html;charset=UTF-8"  pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>商品详情</title>

      <script src="js/jquery.min.js" type="text/javascript"></script>
      <link href="css/bootstrap.min.css" rel="stylesheet">
      <link href="css/style.css" rel="stylesheet">

      <script src="js/bootstrap.min.js" type="text/javascript"></script>
      <script src="js/layer.js" type="text/javascript"></script>
      <script type="text/javascript">

          var userId = "";
          if(${not empty currentUser}){
              userId = "${currentUser.id}";
          }

          function addToShoppingCar(productId) {
              if (userId == null || userId == undefined || userId == "") {
                  window.location.href = "index.jsp";
              } else {
                  var productCounts = document.getElementById("productCounts");
                  var counts = parseInt(productCounts.innerHTML);
                  var shoppingCar = {};
                  shoppingCar.productId = productId;
                  shoppingCar.counts = counts;
                  var addResult = "";
                  $.ajax({
                      async: false,
                      type: 'POST',
                      url: 'addShoppingCar',
                      data: shoppingCar,
                      dataType: 'json',
                      success: function (result) {
                          addResult = result.result;
                      },
                      error: function () {
                          layer.alert('服务器错误');
                      }
                  });
                  if (addResult == "success") {
                      layer.confirm('前往购物车？', {icon: 1, title: '添加成功', btn: ['前往购物车', '继续浏览']},
                          function () {
                              window.location.href = "shoopingCar.jsp";
                          },
                          function (index) {
                              layer.close(index);
                          }
                      );
                  } else {
                      layer.alert(addResult)
                  }
              }
          }
          function buyConfirm(productId) {
              if (userId == null || userId == undefined || userId == "") {
                  window.location.href="index.jsp";
              } else {
                  var productCounts = document.getElementById("productCounts");
                  var counts = parseInt(productCounts.innerHTML);
                  var buyProducts = new Array;
                  buyProducts.push(productId)
                  var buyProductsCounts = new Array;
                  buyProductsCounts.push(counts);
                  $.ajax({
                      async: false,
                      type: 'POST',
                      url: 'getOrderInfo',
                      data:{"productIds":buyProducts.toString(),"counts":buyProductsCounts.toString()},
                      dataType: 'json',
                      success: function (result) {
                          if (result.result!=null) {
                              window.location.href = "buyPage.jsp";
                          }else {
                              layer.alert("发生异常",{icon:2});
                          }
                      },
                  });
              }
          }

          function subCounts() {
              var productCounts = document.getElementById("productCounts");
              var counts = parseInt(productCounts.innerHTML);
              if(counts>=2)
                  counts--;
              productCounts.innerHTML = counts;
          }

          function addCounts() {
              var productCounts = document.getElementById("productCounts");
              var counts = parseInt(productCounts.innerHTML);
              if(counts<"${productDetail.pnum}")
                  counts++;
              productCounts.innerHTML = counts;
          }

      </script>
  </head>
  <body>
    <!--导航栏部分-->
    <jsp:include page="header.jsp"/>

    <!-- 中间内容 -->
    <div class="container-fluid">
        <div class="row">
            <div class="col-sm-1 col-md-1"></div>
            <div class="col-sm-10 col-md-10">
                <h1>${productDetail.name}</h1>
                <hr/>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-1 col-md-1"></div>
            <div class="col-sm-5 col-md-5">
                <img class="detail-img" src="${productDetail.imgurl}" width="756" height="503">
            </div>
            <div class="col-sm-5 col-md-5 detail-x">
                <table class="table table-striped">
                    <tr>
                        <th>商品名称</th>
                        <td>${productDetail.name}</td>
                    </tr>
                    <tr>
                        <th>商品价格</th>
                        <td>${productDetail.price}</td>
                    </tr>
                    <tr>
                        <th>商品描述</th>
                        <td>${productDetail.description}</td>
                    </tr>
                    <tr>
                        <th>商品类别</th>
                        <td>${productDetail.type}</td>
                    </tr>
                    <tr>
                        <th>商品库存</th>
                        <td>${productDetail.pnum}</td>
                    </tr>
                    <tr>
                        <th>购买数量</th>
                        <td>
                            <div class="btn-group" role="group">
                                <button type="button" class="btn btn-default" onclick="subCounts()">-</button>
                                <button id="productCounts" type="button" class="btn btn-default">1</button>
                                <button type="button" class="btn btn-default" onclick="addCounts()">+</button>
                            </div>
                        </td>
                    </tr>
                </table>
                <div class="row">
                    <div class="col-sm-1 col-md-1 col-lg-1"></div>
                    <button class="btn btn-danger btn-lg col-sm-4 col-md-4 col-lg-4" onclick="addToShoppingCar(${productDetail.id})">添加购物车</button>
                    <div class="col-sm-2 col-md-2 col-lg-2"></div>
                    <button  class="btn btn-danger btn-lg col-sm-4 col-md-4 col-lg-4" onclick="buyConfirm(${productDetail.id})">购买</button>

                </div>
            </div>
        </div>
    </div>
  </body>
</html>