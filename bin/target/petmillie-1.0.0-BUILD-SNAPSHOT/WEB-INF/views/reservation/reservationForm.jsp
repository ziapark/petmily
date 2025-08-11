<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약하기</title>
<style>
    /* CSS는 필요에 따라 추가하세요 */
    .reservation-form-container {
        width: 60%;
        max-width: 600px;
        margin: 50px auto;
        padding: 30px;
        border: 1px solid #ddd;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    .reservation-form-container h2 {
        text-align: center;
        margin-bottom: 30px;
        color: #007bff;
    }
    .form-group {
        margin-bottom: 20px;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
    }
    .form-group input[type="date"], .form-group input[type="text"] {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box; /* padding이 너비에 포함되도록 설정 */
    }
    .submit-button-container {
        text-align: center;
        margin-top: 30px;
    }
    .submit-button {
        padding: 12px 30px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 5px;
        font-size: 1.1em;
        cursor: pointer;
    }
    .submit-button:hover {
        background-color: #0056b3;
    }
</style>
</head>
<body>
    <div class="reservation-form-container">
        <h2>${pension.p_name} 예약하기</h2>

        <form action="${contextPath}/reservation/addReservation.do" method="post">
    <!-- p_num 대신 business_id를 사용하도록 수정 -->
    <input type="hidden" name="business_id" value="${pension.business_id}">
    <input type="hidden" name="member_id" value="${sessionScope.member.member_id}">
    
    <div class="form-group">
        <label for="reservation_date">체크인 날짜:</label>
        <input type="date" id="reservation_date" name="reservation_date" required>
    </div>
    
    <div class="form-group">
        <label for="end_date">체크아웃 날짜:</label>
        <input type="date" id="end_date" name="end_date" required>
    </div>
    
    <div class="submit-button-container">
        <button type="submit" class="submit-button">예약 완료</button>
    </div>
</form>
    </div>
</body>
</html>

