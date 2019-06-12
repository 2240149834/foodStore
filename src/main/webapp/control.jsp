<%@ page contentType="text/html;charset=UTF-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>后台管理</title>
      <link href="css/bootstrap.min.css" rel="stylesheet">
      <link href="css/style.css" rel="stylesheet">

      <script src="js/jquery.min.js" type="text/javascript"></script>
      <script src="js/ajaxfileupload.js" type="text/javascript"></script>
      <script src="js/bootstrap.min.js" type="text/javascript"></script>
      <script src="js/layer.js" type="text/javascript"></script>
  </head>
  <body>
    <!--导航栏部分-->
    <jsp:include page="glhead.jsp"/>

    <!-- 中间内容 -->
    <div class="container-fluid">
        <div class="row">
            <!-- 控制栏 -->
            <div class="col-sm-3 col-md-2 sidebar sidebar-1">
                <ul class="nav nav-sidebar">
                    <li class="list-group-item-diy"><a href="#section1">查看所有用户<span class="sr-only">(current)</span></a></li>
                    <li class="list-group-item-diy"><a href="#section2">查看所有商品</a></li>
                    <li class="list-group-item-diy"><a href="#section3">添加商品</a></li>
                </ul>
            </div>
            <!-- 控制内容 -->
            <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
                <div class="col-md-12" id="allUser">
                    <h1><a name="section1">用户信息</a></h1>
                    <hr/>
                    <table class="table table-hover center">
                        <tr>
                            <td><label><input class="check-all check" type="checkbox" onclick="checkAll1()" id="checkAll"/> 全选</label></td>
                            <td>用户名</td>
                            <td>昵称</td>
                            <td>邮箱</td>
                            <td>是否删除</td>
                        </tr>
                        <c:forEach items="${user}" var="users">
                            <tr>
                                <td><input class="check-one check" type="checkbox" name="hotelName" value="${users.id}" onClick="single1()"/></td>
                                <td>${users.username}</td>
                                <td>${users.userDetail.nicheng}</td>
                                <td>${users.userDetail.email}</td>
                                <td><button type="button" class="btn btn-danger" onclick="deleteUser('${users.id }')">删除</button></td>
                            </tr>
                        </c:forEach>
                    </table>
                    <button type="button" class="btn btn-danger col-offset-1" onclick="pldel()" >批量删除</button>
                </div>

                <div class="col-md-12">
                    <hr/>
                    <h1><a name="section2">商品信息</a></h1>
                    <hr/>
                    <div class="col-lg-12 col-md-12 col-sm-12" id="productArea"></div>
                    <br/>
                </div>

                <div class="col-md-12">
                    <hr/>
                    <h1><a name="section3">添加商品</a></h1>
                    <hr/>
                    <div class="col-sm-offset-2 col-md-offest-2">
                        <!-- 表单输入 -->
                        <div  class="form-horizontal">
                            <div class="form-group">
                                <label for="productName" class="col-sm-2 col-md-2 control-label">商品名称</label>
                                <div class="col-sm-6 col-md-6">
                                    <input type="text" class="form-control" id="productName" placeholder="可比克" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="productDescribe" class="col-sm-2 col-md-2 control-label">商品描述</label>
                                <div class="col-sm-6 col-md-6">
                                    <textarea type="text" class="form-control" id="productDescribe" placeholder="xxxxxxxxxxxxxxx"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="productPrice" class="col-sm-2 col-md-2 control-label">商品价格</label>
                                <div class="col-sm-6 col-md-6">
                                    <input type="text" class="form-control" id="productPrice" placeholder="3" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="productCount" class="col-sm-2 col-md-2 control-label">商品数量</label>
                                <div class="col-sm-6 col-md-6">
                                    <input type="text" class="form-control" id="productCount" placeholder="100" />
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="productType" class="col-sm-2 col-md-2 control-label">商品类别</label>
                                <div class="col-sm-6 col-md-6">
                                    <select name="productType" class="form-control" id="productType">
                                        <option value="1">饮品</option>
                                        <option value="2">饼干</option>
                                        <option value="3">面包</option>
                                        <option value="4">糖果/巧克力</option>
                                        <option value="5">火腿肠/方便面</option>
                                        <option value="6">水果</option>
                                        <option value="7">干果</option>
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="productImgUpload" class="col-sm-2 col-md-2 control-label" accept="image/jpg">商品图片</label>
                                <div class="col-sm-2 col-md-2">
                                    <input name="productImgUpload" type="file"  id="productImgUpload"/>
                                    <b class="help-block">请上传图片</b>
                                    <button class="btn btn-primary col-sm-6 col-md-6" onclick="fileUpload()">上传图片</button>
                                </div>
                                <div id="autore">
                                <c:if test="${path!=null}">
                                <img src="${path}" class="col-md-1">
                                </c:if>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-sm-offset-2 col-sm-6">
                                    <button class="btn btn-lg btn-primary btn-block" type="submit" onclick="addProduct()">添加商品</button>
                                </div>
                            </div>
                        </div>
                        <br/>
                    </div>
                </div>
            </div>
        </div>
    </div>
  <script type="text/javascript">
      getAllUsers();
      listAllProduct();
      function fileUpload() {
          $.ajaxFileUpload({
              url: 'upload',
              fileElementId: 'productImgUpload',
              type: 'POST',
              dataType: 'text',
              async: false,
              success: function (result) {
                  result = result.replace(/<pre.*?>/g, '');  //ajaxFileUpload会对服务器响应回来的text内容加上<pre style="....">text</pre>前后缀
                  result = result.replace(/<PRE.*?>/g, '');
                  result = result.replace("<PRE>", '');
                  result = result.replace("</PRE>", '');
                  result = result.replace("<pre>", '');
                  result = result.replace("</pre>", '');
                  result = JSON.parse(result);
                  if(result.result== "success") {
                      $("#autore").load(location.href + " #autore");//要刷新的div
                  }
                  else {
                      layer.msg("图片上传失败", {icon: 0, time: 1000});
                  }
              }
          });
      }
      function listAllProduct() {
          var productArea = document.getElementById("productArea");
          var allProduct = getAllProducts();
          var html="";
          productArea.innerHTML = '';
          for(var i=0;i<allProduct.length;i++){
              var imgURL = allProduct[i].imgurl;
              html+='<div class="col-sm-4 col-md-4 pd-5">'+
                      '<div class="boxes">'+
                      '<div class="big bigimg">'+
                      '<img src="'+imgURL+'" width="280" height="160">'+
                      '</div>'+
                      '<p class="font-styles center">'+allProduct[i].name+'</p>'+
                      '<p class="pull-right">价格：'+allProduct[i].price+'</p>'+
                      '<p class="pull-left">库存：'+allProduct[i].pnum+'</p>'+
                      '<div class = "row">'+
                      '<button class="btn btn-primary delete-button" type="submit" onclick="deleteProduct('+allProduct[i].id+')">删除商品</button>'+
                      '</div>'+
                      '</div>'+
                      '</div>';
          }
          productArea.innerHTML+=html;
      }
      //列出所有用户
      function getAllUsers() {
          var nothing = {};
          $.ajax({
              async : false, //设置同步
              type : 'POST',
              url : 'getAllUser',
              data : nothing,
              dataType : 'json',
              success : function(result) {
                  if (result.result!=null){
                      layer.alert("没有用户",{icon:0,time:1000});
                      $("#allUser").load(location.href + " #allUser");
                  }else {
                      $("#allUser").load(location.href + " #allUser");
                  }
              },
              error : function() {
                  layer.alert('服务器异常');
              }
          });
      }
      //列出所有商品

      function getAllProducts() {

          var allProducts = null;
          var nothing = {};
          $.ajax({
              async : false, //设置同步
              type : 'POST',
              url : 'getAllProducts',
              data : nothing,
              dataType : 'json',
              success : function(result) {
                  if (result!=null) {
                      allProducts = result.allProducts;
                  }
                  else{
                      layer.alert('查询所有商品错误');
                  }
              },
              error : function() {
                  layer.alert('系统异常');
              }
          });
          allProducts = eval("("+allProducts+")");
          return allProducts;
      }

      function deleteUser(id) {
          var ids=new Array();
          ids.push(id);
          $.ajax({
              async : false,
              type : 'POST',
              url : 'deleteUser',
              data : {"ids":ids.toString()},
              dataType : 'json',
              success : function(result) {
                  layer.alert(result.result)
              },
              error : function() {
                  layer.alert('系统异常');
              }
          });
          getAllUsers();
      }
      /*复选框全选或全不选效果*/
      function selectAll1(){
          var checkInputs = document.getElementsByName("hotelName");
          // var checkAllInputs = document.getElementById('checkAll');
          for(var i=0;i< checkInputs.length;i++){
              checkInputs[i].checked=true;
          }
      }
      function pldel() {
          var ids=new Array();
          var checkInputs = document.getElementsByName("hotelName");
          for(var i=0;i< checkInputs.length;i++) {
              if (checkInputs[i].checked) {
                  ids.push(checkInputs[i].value);
              }
          }
          var delresult="";
          $.ajax({
              async : false,
              type : 'POST',
              url : 'deleteUser',
              data : {"ids":ids.toString()},
              dataType : 'json',
              success : function(result) {
                     delresult=result;
              },
              error : function() {
                  layer.alert('删除失败');
              }
          });
          layer.alert(delresult.result);
          getAllUsers();
      }
      /*复选框全选或全不选效果*/
      function checkAll1() {
          var checkInputs = document.getElementsByName("hotelName");
          var checkAllInputs = document.getElementById('checkAll');
          for (var i = 0; i < checkInputs.length; i++) {
              if (checkAllInputs.checked) {
                  checkInputs[i].checked = true;
              }else
                  checkInputs[i].checked = false;
          }
      }

      /*根据单个复选框的选择情况确定全选复选框是否被选中*/
      function single1(){
          var checkInputs = document.getElementsByName("hotelName");
          var checkAllInputs = document.getElementById('checkAll');
          var count=0;
          for(var i=0;i< checkInputs.length;i++){
              if(checkInputs[i].checked) {
                  count++;
              }
              if (count === checkInputs.length ) {//判断是否全选
                  checkAllInputs.checked = true;
                   selectAll1();
              } else {
                  checkAllInputs.checked=false;
              }
          }
      }
      function deleteProduct(id) {
          var product = {};
          product.id = id;
          var deleteResult = "";
          $.ajax({
              async : false,
              type : 'POST',
              url : 'deleteProduct',
              data : product,
              dataType : 'json',
              success : function(result) {
                  deleteResult = result;
              },
              error : function() {
                  layer.alert('服务器异常');
              }
          });
          layer.msg(deleteResult.result);
          listAllProduct();
      }
      function addProduct() {
          var loadings = layer.load(0);
          var product = {};
          product.name = document.getElementById("productName").value;
          product.description = document.getElementById("productDescribe").value;
          product.price = document.getElementById("productPrice").value;
          product.counts = document.getElementById("productCount").value;
          product.type = document.getElementById("productType").value;
          var imgUrl="${path}";
          product.imgurl=imgUrl;
          var addResult="";
          $.ajax({
              async : false,
              type : 'POST',
              url : 'addProduct1',
              data : product,
              dataType : 'json',
              success : function(result) {
                  addResult = result.result;
              },
              error : function() {
                  layer.alert('未知的错误');
              }
          });
          if(addResult == "success") {
              layer.msg('添加商品成功', {icon: 1, time: 1000});
              $("#autore").load(location.href + " #autore");//要刷新的div
              layer.close(loadings)
          }
          listAllProduct();
      }
  </script>
  </body>
</html>