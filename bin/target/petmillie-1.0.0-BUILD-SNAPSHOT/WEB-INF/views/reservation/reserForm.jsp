<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>예약 확인 페이지</title>
<!-- 부트스트랩 CDN 추가 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-5">
    <h2 class="mb-4 text-center">예약 확인 내역</h2>
    
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:forEach var="vation" items="${reservation}">
            <div class="col">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title">예약 번호: ${vation.reservaion_id}</h5>
                        <p class="card-text mb-1"><strong>회원 아이디:</strong> ${vation.member_id}</p>
                        <p class="card-text mb-1"><strong>예약일:</strong> ${vation.reservation_date}</p>
                        <p class="card-text mb-1"><strong>종료일:</strong> ${vation.end_date}</p>
                        <p class="card-text"><strong>예약 등록 시간:</strong> ${vation.reg_date}</p>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- 부트스트랩 JS (선택) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
