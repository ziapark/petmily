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
<link rel="stylesheet" href="css/common.css">
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
<title>내 업체 정보</title>
</head>
<body>
<c:if test="${not empty sessionScope.message}">
  <script>alert("${sessionScope.message}");</script>
  <c:remove var="message" scope="session" />
</c:if>

  <div class="container text-center mt-3 mb-3">
  	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold h2h2">사업자 정보 페이지</h2>
			<p class="h2p"></p>
		</div>
	</div>

	 <div class="row row-cols-1 row-cols-md-2 gx-4 gy-4">

<div class="col">
      <div class="pd">
<c:if test="${not empty pensionList}">
  <p class="card-text mb-0 bd"><strong>업체명:</strong> ${pensionList.business_name}</p>
  <p class="card-text mb-0 bd"><strong>업체유형:</strong> ${pensionList.business_type}</p>
  <p class="card-text mb-0 bd"><strong>대표자명:</strong> ${pensionList.owner_name}</p>
  <p class="card-text mb-0 bd"><strong>우편번호:</strong> ${pensionList.zipcode}</p>
  <p class="card-text mb-0 bd"><strong>도로명 주소:</strong> ${pensionList.roadAddress}</p>
  <p class="card-text mb-0 bd"><strong>지번 주소:</strong> ${pensionList.jibunAddress}</p>
  <p class="card-text mb-0 bd"><strong>나머지 주소:</strong> ${pensionList.namujiAddress}</p>
  <p class="card-text mb-0 bd"><strong>승인상태:</strong> ${pensionList.approval_status}</p>
  <br>
</c:if>

<c:if test="${empty pensionList}">
  <p>등록된 업체 정보가 없습니다.</p>
  <br>
</c:if>
 </div>
</div>
<c:choose>
  <c:when test="${not empty pensionInfo and pensionInfo.del_yn == 'N'}">
    <div class="card mb-4 shadow-sm">
      <div class="card-body">
        <input type="hidden" name="p_num" value="${pensionInfo.p_num}" />
        <h5 class="card-title text-success">업체 정보</h5>
        <p class="card-text mb-1"><strong>펜션 등록번호:</strong> ${pensionInfo.business_id}</p>
        <p class="card-text mb-1"><strong>업체 명:</strong> ${pensionInfo.p_name}</p>
        <p class="card-text mb-1">
          <strong>업체 전화번호:</strong> ${pensionInfo.tel1}-${pensionInfo.tel2}-${pensionInfo.tel3}
        </p>
        <p class="card-text mb-1"><strong>객실 수:</strong> ${pensionInfo.room_count}</p>
        <p class="card-text mb-1"><strong>시설 정보:</strong> ${pensionInfo.facilities}</p>
        <p class="card-text"><strong>설명:</strong> ${pensionInfo.description}</p>

        <div class="d-flex justify-content-end gap-2 mt-3">
          <a href="${contextPath}/business/pensiondetail.do?p_num=${pensionInfo.p_num}" class="btn btn-outline-primary btn-sm">
            업체수정
          </a>
          <button type="button" class="btn btn-outline-danger btn-sm" onclick="pensiondelete(${pensionInfo.p_num})">
            업체삭제
          </button>
          <a href="${contextPath}/business/addroomForm.do?p_num=${pensionInfo.p_num}" class="btn btn-outline-success btn-sm">
            객실추가
          </a>
        </div>
      </div>
    </div>
  </c:when>
  

  <c:when test="${pensionInfo.del_yn == 'Y'}">
    <div class="alert alert-warning">삭제된 펜션 정보입니다.</div>
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
    if (confirm("정말로 객실을 삭제 하시겠습니까?\n(삭제 후 복구가 불가능합니다.)")) {
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

</div>
<h3 class="mb-4" style="display: block; text-align:left;">등록된 객실 리스트</h3>

<c:choose>
  <c:when test="${not empty roomInfo and not empty pensionInfo and pensionInfo.del_yn == 'N'}">
    <div class="row row-cols-1 row-cols-md-2 gx-4 gy-4">
  <c:forEach var="room" items="${roomInfo}">
    <div class="col">
      <div class="card h-100 shadow-sm">
        <div class="row g-0">
          <!-- 이미지 영역 -->
          <div class="col-md-4 d-flex align-items-center justify-content-center bg-light">
            <img src="http://localhost:8090/petupload/room/${room.fileimage}" class="img-fluid rounded-start" alt="객실 이미지" style="max-height: 150px;">
          </div>

          <!-- 텍스트 정보 -->
          <div class="col-md-8">
            <div class="card-body">
              <h5 class="card-title left">${room.room_name}</h5>
              <p class="card-text mb-1 left"><strong>객실 번호:</strong> ${room.room_id}</p>
              <p class="card-text mb-1 left"><strong>가격:</strong> <fmt:formatNumber value="${room.price}" type="currency" currencySymbol="₩"/></p>
              <p class="card-text mb-1 left"><strong>타입:</strong> ${room.room_type} / ${room.bed_type}</p>
              <p class="card-text mb-1 left"><strong>인원:</strong> ${room.max_capacity}명 / ${room.room_size}㎡</p>
              <p class="card-text left"><strong>설명:</strong> ${room.room_description}</p>
              <p class="card-text left"><strong>편의시설:</strong> ${room.amenities}</p>
            </div>

            <div class="card-footer bg-white border-top-0 d-flex justify-content-end gap-2">
              <a href="${contextPath}/business/roomdetailInfo.do?room_id=${room.room_id}" class="btn btn-sm btn-outline-primary">
                수정
              </a>
              <button type="button" class="btn btn-sm btn-outline-danger" onclick="submitdelete(${room.room_id})">
                삭제
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </c:forEach>
</div>
  </c:when>

  <c:when test="${pensionInfo.del_yn == 'Y'}">
    <div class="alert alert-warning mt-3">삭제된 펜션 정보입니다.</div>
  </c:when>

  <c:otherwise>
    <div class="alert alert-secondary mt-3">객실 정보가 없습니다.</div>
  </c:otherwise>
</c:choose>

	</div>
</body>
</html>