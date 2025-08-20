<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 수정</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card shadow-sm">
                <div class="card-body p-4">
                    <h2 class="card-title text-center mb-4">예약 정보 수정</h2>
                    <form name="frmModify" action="${contextPath}/reservation/updateReservation.do" method="post">
                        <input type="hidden" name="reservation_id" value="${reservation.reservation_id}" />
                        <input type="hidden" id="room_id" value="${reservation.room_id}" />

                        <div class="mb-3">
                            <label class="form-label"><strong>펜션명</strong></label>
                            <p class="form-control-plaintext">${reservation.p_name}</p>
                        </div>
                        <div class="mb-3">
                            <label class="form-label"><strong>객실명</strong></label>
                            <p class="form-control-plaintext">${reservation.room_name}</p>
                        </div>
                        <hr>
                        <div class="mb-3">
                            <label for="reserver_name" class="form-label">예약자명</label>
                            <input type="text" class="form-control" id="reserver_name" name="reserver_name" value="${reservation.reserver_name}" required>
                        </div>
                        <div class="mb-3">
                            <label for="reserver_tel" class="form-label">연락처</label>
                            <input type="text" class="form-control" id="reserver_tel" name="reserver_tel" value="${reservation.reserver_tel}" required>
                        </div>

                        <fmt:formatDate value="${reservation.checkin_date}" pattern="yyyy-MM-dd" var="formattedCheckinDate" />
                        <fmt:formatDate value="${reservation.checkout_date}" pattern="yyyy-MM-dd" var="formattedCheckoutDate" />
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="checkin_date" class="form-label">체크인 날짜</label>
                                <input type="date" class="form-control" id="checkin_date" name="checkin_date" value="${formattedCheckinDate}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="checkout_date" class="form-label">체크아웃 날짜</label>
                                <input type="date" class="form-control" id="checkout_date" name="checkout_date" value="${formattedCheckoutDate}" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="guests" class="form-label">방문 인원</label>
                            <input type="number" class="form-control" id="guests" name="guests" value="${reservation.guests}" min="1" required>
                        </div>

                        <div class="mt-3 text-end">
                            <h4>예상 결제 금액: <span id="total_price_display" class="text-primary fw-bold">
                                <fmt:formatNumber value="${reservation.total_price}" pattern="#,###" />
                            </span>원</h4>
                            <input type="hidden" id="total_price" name="total_price" value="${reservation.total_price}" />
                        </div>

                        <div class="d-grid gap-2 d-md-flex justify-content-md-end mt-4">
                            <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
                            <button type="submit" class="btn btn-primary">수정 완료</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const checkinDateEl = document.getElementById('checkin_date');
    const checkoutDateEl = document.getElementById('checkout_date');
    const contextPath = "${contextPath}"; // contextPath를 JavaScript 변수로 설정

    checkinDateEl.addEventListener('change', calculateAndUpdatePrice);
    checkoutDateEl.addEventListener('change', calculateAndUpdatePrice);

    function calculateAndUpdatePrice() {
        const checkinDate = checkinDateEl.value;
        const checkoutDate = checkoutDateEl.value;
        const roomId = document.getElementById('room_id').value;
        const priceDisplayEl = document.getElementById('total_price_display');
        const totalPriceInputEl = document.getElementById('total_price');

        if (checkinDate && checkoutDate && checkoutDate > checkinDate) {
            fetch(`${contextPath}/reservation/calculatePrice.do?roomId=${roomId}&checkinDate=${checkinDate}&checkoutDate=${checkoutDate}`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('서버 응답 오류');
                    }
                    return response.json();
                })
                .then(data => {
                    const newPrice = data.totalPrice;
                    priceDisplayEl.innerText = newPrice.toLocaleString();
                    totalPriceInputEl.value = newPrice;
                })
                .catch(error => {
                    console.error('가격 계산 실패:', error);
                    priceDisplayEl.innerText = '계산 오류';
                });
        }
    }
});
</script>

</body>
</html>