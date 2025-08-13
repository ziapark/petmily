<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>객실 예약</title>
<style>
    body {
        font-family: 'Malgun Gothic', sans-serif;
        background-color: #f4f7f6;
        color: #333;
        margin: 0;
        padding: 20px;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
    }
    .reservation-container {
        width: 100%;
        max-width: 650px;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        padding: 30px 40px;
    }
    h2 {
        text-align: center;
        font-size: 2rem;
        color: #2c3e50;
        margin-bottom: 25px;
        border-bottom: 2px solid #3498db;
        padding-bottom: 15px;
    }
    .info-section {
        background-color: #ecf0f1;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 30px;
    }
    .info-section h3 {
        margin-top: 0;
        color: #2980b9;
        font-size: 1.5rem;
    }
    .info-section p {
        margin: 8px 0;
        font-size: 1rem;
    }
    .info-section strong {
        color: #34495e;
        margin-right: 8px;
    }
    .reservation-form .form-group {
        margin-bottom: 20px;
    }
    .reservation-form label {
        display: block;
        font-weight: bold;
        margin-bottom: 8px;
        color: #555;
    }
    .reservation-form input[type="text"],
    .reservation-form input[type="tel"],
    .reservation-form input[type="date"],
    .reservation-form input[type="number"] {
        width: 100%;
        padding: 12px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 1rem;
        box-sizing: border-box;
    }
    .reservation-form input:focus {
        border-color: #3498db;
        outline: none;
        box-shadow: 0 0 5px rgba(52, 152, 219, 0.5);
    }
    .date-inputs {
        display: flex;
        gap: 20px;
    }
    .date-inputs .form-group {
        flex: 1;
    }
    .total-price-section {
        text-align: right;
        margin-top: 30px;
        padding-top: 20px;
        border-top: 1px solid #eee;
    }
    .total-price-section span {
        font-size: 1.8rem;
        font-weight: bold;
        color: #e74c3c;
    }
    .submit-btn {
        display: block;
        width: 100%;
        padding: 15px;
        background-color: #27ae60;
        color: white;
        text-align: center;
        border: none;
        border-radius: 5px;
        font-size: 1.2rem;
        font-weight: bold;
        cursor: pointer;
        transition: background-color 0.3s;
        margin-top: 15px;
    }
    .submit-btn:hover {
        background-color: #229954;
    }
    .submit-btn:disabled {
        background-color: #95a5a6;
        cursor: not-allowed;
    }
</style>
</head>
<body>

<div class="reservation-container">
    <h2>객실 예약</h2>

    <div class="info-section">
        <h3>${pension.p_name}</h3>
        <p><strong>객실 이름:</strong> ${room.room_name}</p>
        <p><strong>1박 요금:</strong> <fmt:formatNumber value="${room.price}" pattern="#,###" />원</p>
        <p><strong>최대 인원:</strong> ${room.max_capacity}명</p>
    </div>

    <form name="reservationForm" class="reservation-form" method="post" action="${contextPath}/reservation/makeReservation.do" onsubmit="return validateForm()">
        <%-- 서버로 전송해야 할 숨겨진 데이터 --%>
        <input type="hidden" name="p_num" value="${pension.p_num}">
        <input type="hidden" name="room_id" value="${room.room_id}">
        <input type="hidden" name="price" value="${room.price}">
        <input type="hidden" name="business_id" value="${pension.business_id}">
        
        <!-- ▼▼▼▼▼ [수정 1] 총액을 서버로 보내기 위한 숨겨진 input 추가 ▼▼▼▼▼ -->
        <input type="hidden" id="total_price_input" name="total_price" value="0">
        <!-- ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲ -->

        <div class="date-inputs">
            <div class="form-group">
                <label for="checkin_date">체크인</label>
                <input type="date" id="checkin_date" name="checkin_date" required>
            </div>
            <div class="form-group">
                <label for="checkout_date">체크아웃</label>
                <input type="date" id="checkout_date" name="checkout_date" required>
            </div>
        </div>

        <div class="form-group">
            <label for="guests">예약 인원</label>
            <input type="number" id="guests" name="guests" min="1" max="${room.max_capacity}" placeholder="인원 수를 입력하세요" required>
        </div>
        
        <div class="form-group">
            <label for="reserver_name">예약자 이름</label>
            <input type="text" id="reserver_name" name="reserver_name" placeholder="실명을 입력하세요" required>
        </div>

        <div class="form-group">
            <label for="reserver_tel">연락처</label>
            <input type="tel" id="reserver_tel" name="reserver_tel" placeholder="'-' 없이 숫자만 입력하세요" required>
        </div>

        <div class="total-price-section">
            <p>총 결제 예정 금액: <span id="total_price">0</span>원</p>
        </div>
        
        <button type="submit" id="submit_btn" class="submit-btn" disabled>예약 확정하기</button>
    </form>
