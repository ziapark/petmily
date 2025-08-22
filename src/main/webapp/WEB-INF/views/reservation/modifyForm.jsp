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
                    <form name="frmModify" action="${contextPath}/reservation/updateReservation.do" method="post" onsubmit="return validateForm()">
                        <input type="hidden" name="reservation_id" value="${reservation.reservation_id}" />
           
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
                                <input type="date" class="form-control" id="checkin_date22" name="checkin_date" value="${formattedCheckinDate}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="checkout_date" class="form-label">체크아웃 날짜</label>
                                <input type="date" class="form-control" id="checkout_date22" name="checkout_date" value="${formattedCheckoutDate}" required>
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
                            <input type="hidden" id="total_price_input" name="total_price" value="${reservation.total_price}" />
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

<script>
    // DOM 요소 가져오기
    const checkinInput = document.getElementById('checkin_date22');
    const checkoutInput = document.getElementById('checkout_date22');
    const totalPriceSpan = document.getElementById('total_price_display');
    const totalPriceInput = document.getElementById('total_price_input');

    /**
     * 시간대 오류를 원천적으로 방지하기 위해 UTC 기준으로 숙박일수를 계산하는 함수
     */
    function getNights(checkinStr, checkoutStr) {
        if (!checkinStr || !checkoutStr) return 0;
        const oneDay = 1000 * 60 * 60 * 24;
        const [inYear, inMonth, inDay] = checkinStr.split('-').map(Number);
        const [outYear, outMonth, outDay] = checkoutStr.split('-').map(Number);
        const checkinUTC = Date.UTC(inYear, inMonth - 1, inDay);
        const checkoutUTC = Date.UTC(outYear, outMonth - 1, outDay);
        const timeDiff = checkoutUTC - checkinUTC;
        if (timeDiff <= 0) return 0;
        return Math.round(timeDiff / oneDay);
    }

    // --- 1. '1박당 가격'을 역산하기 ---
    const initialTotalPrice = parseFloat('${reservation.total_price}');
    const initialNights = getNights('${formattedCheckinDate}', '${formattedCheckoutDate}');
    
    // 1박 요금 계산 시 소수점이 발생할 수 있음
    const rawPricePerNight = initialNights > 0 ? initialTotalPrice / initialNights : 0;
    
    // ▼▼▼▼▼ [수정] 계산된 1박 요금을 1000원 단위로 반올림하여 오차를 보정합니다. ▼▼▼▼▼
    const pricePerNight = Math.round(rawPricePerNight / 1000) * 1000;
    // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
    
    // --- 2. 이벤트 리스너 및 UI 업데이트 로직 ---
    const today = new Date().toISOString().split('T')[0];
    checkinInput.setAttribute('min', today);

    checkinInput.addEventListener('change', handleDateChange);
    checkoutInput.addEventListener('change', calculateTotalPrice);
    
    handleDateChange();

    function handleDateChange() {
        if (checkinInput.value) {
            let nextDay = new Date(checkinInput.value);
            nextDay.setDate(nextDay.getDate() + 1);
            let minCheckoutDate = nextDay.toISOString().substring(0, 10);
            
            checkoutInput.setAttribute('min', minCheckoutDate);

            if (checkoutInput.value < minCheckoutDate) {
                 checkoutInput.value = '';
            }
        }
        calculateTotalPrice();
    }

    function calculateTotalPrice() {
        const nights = getNights(checkinInput.value, checkoutInput.value);
        let totalPrice = 0;

        if (nights > 0) {
            // 보정된 1박 요금으로 총액을 계산
            totalPrice = nights * pricePerNight;
        }
        
        totalPriceSpan.textContent = totalPrice.toLocaleString();
        totalPriceInput.value = totalPrice;
    }
    
    function validateForm() {
        const nights = getNights(checkinInput.value, checkoutInput.value);
        if (nights <= 0) {
            alert('체크아웃 날짜는 체크인 날짜보다 늦어야 합니다.');
            checkinInput.focus();
            return false;
        }
        
        if (confirm("수정된 내용으로 저장하시겠습니까?")) {
            return true;
        } else {
            return false;
        }
    }
</script>

</body>
</html>
