<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html >
<html>
<head>
<meta   charset="utf-8">

</head>
<body>
<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold">나의 관심상품</h2>
		</div>
	</div>
	<form  method="post">	
		<table class="table">
			<tr>	
				<td>상품이미지</td>
				<td>관심상품</td>
				<td>가격</td>
			</tr>
			<c:choose>	
				<c:when test="${empty likeGoodsList}">
					<tr>
						<td colspan="3" class="fixed">
							<strong>주문한 상품이 없습니다.</strong>
						</td>
					</tr>
				</c:when>
				 <c:otherwise>
				 	<c:forEach var="item" items="${likeGoodsList}">
						<tr>
							<td><img src="${contextPath}/mypage/image.do?file_name=${item.file_name}&goods_num=${item.goods_num}" style="width:100px;"/></td>
							<td><a href="#">${item.goods_name}</a></td>
							<td>${item.goods_sales_price}</td>		
						</tr>
					</c:forEach>
				 </c:otherwise>
			</c:choose>
			
		</table>
	
	</form>	
</div>
</body>
</html>