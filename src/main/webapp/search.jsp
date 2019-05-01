<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="zh-CN">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title> 搜索结果</title>
	  <link href="css/bootstrap.min.css" rel="stylesheet">
	  <link href="css/style.css" rel="stylesheet">

	  <script src="js/jquery.min.js" type="text/javascript"></script>
	  <script src="js/bootstrap.min.js" type="text/javascript"></script>
	  <script src="js/layer.js" type="text/javascript"></script>
  </head>
  <body>
  <jsp:include page="header.jsp"/>
	<div class="container">
		<div class="row">
			<div id = "searchResultArea">
            </div>
		</div>

	</div>

  <script type="text/javascript">

	  searchInit();

	  function searchInit() {
		  var searchKeyWord = "${searchKeyWord}";
		  if(searchKeyWord != "" && searchKeyWord != undefined && searchKeyWord != null){
			  updateList(searchKeyWord);
		  }
	  }

	  function search(searchKeyWord) {
		  var search = {};
		  search.searchKeyWord = searchKeyWord;
		  var searchResult = "";
		  $.ajax({
			  async : false,
			  type : 'POST',
			  url : 'searchProduct',
			  data : search,
			  dataType : 'json',
			  success : function(result) {
				  searchResult = result.result;
			  },
			  error : function() {
				  layer.alert('查询失败了');
			  }
		  });
		  searchResult = eval("("+searchResult+")");
		  return searchResult;
	  }

	  function updateList(searchKeyWord) {
		  var searchResultArea = document.getElementById("searchResultArea");
		  var searchResult = search(searchKeyWord);
		  var html = "";
		  searchResultArea.innerHTML = "";
		  for(var i=0;i<searchResult.length;i++){
			  var imgURL = searchResult[i].imgurl;
			  html+= '<div class="col-sm-3 col-md-3 search-padding">'+
					  '<div class="boxes pointer" onclick="productDetail('+searchResult[i].id+')">'+
					  '<div class="big bigimg">'+
					  '<img src="'+imgURL+'" width="280" height="160"/>'+
					  '</div>'+
					  '<p class="product-name">'+searchResult[i].name+'</p>'+
					  '<p class="product-price">¥'+searchResult[i].price+'</p>'+
					  '</div>'+
					  '</div>'+
                      '<div class="col-sm-1 col-md-1"></div>';
		  }
		  searchResultArea.innerHTML += html;
	  }
      function productDetail(id) {
          var product = {};
          var jumpResult = '';
          product.id = id;
          $.ajax({
              async : false, //设置同步
              type : 'POST',
              url : 'productDe',
              data : product,
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
              layer.alert("进入失败")
          }
      }
  </script>
  </body>
</html>