<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>나의 예약 내역</title>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    /* 간단한 스타일 추가 */
    body {
        background-color: #f8f9fa;
    }
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

<div class="container my-5">
    <h2 class="mb-4 text-center">나의 예약 내역</h2>
    
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:choose>
            <c:when test="${not empty myReservations}">
                <c:forEach var="reservation" items="${myReservations}">
                    <div class="col">
                        <div class="card shadow-sm h-100">
                            <div class="card-body d-flex flex-column">
                                <h5 class="card-title">예약 번호: ${reservation.reservation_id}</h5>
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

</body>
</html>
