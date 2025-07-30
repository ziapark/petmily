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
	<H3>회원 로그인 창</H3>
	<DIV id="detail_table">
	<form action="${contextPath}/business/busilogin.do" method="post" onsubmit="return Checklogin();">
		<TABLE>
			<TBODY>
				<TR class="dot_line">
					<TD class="fixed_join">사업자 번호</TD>
					<TD><input name="business_number" type="text" size="20" required/></TD>
				</TR>
				<TR class="solid_line">
					<TD class="fixed_join">사업자 비밀번호</TD>
					<TD><input name="seller_pw" type="password" size="20" required/></TD>
				</TR>
			</TBODY>
		</TABLE>
		<br><br>
		<INPUT	type="submit" value="로그인"> 
		<INPUT type="button" value="초기화">
		<br>
		
		<Br><br>
		   <a href="#">아이디 찾기</a>  | 
		   <a href="#">비밀번호 찾기</a> | 
		   <a href="${contextPath}/business/businessForm.do">사업자 회원가입</a>    |
		   <a href="#">고객 센터</a>		   
	</form>	
	</DIV>	
</body>
</html>