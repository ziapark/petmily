<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>사업자 탈퇴</title>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<form action="${contextPath}/business/deleteMember.do" method="post"> 
		<div class="container text-center mt-3 mb-3">
  			<div class="row row-cols-1 mb-3">
				<div class="col bg-light p-5 text-start">
					<h2 class="fw-bold h2h2">사업자 회원 탈퇴</h2>
					<p class="h2p"></p>
				</div>
			</div>
		   	<div class="row seller_menu">
				<ul>	
					<li><a href="${contextPath}/business/businessDetailInfo.do">내 정보</a></li>
					<li><a href="${contextPath}/business/addNewGoodsForm.do">상품등록</a></li>
					<li><a href="${contextPath}/business/businessGoodsMain.do">상품관리</a></li>
					<li><a href="${contextPath}/business/businessOrderMain.do">주문/배송관리</a></li>
					<li><a href="${contextPath}/business/addpensionForm.do">펜션등록</a></li>
					<li><a href="${contextPath}/business/mypension.do?business_id=${business_id}">펜션관리</a></li>
					<li><a href="${contextPath}/reservation/reservation_check.do">예약관리</a></li>
					<li><a href="${contextPath}/business/deleteForm.do">회원탈퇴</a></li>
				</ul>
			</div>
			<h2>아이디를 입력해주세요</h2>
			<input type="text" id="seller_id" name="seller_id">
			<input type="submit" value="탈퇴하기">
		</div>
	</form>
</body>
</html>
