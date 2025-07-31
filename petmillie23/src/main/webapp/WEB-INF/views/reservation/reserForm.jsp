<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>예약 확인 페이지</title>
</head>
<body>
<table>
	<tr>
		<td>
			<th>예약 번호</th>
			<th>회원 이름</th>
			<th>예약일</th>
			<th>종료일</th>
			<th>예약 현황</th>
			<th>예약등록시간</th>
	</tr>
<c:choose>
<c:when test="${not empty reservation}">
	<c:forEach var="vation" items="reservation">	
	<tr>
		<td>
			<th>${vation.reservation_id}</th>
			<th>${vation.member_id}</th>
			<th>${vation.reservation_date}</th>
			<th>${vation.end_date}</th>
			<th>${vation.status}</th>
			<th>${vation.reg_date}</th>
</tr>
</c:forEach>
</c:when>
  <c:otherwise>
    <tr>
      <td colspan="5">예약 내역 없음</td>
    </tr>
  </c:otherwise>
</c:choose>
</table>
	 

</body>
</html>