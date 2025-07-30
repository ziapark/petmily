<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>내 업체 정보</title>
</head>
<body>
<c:if test="${not empty message}">
  <script>alert("${message}");</script>
</c:if>
<p>Flash 메시지: ${message}</p>
<p>requestScope.message: ${requestScope.message}</p>
<p>sessionScope.message: ${sessionScope.message}</p>
<p>flash.message: ${flash.message}</p>
<h2>등록된 업체</h2>
<hr>

<c:if test="${not empty pensionList}">
  <p><strong>업체명:</strong> ${pensionList.business_name}</p>
  <p><strong>업체유형:</strong> ${pensionList.business_type}</p>
  <p><strong>대표자명:</strong> ${pensionList.owner_name}</p>
  <p><strong>우편번호:</strong> ${pensionList.zipcode}</p>
  <p><strong>도로명 주소:</strong> ${pensionList.roadAddress}</p>
  <p><strong>지번 주소:</strong> ${pensionList.jibunAddress}</p>
  <p><strong>나머지 주소:</strong> ${pensionList.namujiAddress}</p>
  <p><strong>승인상태:</strong> ${pensionList.approval_status}</p>
  <br>
</c:if>

<c:if test="${empty pensionList}">
  <p>등록된 업체 정보가 없습니다.</p>
  <br>
</c:if>

<c:if test="${not empty pensionInfo}">
<form action="${contextPath}/business/addroomForm.do?p_num=${pensionInfo.p_num}" method="post">
<p><strong>펜션 등록번호 : </strong>${pensionInfo.business_id}</p>
${pensionInfo.p_num}
<input type="submit" value="객실추가">
</form>
</c:if>
<c:if test="${empty pensionInfo}">
  <p>등록된 펜션 정보가 없습니다.</p>
<a href="${contextPath}/business/addpensionForm.do"><button type="button">펜션 등록</button></a>
  <br>
</c:if>

<c:choose>
  <c:when test="${not empty roomInfo}">
    <c:forEach var="room" items="${roomInfo}">
      <div>
        <input type="hidden" id="room_id" name="room_id" value="${room.room_id}"/>
      	객실 번호: ${room.room_id} <br>
        객실명: ${room.room_name} <br>
        가격: ${room.price} <br>
        객실타입: ${room.room_type} <br>
        침대타입: ${room.bed_type} <br>
        최대인원: ${room.max_capacity} <br>
        면적: ${room.room_size} <br>
        설명: ${room.room_description} <br>
        편의시설: ${room.amenities} <br>
        <a href="${contextPath}/business/roomdetailInfo.do?room_id=${room.room_id}"><button type="button">수정</button></a>
        <hr>
      </div>
    </c:forEach>

  </c:when>
  <c:otherwise>
    객실 정보가 없습니다.
  </c:otherwise>
</c:choose>

</body>
</html>