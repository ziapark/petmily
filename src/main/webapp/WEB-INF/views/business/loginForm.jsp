<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />

<!DOCTYPE html >
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<script type="text/javascript" src="${contextPath}/resources/js/loginCheck.js"></script>
</head>
<body>
	<div class="login_wrap">
		<h3>사업자 회원 로그인</h3>
		<div id="detail_table">
			<form action="${contextPath}/business/busilogin.do" method="post" onsubmit="return Checklogin();">
				<input name="seller_id" type="text" size="20" class="form-control login_input" placeholder="아이디" required/>
				<input name="seller_pw" type="password" class="form-control login_input" placeholder="비밀번호" size="20" required/>
				<div class="login_btns">
					<input type="submit" value="로그인" class="btn btn-primary"> 
					<a href="${contextPath}/business/businessForm.do" class="btn btn-secondary">사업자 회원가입</a> 
				</div>
			</form>
			<br><br><br>
			<a href="#">아이디 찾기</a>  | 
		    <a href="#">비밀번호 찾기</a> | 
		    <a href="${contextPath}/business/businessForm.do">사업자 회원가입</a>    |
		    <a href="#">고객 센터</a>		   
		</div>	
	</div>
</body>
</html>