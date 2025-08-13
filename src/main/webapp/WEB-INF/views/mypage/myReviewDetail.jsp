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
		<p></p>	
		<table class="table">
			<tr>
				<td colspan="2">구매상품 : ${review.goods_name}</td>
			</tr>
			<tr>
				<td>별점:&nbsp;${review.rating}</td>
				<td>작성일:&nbsp;${review.created_at}</td>	
			</tr>
			<tr>
				<td colspan="2">
				<div class="contents_box" style="text-align:left;">
	    			<c:if test="${not empty review.file_name}">
					  <div class="imgbox">
					    <img src="${contextPath}/mypage/image.do?file_name=${review.file_name}&review_id=${review.review_id}" />
					  </div>
					</c:if>
		  		</div>
		  		</td>
	  		</tr>
			<tr>
				<td colspan="2">${review.content}</td>						
			</tr>
		</table>
		<!-- 하단 버튼부 -->
		<div style="padding-top:10px;">
			<a href="${contextPath}/mypage/updateReviewForm.do?review_id=${review.review_id}" class="btn btn-sm btn-primary">수정</a>
	        <a href="${contextPath}/mypage/deleteReview.do?review_id=${review.review_id}" class="btn btn-sm btn-danger">삭제</a>
        </div>
	</form>	
</div>
</body>
</html>