</div>

<script>
    // DOM 요소 가져오기
    const checkinInput = document.getElementById('checkin_date');
    const checkoutInput = document.getElementById('checkout_date');
    const guestsInput = document.getElementById('guests');
    const totalPriceSpan = document.getElementById('total_price');
    const submitBtn = document.getElementById('submit_btn');
    
    // ▼▼▼▼▼ [수정 2] 숨겨진 input 요소를 변수에 할당 ▼▼▼▼▼
    const totalPriceInput = document.getElementById('total_price_input');
    // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲

    // 1박 요금 (JSP EL을 사용하여 JavaScript 변수에 할당)
    const pricePerNight = parseInt('${room.price}');

    // 오늘 날짜를 YYYY-MM-DD 형식으로 가져오기
    const today = new Date().toISOString().split('T')[0];
    // 체크인 날짜는 오늘부터 선택 가능하도록 설정
    checkinInput.setAttribute('min', today);

    // 입력 변경 시 총액 계산 함수 호출
    checkinInput.addEventListener('change', handleDateChange);
    checkoutInput.addEventListener('change', calculateTotalPrice);
    
    // 체크인 날짜 변경 시 체크아웃 날짜의 min 속성 설정
    function handleDateChange() {
        const checkinDate = checkinInput.value;
        if (checkinDate) {
            let nextDay = new Date(checkinDate);
            nextDay.setDate(nextDay.getDate() + 1);
            checkoutInput.value = ''; // 체크아웃 날짜 초기화
            checkoutInput.setAttribute('min', nextDay.toISOString().split('T')[0]);
        }
        calculateTotalPrice();
    }

    // 총 요금 계산 및 UI 업데이트 함수
    function calculateTotalPrice() {
        const checkinDate = new Date(checkinInput.value);
        const checkoutDate = new Date(checkoutInput.value);

        let totalPrice = 0;
        let nights = 0;

        // 날짜가 유효하고, 체크아웃이 체크인보다 늦은 경우에만 계산
        if (checkinInput.value && checkoutInput.value && checkoutDate > checkinDate) {
            const timeDiff = checkoutDate.getTime() - checkinDate.getTime();
            nights = Math.ceil(timeDiff / (1000 * 3600 * 24));
            
            if (nights > 0) {
                totalPrice = nights * pricePerNight;
                submitBtn.disabled = false;
            } else {
                 submitBtn.disabled = true;
            }
        } else {
            submitBtn.disabled = true;
        }
        
        // 화면에 총 요금 표시 (세자리 콤마 포맷)
        totalPriceSpan.textContent = totalPrice.toLocaleString();
        
        // ▼▼▼▼▼ [수정 3] 숨겨진 input의 값을 계산된 총액으로 업데이트 ▼▼▼▼▼
        totalPriceInput.value = totalPrice;
        // ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲
    }
    
    // 폼 제출 전 최종 유효성 검사
    function validateForm() {
        if (guestsInput.value > parseInt('${room.max_capacity}')) {
            alert('최대 수용 인원을 초과할 수 없습니다. (최대 ${room.max_capacity}명)');
            guestsInput.focus();
            return false;
        }

        const nights = (new Date(checkoutInput.value) - new Date(checkinInput.value)) / (1000 * 3600 * 24);
        if (nights <= 0) {
            alert('체크인 날짜는 체크아웃 날짜보다 이전이어야 합니다.');
            checkinInput.focus();
            return false;
        }
        
        if (confirm("예약을 진행하시겠습니까?")) {
            return true;
        } else {
            return false;
        }
    }
</script>

</body>
</html>
