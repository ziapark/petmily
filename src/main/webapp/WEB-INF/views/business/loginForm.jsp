<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script type="text/javascript"
	src="${contextPath}/resources/js/loginCheck.js"></script>
</head>
<body>
	<div class="container text-center mt-3 mb-3">
		<h3>사업자 회원 로그인</h3>
		<div id="detail_table">
			<form action="${contextPath}/business/busilogin.do" method="post"
				onsubmit="return Checklogin();">
				<table>
					<tbody>
						<tr class="dot_line">
							<td class="fixed_join">사업자 아이디</td>
							<td><input name="seller_id" type="text" size="20" required></td>
						</tr>
						<tr class="solid_line">
							<td class="fixed_join">사업자 비밀번호</td>
							<td><input name="seller_pw" type="password" size="20"
								required></td>
						</tr>
					</tbody>
				</table>
				<br>
				<br> <input type="submit" value="로그인"> <input
					type="button" value="다시쓰기">
			</form>
			<br>
			<br>
			<br> <a href="${contextPath}/member/findIdForm.do">아이디 찾기</a>| <a
				href="${contextPath}/member/findPwForm.do">비밀번호 찾기</a> | <a
				href="${contextPath}/business/businessForm.do">사업자 회원가입</a> | <a
				href="#">고객 센터</a>
		</div>
	</div>
</body>
</html>