<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>펫밀리</title>
</head>
<body>

<form action="${contextPath}/member/deleteMember.do" method="post"> 
<div class="container text-center mt-3 mb-3">
  	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold h2h2">회원 탈퇴</h2>
			<p class="h2p"></p>
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
	<h2>아이디를 입력해주세요</h2>
<input type="text" id="member_id" name="member_id">
<input type="submit" value="탈퇴하기">
</div>

</form>
</body>
</html>