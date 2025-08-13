<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>예약 완료</title>
<style>
    .complete-container {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        min-height: 60vh;
        text-align: center;
        font-family: 'Malgun Gothic', sans-serif;
    }
    .complete-container h2 {
        font-size: 2.2rem;
        color: #2c3e50;
        margin-bottom: 20px;
    }
    .complete-container p {
        font-size: 1.1rem;
        color: #555;
        margin-bottom: 40px;
    }
    .btn-home {
        display: inline-block;
        padding: 12px 30px;
        background-color: #3498db;
        color: white;
        text-decoration: none;
        font-size: 1rem;
        font-weight: bold;
        border-radius: 5px;
        transition: background-color 0.3s;
    }
    .btn-home:hover {
        background-color: #2980b9;
    }
</style>
</head>
<body>
    <div class="complete-container">
        <h2>예약이 성공적으로 완료되었습니다.</h2>
        <p>예약 내역은 마이페이지에서 확인하실 수 있습니다.</p>
        <a href="${contextPath}/main.do" class="btn-home">홈으로 가기</a>
    </div>
</body>
</html>
