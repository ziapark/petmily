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
<link rel="stylesheet" href="css/common.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
/* 전체적인 컨테이너 및 폰트 스타일 */
body {
    font-family: 'Noto Sans KR', sans-serif;
    background-color: #f8f9fa;
}

/* 펜션 관리 메뉴 스타일 */
.seller_menu ul {
    list-style-type: none;
    margin: 0;
    padding: 0;
    display: flex;
    justify-content: space-between;
    background-color: #f8f9fa;
    border-bottom: 1px solid #dee2e6;
    border-radius: 0.5rem;
    overflow: hidden;
}
.seller_menu li {
    flex-grow: 1;
    text-align: center;
}
.seller_menu li a {
    display: block;
    padding: 1rem;
    text-decoration: none;
    color: #495057;
    font-weight: bold;
    transition: background-color 0.3s ease, color 0.3s ease;
}
.seller_menu li a:hover {
    background-color: #e9ecef;
    color: #007bff;
}

/* 카드 및 이미지 스타일 개선 */
.card {
    border: none;
    border-radius: 1rem;
    overflow: hidden;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}
.card:hover {
    transform: translateY(-5px);
    box-shadow: 0 1rem 2rem rgba(0,0,0,0.15) !important;
}

.card-img-top {
    width: 100%;
    height: 220px; /* 모든 이미지의 높이를 동일하게 설정 */
    object-fit: cover; /* 이미지 비율 유지하며 컨테이너에 꽉 채우기 */
    transition: transform 0.3s ease;
}
.card-img-top:hover {
    transform: scale(1.05); /* 마우스 올렸을 때 확대 효과 */
}

.card-body {
    padding: 1.5rem;
}
.card-title {
    font-weight: bold;
    color: #343a40;
}
.card-text strong {
    color: #495057;
}
.card-footer {
    padding: 1rem 1.5rem;
}
</style>
<title>펫밀리</title>
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
	<div class="clear"></div>
	 <div class="row row-cols-1 row-cols-md-2 gx-4 gy-4">
        <div class="col-md-6">
            <div class="pd">
                <c:if test="${not empty pensionList}">
                    <h5 class="card-title text-success mb-3">업체 정보</h5>
                    <p class="card-text mb-0 bd"><strong>업체명:</strong> ${pensionList.business_name}</p>
                    <p class="card-text mb-0 bd"><strong>업체유형:</strong> ${pensionList.business_type}</p>
                    <p class="card-text mb-0 bd"><strong>대표자명:</strong> ${pensionList.owner_name}</p>
                    <p class="card-text mb-0 bd"><strong>우편번호:</strong> ${pensionList.zipcode}</p>
                    <p class="card-text mb-0 bd"><strong>도로명 주소:</strong> ${pensionList.roadAddress}</p>
                    <p class="card-text mb-0 bd"><strong>지번 주소:</strong> ${pensionList.jibunAddress}</p>
                    <p class="card-text mb-0 bd"><strong>나머지 주소:</strong> ${pensionList.namujiAddress}</p>
                    <br>
                </c:if>
                <c:if test="${empty pensionList}">
                    <p>등록된 업체 정보가 없습니다.</p>
                    <br>
                </c:if>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty pensionInfo}">
                <div class="col-md-6">
                    <div class="card mb-4 shadow-sm">
                        <div class="card-body">
                            <input type="hidden" name="p_num" value="${pensionInfo.p_num}" />
                            <h5 class="card-title text-success">펜션 정보</h5>
                            <p class="card-text mb-1"><strong>펜션 등록번호:</strong> ${pensionInfo.business_id}</p>
                            <p class="card-text mb-1"><strong>업체 명:</strong> ${pensionInfo.p_name}</p>
                            <p class="card-text mb-1">
                                <strong>업체 전화번호:</strong> ${pensionInfo.tel1}-${pensionInfo.tel2}-${pensionInfo.tel3}
                            </p>
                            <p class="card-text mb-1"><strong>객실 수:</strong> ${pensionInfo.room_count}</p>
                            <p class="card-text mb-1"><strong>시설 정보:</strong> ${pensionInfo.facilities}</p>
                            <p class="card-text"><strong>설명:</strong> ${pensionInfo.description}</p>
                            <p class="card-text"><strong>펜션승인상태:</strong> ${pensionInfo.pension_status}</p>

                            <div class="d-flex justify-content-end gap-2 mt-3">
                                <a href="${contextPath}/business/pensiondetail.do?p_num=${pensionInfo.p_num}" class="btn btn-outline-primary btn-sm">업체수정</a>
                                <button type="button" class="btn btn-outline-danger btn-sm" onclick="pensiondelete(${pensionInfo.p_num})">업체삭제</button>
                                <a href="${contextPath}/business/addroomForm.do?p_num=${pensionInfo.p_num}" class="btn btn-outline-success btn-sm">객실추가</a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
        </c:choose>
    </div>

    <c:if test="${empty pensionInfo}">
      <p>등록된 펜션 정보가 없습니다.</p>
      <a href="${contextPath}/business/addpensionForm.do"><button type="button" class="btn btn-primary">펜션 등록</button></a>
    </c:if>

    <h3 class="mb-4 mt-5 text-start">등록된 객실 리스트</h3>
    <c:choose>
        <c:when test="${not empty roomInfo and not empty pensionInfo}">
            <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 gx-4 gy-4">
                <c:forEach var="room" items="${roomInfo}">
                   <div class="col">
    <div class="card h-100 shadow-sm">
        <img src="${contextPath}/roomImage.do?fileName=${room.fileName}" class="card-img-top" alt="객실 이미지">
        <div class="card-body text-start">
            <h5 class="card-title">${room.room_name}</h5>
            <p class="card-text mb-1">
                <strong>객실 상태:</strong> 
                <c:choose>
                    <c:when test="${room.room_status == '예약가능'}">
                        <span class="text-success fw-bold">${room.room_status}</span>
                    </c:when>
                    <c:when test="${room.room_status == '삭제됨'}">
                        <span class="text-secondary fw-bold">${room.room_status}</span>
                    </c:when>
                    <c:otherwise>
                        <span class="text-danger fw-bold">${room.room_status}</span>
                    </c:otherwise>
                </c:choose>
            </p>
            <p class="card-text mb-1"><strong>가격:</strong> <fmt:formatNumber value="${room.price}" type="currency" currencySymbol="₩"/></p>
            <p class="card-text mb-1"><strong>타입:</strong> ${room.room_type} / ${room.bed_type}</p>
            <p class="card-text mb-1"><strong>인원:</strong> ${room.max_capacity}명 / ${room.room_size}㎡</p>
            <p class="card-text mb-1 text-muted"><small><strong>설명:</strong> ${room.room_description}</small></p>
            <p class="card-text mb-0 text-muted"><small><strong>편의시설:</strong> ${room.amenities}</small></p>
        </div>
        <div class="card-footer bg-white border-top-0 d-flex justify-content-end gap-2">
            <c:choose>
                <c:when test="${room.room_status == '삭제됨'}">
                    <button type="button" class="btn btn-sm btn-success" onclick="restoreroom(${room.room_id})">복구</button>
                </c:when>
                <c:otherwise>
                    <a href="${contextPath}/business/roomdetailInfo.do?room_id=${room.room_id}" class="btn btn-sm btn-outline-primary">수정</a>
                    <button type="button" class="btn btn-sm btn-outline-danger" onclick="submitdelete(${room.room_id})">삭제</button>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="alert alert-secondary mt-3">객실 정보가 없습니다.</div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>