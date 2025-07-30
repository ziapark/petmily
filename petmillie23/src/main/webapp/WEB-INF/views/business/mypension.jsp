<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%
  String msg = (String) session.getAttribute("message");
  System.out.println("세션 message 값 = " + msg);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>내 업체 정보</title>
</head>
<body>
<c:if test="${not empty sessionScope.message}">
  <script>alert("${sessionScope.message}");</script>
  <c:remove var="message" scope="session" />
</c:if>
<h2>등록된 업체</h2>
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
<hr>
  <c:out value="${sessionScope.message}" />
<h2>등록된 펜션</h2>
<script>
function pensiondelete(p_num) {
    console.log("탈퇴요청 p_num:", p_num);
    if (confirm("정말로 업체를 삭제 하시겠습니까?\n(탈퇴 후 복구가 불가능합니다.)")) {
        $.ajax({
            type: "POST",
            url: "${contextPath}/business/removepension.do",
            data: {p_num: p_num},
            dataType: "text",
            beforeSend: function(xhr) {
                console.log("AJAX beforeSend 실행");
            },
            success: function(data) {
                console.log("AJAX success, 응답:", data);
                if ($.trim(data) === "true") {
                    alert("업체 삭제가 완료되었습니다.");
                    window.location.href = "${contextPath}/business/mypension.do";
                } else {
                    alert("업체 삭제에 실패했습니다. 다시 시도해 주세요.");
                }
            },
            error: function(xhr, status, error) {
                console.error("AJAX error 발생!", xhr, status, error);
                alert(
                    "서버와 통신 중 오류가 발생했습니다.\n" +
                    "status: " + status + "\n" +
                    "HTTP 상태코드: " + xhr.status + "\n" +
                    "오류 메시지: " + error + "\n" +
                    "응답 내용: " + xhr.responseText
                );
    		    console.log("에러가 발생했습니다.\n" +
  			          "상태: " + status + "\n" +
  			          "에러: " + error + "\n" +
  			          "응답내용: " + xhr.responseText);
            },
            complete: function(xhr, status) {
                console.log("AJAX complete - status:", status);
            }
        });
    } else {
        console.log("업체 삭제 취소");
    }
}
</script>
<c:choose>
<c:when test="${not empty pensionInfo and pensionInfo.del_yn == 'N'}">
<input type="hidden" name="p_num" value="${pensionInfo.p_num}"/>
<p><strong>펜션 등록번호 : </strong>${pensionInfo.business_id}</p>
<p><strong>업체 명 : </strong>${pensionInfo.p_name}</p>
<p><strong>업체 전화번호 : </strong>${pensionInfo.tel1}-<span>${pensionInfo.tel2}</span>-<span>${pensionInfo.tel3}</span></p>
<p><strong>객실 수 : </strong>${pensionInfo.room_count}</p>
<p><strong>시설 정보 : </strong>${pensionInfo.facilities}</p>
<p><strong>설명 : </strong>${pensionInfo.description}</p>
<a href="${contextPath}/business/pensiondetail.do?p_num=${pensionInfo.p_num}"><button type="button">업체수정</button></a>
<button type="button" onclick="pensiondelete(${pensionInfo.p_num})">업체삭제</button>
<a href="${contextPath}/business/addroomForm.do?p_num=${pensionInfo.p_num}"><button type="button">객실추가</button></a>
<hr>
</c:when>
  <c:when test="${pensionInfo.del_yn == 'Y'}">
  	<p>삭제된 펜션 정보입니다.</p>
  	<hr>
  </c:when>
</c:choose>

<c:if test="${empty pensionInfo}">
  <p>등록된 펜션 정보가 없습니다.</p>
<a href="${contextPath}/business/addpensionForm.do"><button type="button">펜션 등록</button></a>
  <br>
</c:if>
<script>
function submitdelete(room_id) {
    console.log("탈퇴요청 room_id:", room_id);
    if (confirm("정말로 객실을 삭제 하시겠습니까?\n(탈퇴 후 복구가 불가능합니다.)")) {
        $.ajax({
            type: "POST",
            url: "${contextPath}/business/removeroom.do",
            data: {room_id: room_id},
            dataType: "text",
            beforeSend: function(xhr) {
                console.log("AJAX beforeSend 실행");
            },
            success: function(data) {
                console.log("AJAX success, 응답:", data);
                if ($.trim(data) === "true") {
                    alert("객실 삭제가 완료되었습니다.");
                    window.location.href = "${contextPath}/business/mypension.do";
                } else {
                    alert("객실 삭제에 실패했습니다. 다시 시도해 주세요.");
                }
            },
            error: function(xhr, status, error) {
                console.error("AJAX error 발생!", xhr, status, error);
                alert(
                    "서버와 통신 중 오류가 발생했습니다.\n" +
                    "status: " + status + "\n" +
                    "HTTP 상태코드: " + xhr.status + "\n" +
                    "오류 메시지: " + error + "\n" +
                    "응답 내용: " + xhr.responseText
                );
    		    console.log("에러가 발생했습니다.\n" +
  			          "상태: " + status + "\n" +
  			          "에러: " + error + "\n" +
  			          "응답내용: " + xhr.responseText);
            },
            complete: function(xhr, status) {
                console.log("AJAX complete - status:", status);
            }
        });
    } else {
        console.log("객실 삭제 취소");
    }
}
</script>
<h2>등록된 객실리스트</h2>
<c:choose>
  <c:when test="${not empty roomInfo and not empty pensionInfo and pensionInfo.del_yn == 'N'}">
    <c:forEach var="room" items="${roomInfo}">
      <div>
        <input type="hidden" name="room_id" value="${room.room_id}"/>
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
        <button type="button" onclick="submitdelete(${room.room_id})">삭제</button>
        <hr>
      </div>
    </c:forEach>
  </c:when>
  <c:when test="${pensionInfo.del_yn == 'Y'}">
  	<p>삭제된 펜션 정보입니다.</p>
  	<hr>
  </c:when>
  <c:otherwise>
    객실 정보가 없습니다.
  </c:otherwise>
</c:choose>
</body>
</html>