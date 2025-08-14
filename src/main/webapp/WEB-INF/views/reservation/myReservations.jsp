<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>나의 예약 내역</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    body {
        font-family: 'Inter', sans-serif;
    }
    .card-title {
        font-weight: bold;
        color: #0d6efd;
    }
    .card-text strong {
        color: #495057;
    }
</style>
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4 text-center">나의 예약 내역</h2>
    
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:choose>
            <c:when test="${not empty myReservations}">
                <c:forEach var="reservationItem" items="${myReservations}">
                    <div class="col">
                        <div class="card shadow-sm h-100">
                            <div class="card-body">
                                <h5 class="card-title">예약 번호: ${reservationItem.reservation_id}</h5>
                                <p class="card-text mb-1"><strong>펜션명:</strong> ${reservationItem.p_name}</p>
                                <p class="card-text mb-1"><strong>펜션 주소:</strong> ${reservationItem.roadAddress}</p>
                                <p class="card-text mb-1"><strong>객실명:</strong> ${reservationItem.room_name}</p>
                                <p class="card-text mb-1"><strong>객실 타입:</strong> ${reservationItem.room_type}</p>
                                <p class="card-text mb-1"><strong>침대 타입:</strong> ${reservationItem.bed_type}</p>
                                <p class="card-text mb-1"><strong>예약자명:</strong> ${reservationItem.reserver_name}</p>
                                <p class="card-text mb-1"><strong>연락처:</strong> ${reservationItem.reserver_tel}</p>
                                <p class="card-text mb-1"><strong>체크인:</strong> 
                                    <fmt:formatDate value="${reservationItem.checkin_date}" pattern="yyyy-MM-dd" />
                                </p>
                                <p class="card-text mb-1"><strong>체크아웃:</strong> 
                                    <fmt:formatDate value="${reservationItem.checkout_date}" pattern="yyyy-MM-dd" />
                                </p>
                                <p class="card-text"><strong>결제 금액:</strong> 
                                    <fmt:formatNumber value="${reservationItem.total_price}" pattern="#,###" />원
                                </p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12">
                    <p class="text-center text-muted">예약 내역이 없습니다.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- 뒤로가기 버튼 -->
    <div class="text-center mt-4">
        <button type="button" class="btn btn-secondary" onclick="history.back()">뒤로가기</button>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
