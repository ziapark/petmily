<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>펫밀리</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
   a{text}
    .card {
        transition: transform 0.2s;
    }
    .card:hover {
        transform: scale(1.02);
    }
    .card-title {
        font-weight: bold;
        color: #0d6efd;
    }
    .card-text strong {
        color: #495057;
    }
    /* 예약 상태별 색상 스타일 */
    .status-complete { color: #198754; font-weight: bold; } /* 예약완료: 초록색 */
    .status-cancelled { color: #dc3545; font-weight: bold; } /* 예약취소: 빨간색 */
    .status-used { color: #6c757d; font-weight: bold; }     /* 이용완료: 회색 */
</style>
</head>
<body>

	<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
        <div class="col bg-light p-5 text-start">
            <h2 class="fw-bold">나의 예약확인</h2>
        </div>
    </div>
    <div class="row seller_menu">
		<ul>	
			<li><a href="${contextPath}/mypage/myDetailInfo.do">내 정보</a></li>
			<li><a href="${contextPath}/mypage/myPetInfo.do">나의 반려동물</a></li>
			<li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문/배송 조회</a></li>
			<li><a href="${contextPath}/reservation/myReservations.do">예약확인</a></li>				
			<li><a href="${contextPath}/mypage/myReview.do">나의 리뷰</a></li>
			<li><a href="${contextPath}/mypage/likeGoods.do">나의 관심상품</a></li>				
			<li><a href="${contextPath}/mypage/deleteForm.do">회원탈퇴</a></li>
		</ul>
	</div>
    
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:choose>
            <c:when test="${not empty myReservations}">
                <c:forEach var="reservation" items="${myReservations}">
                    <div class="col">
                        <div class="card shadow-sm h-100" style="border-color:#78e2bd;">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title" style="color:#198754;">예약 번호: ${reservation.reservation_id}</h5>
                                <hr>
                                <p class="card-text mb-1"><strong>펜션명:</strong> ${reservation.p_name}</p>
                                <p class="card-text mb-1"><strong>객실명:</strong> ${reservation.room_name}</p>
                                <p class="card-text mb-1"><strong>체크인:</strong> <fmt:formatDate value="${reservation.checkin_date}" pattern="yyyy-MM-dd" /></p>
                                <p class="card-text mb-1"><strong>체크아웃:</strong> <fmt:formatDate value="${reservation.checkout_date}" pattern="yyyy-MM-dd" /></p>
                                <p class="card-text mb-1"><strong>예약자명:</strong> ${reservation.reserver_name}</p>
                                <p class="card-text mb-1"><strong>연락처:</strong> ${reservation.reserver_tel}</p>
                                <p class="card-text"><strong>결제 금액:</strong> <fmt:formatNumber value="${reservation.total_price}" pattern="#,###" />원</p>
                                
                                <!-- 예약 상태 표시 (카드 맨 아래에 위치) -->
                                <p class="card-text mt-auto pt-2">
                                    <strong>예약상태:</strong> 
                                    <c:choose>
                                        <c:when test="${reservation.reservation_status == '예약완료'}">
                                            <span class="status-complete">${reservation.reservation_status}</span>
                                        </c:when>
                                        <c:when test="${reservation.reservation_status == '예약취소'}">
                                            <span class="status-cancelled">${reservation.reservation_status}</span>
                                        </c:when>
                                        <c:when test="${reservation.reservation_status == '이용완료'}">
                                            <span class="status-used">${reservation.reservation_status}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span>${reservation.reservation_status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </p>

                                <!-- ▼▼▼ 수정 및 취소 버튼 추가 ▼▼▼ -->
                                <!-- '예약완료' 상태일 때만 버튼이 보이도록 설정 -->
                                <c:if test="${reservation.reservation_status == '예약대기'}">
                                    <div class="mt-3 d-flex justify-content-end gap-2 border-top pt-3">
                                        <a href="${contextPath}/reservation/modifyForm.do?reservationId=${reservation.reservation_id}" class="btn btn-sm btn-outline-primary">예약 수정</a>
                                        <button type="button" class="btn btn-sm btn-outline-danger" onclick="cancelReservation(${reservation.reservation_id})">예약 취소</button>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12">
                    <div class="alert alert-secondary text-center" role="alert">
                        예약 내역이 없습니다.
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- 뒤로가기 버튼 -->
    <div class="text-center mt-4">
        <button type="button" class="btn btn-secondary" onclick="history.back()">뒤로가기</button>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- ▼▼▼ 예약 취소 기능을 위한 JavaScript 추가 ▼▼▼ -->
<script>
function cancelReservation(reservationId) {
    if (confirm("정말로 이 예약을 취소하시겠습니까?")) {
        fetch("${contextPath}/reservation/cancel.do", {
            method: "POST",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            },
            body: "reservation_id=" + reservationId
        })
        .then(response => response.text())
        .then(data => {
            alert(data); // 서버에서 보낸 메시지 표시
            window.location.reload();
        })
        .catch(error => {
            alert("예약 취소 중 오류가 발생했습니다.");
        });
    }
}
</script>


</body>
</html>
