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
                        <!-- 수정할 예약의 ID를 숨겨서 함께 전송합니다. -->
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
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="checkin_date" class="form-label">체크인 날짜</label>
                                <input type="date" class="form-control" id="checkin_date" name="checkin_date" value="<fmt:formatDate value="${reservation.checkin_date}" pattern="yyyy-MM-dd" />" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="checkout_date" class="form-label">체크아웃 날짜</label>
                                <input type="date" class="form-control" id="checkout_date" name="checkout_date" value="<fmt:formatDate value="${reservation.checkout_date}" pattern="yyyy-MM-dd" />" required>
                            </div>
                        </div>
                         <div class="mb-3">
                            <label for="guests" class="form-label">방문 인원</label>
                            <input type="number" class="form-control" id="guests" name="guests" value="${reservation.guests}" min="1" required>
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
</body>
</html>
