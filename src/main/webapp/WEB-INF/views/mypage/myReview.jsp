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
    <div class="row seller_menu">
		<ul>	
			<li><a href="${contextPath}/mypage/myDetailInfo.do">내 정보</a></li>
			<li><a href="${contextPath}/mypage/myPetInfo.do">나의 반려동물</a></li>
			<li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문/배송 조회</a></li>
			<li><a href="${contextPath}/reservation/myReservations.do">예약확인</a></li>				
			<li><a href="${contextPath}/mypage/myReview.do">나의 리뷰</a></li>
			<li><a href="${contextPath}/mypage/likeGoods.do">나의 관심상품</a></li>				
			<li><a href="${contextPath}/mypage/deleteForm.do">회원탈퇴</a></li>
		</ul>
	</div>
	<form  method="post">	
		<table class="table">
			<tr>	
				<td>상품이미지</td>
				<td>구매상품</td>
				<td>별점</td>
				<td>작성일</td>
			</tr>

			<c:forEach var="item" items="${goodsReviewVO}">
			<tr>
				<td><img src="${contextPath}/review/image.do?file_name=${item.file_name}&review_id=${item.review_id}" style="width:100px;"/></td>
				<td><a href="${contextPath}/mypage/myReviewDetail.do?review_id=${item.review_id}&goods_name=${item.goods_name}">${item.goods_name}</a></td>
				<td>${item.rating}</td>
				<td>${item.created_at}</td>			
			</tr>
			</c:forEach>
		</table>
	
	</form>	
</div>
</body>
</html>