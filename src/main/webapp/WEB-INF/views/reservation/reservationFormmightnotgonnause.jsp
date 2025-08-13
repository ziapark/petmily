<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약하기</title>
<style>
    /* 스타일은 기존과 동일 */
    .reservation-form-container { width: 60%; max-width: 600px; margin: 50px auto; padding: 30px; border: 1px solid #ddd; border-radius: 8px; box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
    h2 { text-align: center; margin-bottom: 30px; color: #007bff; }
    .form-group { margin-bottom: 20px; }
    label { display: block; margin-bottom: 8px; font-weight: bold; }
    input[type="date"], input[type="text"] { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
    .submit-button-container { text-align: center; margin-top: 30px; }
    .submit-button { padding: 12px 30px; background-color: #007bff; color: white; border: none; border-radius: 5px; font-size: 1.1em; cursor: pointer; }
    .submit-button:hover { background-color: #0056b3; }
    #total-price-display { font-size: 1.2em; font-weight: bold; color: #d9534f; text-align: right; margin-top: 15px; }
</style>
</head>
<body>
    <div class="reservation-form-container">
        <h2>${pension.p_name} - ${room.room_name} 예약하기</h2>

        <form action="${contextPath}/reservation/addReservation.do" method="post">
            <input type="hidden" name="business_id" value="${pension.business_id}">
            <input type="hidden" name="room_id" value="${room.room_id}">
            <input type="hidden" name="member_id" value="${sessionScope.member.member_id}">
            
            <%-- ▼▼▼ [이 부분 추가] 총 가격을 서버로 보내기 위한 숨겨진 필드 ▼▼▼ --%>
            <input type="hidden" id="total_price" name="total_price" value="0">
            <%-- ▲▲▲ [여기까지 추가] ▲▲▲ --%>
            
            <div class="form-group">
                <label for="reservation_date">체크인 날짜:</label>
                <input type="date" id="reservation_date" name="reservation_date" required>
            </div>
            
            <div class="form-group">
                <label for="end_date">체크아웃 날짜:</label>
                <input type="date" id="end_date" name="end_date" required>
            </div>

            <%-- ▼▼▼ [이 부분 추가] 계산된 총 가격을 사용자에게 보여주는 영역 ▼▼▼ --%>
            <div class="form-group">
                <label>예상 결제 금액</label>
                <div id="total-price-display">0 원</div>
            </div>
            <%-- ▲▲▲ [여기까지 추가] ▲▲▲ --%>
            
            <div class="submit-button-container">
                <button type="submit" class="submit-button">예약 완료</button>
            </div>
        </form>
    </div>

<script>
    // 날짜 입력 필드와 가격 표시 영역을 가져옵니다.
    const checkinInput = document.getElementById('reservation_date');
    const checkoutInput = document.getElementById('end_date');
    const totalPriceDisplay = document.getElementById('total-price-display');
    const totalPriceInput = document.getElementById('total_price'); // 숨겨진 input

    // 1박당 가격 (JSP 변수를 JavaScript 변수로 가져옴)
    // 중요: 컨트롤러에서 room 객체와 그 안의 price를 모델에 담아 보내줘야 합니다.
    const pricePerNight = parseInt('${room.price}', 10) || 0;

    // 날짜가 변경될 때마다 가격을 다시 계산하는 함수
    function calculateTotalPrice() {
        const checkinDate = new Date(checkinInput.value);
        const checkoutDate = new Date(checkoutInput.value);

        // 두 날짜가 모두 유효한 경우에만 계산
        if (checkinInput.value && checkoutInput.value && checkoutDate > checkinDate) {
            // 두 날짜 간의 차이(밀리초)를 일수로 변환
            const diffTime = Math.abs(checkoutDate - checkinDate);
            const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24)); 
            
            const total = diffDays * pricePerNight;

            // 화면에 가격 표시 (예: 100000 -> 100,000 원)
            totalPriceDisplay.textContent = total.toLocaleString() + ' 원';
            // 서버로 보낼 숨겨진 input에 값 설정
            totalPriceInput.value = total;
        } else {
            totalPriceDisplay.textContent = '0 원';
            totalPriceInput.value = '0';
        }
    }

    // 체크인 또는 체크아웃 날짜가 변경되면 계산 함수를 호출
    checkinInput.addEventListener('change', calculateTotalPrice);
    checkoutInput.addEventListener('change', calculateTotalPrice);

</script>
</body>
</html>