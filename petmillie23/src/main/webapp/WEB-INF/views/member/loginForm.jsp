<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	 isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<c:if test='${not empty message }'>
<script type="text/javascript" src="${contextPath}/resources/js/loginCheck.js"></script>
<script>
window.onload=function()
{
  result();
}

function result(){
	alert("아이디나  비밀번호가 틀립니다. 다시 로그인해주세요");
	alert(message);
}
</script>
</c:if>
</head>
<body>
	<div class="login_wrap">
		
	<H3>회원 로그인 창</H3>
	<form action="${contextPath}/member/login.do" method="post" onsubmit="return Checklogin();">
	
	
		<input name="member_id" type="text" size="20" class="form-control login_input" placeholder="id" required/>
		<input name="member_pw" type="password" class="form-control login_input" placeholder="password" size="20" required/>
		<div class="login_btns">
			<INPUT	type="submit" value="로그인" class="btn btn-primary"> 
			<a href="${contextPath}/member/memberForm.do" class="btn btn-secondary">회원가입</a> 
		</div>
		
		<a href="https://kauth.kakao.com/oauth/authorize?response_type=code
		&client_id=69cca3f6669288cd3162c12fa845a93d
		&redirect_uri=http://localhost:8090/petmillie/member/kakaoLogin.do">
		    <img alt="카카오로그인" src="${contextPath}/resources/image/kakao_login_medium_narrow.png"/>
		</a>
				
				<Br><br>
				   <a href="#">아이디 찾기</a>  | 
				   <a href="#">비밀번호 찾기</a> |
				   <a href="#">고객 센터</a>
							   
			</form>	
	
	</div>
	
</body>
</html>