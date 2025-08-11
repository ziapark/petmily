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
			<h2 class="fw-bold">나의 리뷰</h2>
		</div>
	</div>
	<form  method="post">	
		<table class="table">
			<tr>
				<td>내용</td>
				<td>별점</td>
			</tr>

			<c:forEach var="item" items="${goodsReviewVO}">
			<tr>
				<td>${item.content }</td>
				<td>${item.rating }</td>
			</tr>
			</c:forEach>
		</table>
	
	</form>	
</div>
</body>
</html>