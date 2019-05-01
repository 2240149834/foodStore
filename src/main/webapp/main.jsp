<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zh-CN">
  <head>
	  <meta charset="utf-8">
	  <meta http-equiv="X-UA-Compatible" content="IE=edge">
	  <meta name="viewport" content="width=device-width, initial-scale=1">
	  <title>首页</title>
	  <link href="css/bootstrap.min.css" rel="stylesheet">
	  <link href="css/style.css" rel="stylesheet">

	  <script src="js/jquery.min.js" type="text/javascript"></script>
	  <script src="js/bootstrap.min.js" type="text/javascript"></script>
	  <script src="js/layer.js" type="text/javascript"></script>
	  <style>
	  .jumbotron{
	  background:url('imgs/spbeijin.jpg'),no-repeat,100%;
		  height: 200px;
	  }
	  </style>
  </head>
  <body>
    <!--导航栏部分-->
	<jsp:include page="header.jsp"/>
	<!-- 中间内容 -->
	<div class="container-fluid">
		<div class="row" >
			<!-- 控制栏 -->
			<div class="col-sm-3 col-md-2 sidebar sidebar-1">
				<ul class="nav nav-sidebar">
					<li class="list-group-item-diy"><a href="#productArea1">饮品 <span class="sr-only">(current)</span></a></li>
					<li class="list-group-item-diy"><a href="#productArea2">饼干</a></li>
					<li class="list-group-item-diy"><a href="#productArea3">面包</a></li>
					<li class="list-group-item-diy"><a href="#productArea4">糖果/巧克力</a></li>
					<li class="list-group-item-diy"><a href="#productArea5">火腿肠/方便面</a></li>
					<li class="list-group-item-diy"><a href="#productArea6">水果</a></li>
					<li class="list-group-item-diy"><a href="#productArea7">干果</a></li>
				</ul>
			</div>
			<!-- 控制内容 -->
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<div class="jumbotron">
				</div>

				<div name="productArea1" class="row pd-10" id="productArea1">
				</div>

				<div name="productArea2" class="row" id="productArea2">
				</div>

				<div name="productArea3" class="row" id="productArea3">
				</div>

                <div name="productArea4" class="row" id="productArea4">
				</div>

				<div name="productArea5" class="row" id="productArea5">
				</div>

				<div name="productArea6" class="row" id="productArea6">
				</div>

				<div name="productArea7" class="row" id="productArea7">
				</div>


			</div>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2">
			</div>
		</div>
	</div>

  <script type="text/javascript">

	  var loading = layer.load(0);

      var productType = new Array;
      productType[1] = "饮品";
      productType[2] = "饼干";
      productType[3] = "面包";
      productType[4] = "糖果/巧克力";
      productType[5] = "火腿肠/方便面";
      productType[6] = "水果";
      productType[7] = "干果";


	  listProducts();

	  function listProducts() {
		  var allProduct = getAllProducts();
          var mark = new Array;
          mark[1] = 0;
          mark[2] = 0;
          mark[3] = 0;
          mark[4] = 0;
          mark[5] = 0;
          mark[6] = 0;
          mark[7] = 0;
          for(var i=0;i<allProduct.length;i++){
			  var html = "";
			  var imgURL = allProduct[i].imgurl;
			  html += '<div class="col-sm-4 col-md-4" >'+
					  '<div class="boxes pointer" onclick="productDetail1('+allProduct[i].id+')">'+
					  '<div class="big bigimg">'+
					  '<img src="'+imgURL+'" width="280" height="160">'+
					  '</div>'+
					  '<p class="product-name">'+allProduct[i].name+'</p>'+
					  '<p class="product-price">¥'+allProduct[i].price+'</p>'+
					  '</div>'+
					  '</div>';
              var id = "productArea"+allProduct[i].type;
              var productArea = document.getElementById(id);
              if(mark[allProduct[i].type] == 0){
                  html ='<hr/><h1>'+productType[allProduct[i].type]+'</h1><hr/>'+html;
                  mark[allProduct[i].type] = 1;
              }
              productArea.innerHTML += html;
		  }
		  layer.close(loading);
	  }
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
						  layer.alert('查询出错');
					  }
				  },
				  error : function() {
					  layer.alert('查询错误');
				  }
			  });
			  //划重点划重点，这里的eval方法不同于prase方法，外面加括号
			  allProducts = eval("("+allProducts+")");
			  return allProducts;
	  }
	  function productDetail1(id) {
		  var jumpResult = '';
		  var  nicheng="${currentUser.userDetail.nicheng}";
		  $.ajax({
			  async : false, //设置同步
			  type : 'POST',
			  url : 'productDe',
			  data : {"id":id,"nicheng":nicheng},
			  dataType : 'json',
			  success : function(result) {
				  jumpResult = result.result;
			  },
              error : function() {
                  layer.alert('查询错误');
              }
		  });

		  if(jumpResult == "success"){
			  window.location.href = "product_detail.jsp";
		  }
		  else {
			  layer.alert("没有此商品")
		  }
	  }

  </script>


  </body>
</html>