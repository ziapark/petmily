<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<style>

form.add_new_goods_form {
	background: white;
	padding: 20px;
	border-radius: 10px;
	box-shadow: 0 0 10px #ccc;
	width: 600px;
	margin: 0 auto;
}



table tr td {padding:10px;}



</style>
</head>
<body>
<div class="container mt-3 mb-3">
	
	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold h2h2">상품 등록</h2>
			<p class="h2p"></p>
		</div>
	</div>	


	<form class="add_new_goods_form" action="${contextPath}/admin/goods/addNewGoods.do" method="post"enctype="multipart/form-data">
		<table>
			<tr>
				<td><label class="form-label">상품명</label></td>
				<td><input type="text" class="form-control" name="goods_name" required></td>
			</tr>
			<tr>
				<td><label class="form-label">판매자</td>
				<td><input type="text" class="form-control" name="goods_maker" required></td>
			</tr>
			<tr>
				<td><label class="form-label">카테고리</td>
				<td><select name="goods_category" class="form-control">
						<option value="bestseller">베스트셀러</option>
						<option value="steadyseller">스테디셀러</option>
						<option value="newbook" selected>신간</option>
						<option value="on_sale">판매중</option>
						<option value="buy_out">품절</option>
						<option value="out_of_print">절판</option>
				</select></td>
			</tr>
			<tr>
				<td><label class="form-label">판매 가격</td>
				<td><input type="text" class="form-control" name="goods_sales_price" required></td>
			</tr>
			<tr>
				<td><label class="form-label">포인트</td>
				<td><input type="text" class="form-control" name="goods_point" required></td>
			</tr>
			<tr>
				<td><label class="form-label">재고</td>
				<td><input type="text" class="form-control" name="goods_stock" required></td>
			</tr>
			<tr>
				<td><label class="form-label">배송비</td>
				<td><input type="text" class="form-control" name="goods_delivery_price" readonly value="무료배송"></td>
			</tr>
			<tr>
				<td><label class="form-label">대표이미지</td>
				<td><input type="file" class="form-control" name="goods_fileName" required></td>
			</tr>
				<td><label class="form-label">제품상세이미지</label></td> 
		        <td><input type="file" class="form-control" name="goods_fileName" required></td>
			</tr>  
           <tr>
               <td colspan="2" style="text-align:center;">
                   <button type="submit" class="btn btn-primary">상품 등록</button>
               </td>
           </tr>
       </table>
   </form>
</div>
</body>
</html>