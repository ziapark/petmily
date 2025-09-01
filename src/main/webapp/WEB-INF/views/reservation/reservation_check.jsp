<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>예약 확인 페이지</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
        <div class="col bg-light p-5 text-start">
            <h2 class="fw-bold">예약 확인 및 관리</h2>
        </div>
    </div>
   	<div class="row seller_menu">
		<ul>	
			<li><a href="${contextPath}/business/businessDetailInfo.do">내 정보</a></li>
			<li><a href="${contextPath}/business/addNewGoodsForm.do">상품등록</a></li>
			<li><a href="${contextPath}/business/businessGoodsMain.do">상품관리</a></li>
			<li><a href="${contextPath}/business/businessOrderMain.do">주문/배송관리</a></li>
			<li><a href="${contextPath}/business/addpensionForm.do">펜션등록</a></li>
			<li><a href="${contextPath}/business/mypension.do?business_id=${businessInfo.business_id}">펜션관리</a></li>
			<li><a href="${contextPath}/reservation/reservation_check.do">예약관리</a></li>
			<li><a href="${contextPath}/account/accountDetail.do?seller_id=${businessInfo.seller_id}">회계관리</a></li>
			<li><a href="${contextPath}/business/deleteForm.do">회원탈퇴</a></li>
		</ul>
	</div>
    
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:choose>
            <c:when test="${not empty reservation}">
                <c:forEach var="reservationItem" items="${reservation}">
                    <div class="col">
                        <div class="card shadow-sm h-100">
                            <div class="card-body">
                                <h5 class="card-title">예약 번호: ${reservationItem.reservation_id}</h5>
                                <p class="card-text mb-1"><strong>객실 이름:</strong> ${reservationItem.room_name}</p>
                                <p class="card-text mb-1"><strong>객실 타입:</strong> ${reservationItem.room_type}</p>
                                <p class="card-text mb-1"><strong>회원 아이디:</strong> ${reservationItem.member_id}</p>
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
                                
                                <div class="mt-2">
                                    <strong>예약 상태:</strong>
                                    <select class="form-select form-select-sm reservation-status-select" 
                                            data-id="${reservationItem.reservation_id}">

                                        <option value="예약대기" ${reservationItem.reservation_status == '예약대기' ? 'selected' : ''}>예약대기</option>
                                        <option value="예약완료" ${reservationItem.reservation_status == '예약완료' ? 'selected' : ''}>예약완료</option>
                                        <option value="예약취소" ${reservationItem.reservation_status == '예약취소' ? 'selected' : ''}>예약취소</option>
                                    </select>
                                </div>
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
    
    <div class="text-center mt-4">
        <button type="button" class="btn btn-secondary" onclick="history.back()">뒤로가기</button>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // 모든 예약 상태 변경 select 요소를 가져옵니다.
    const statusSelects = document.querySelectorAll('.reservation-status-select');

    statusSelects.forEach(select => {
        select.addEventListener('change', function() {
            // 선택된 새로운 상태와 예약 ID를 가져옵니다.
            const newStatus = this.value;
            const reservationId = this.dataset.id;
            
            // 사용자에게 변경 여부를 다시 한번 확인받습니다.
            if (confirm(`예약 상태를 변경하시겠습니까?`)) {
                
                // 서버로 보낼 데이터를 준비합니다.
                const data = {
                    reservation_id: reservationId,
                    reservation_status: newStatus
                };

                // fetch API를 사용하여 서버에 Ajax 요청을 보냅니다.
                fetch('${contextPath}/reservation/updateStatus', { // 서버의 URL 경로
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(data),
                })
                .then(response => response.json()) // 서버의 응답을 JSON 형태로 파싱합니다.
                .then(result => {
                    if (result.success) {
                        alert('예약 상태가 성공적으로 변경되었습니다.');
                    } else {
                        alert('상태 변경에 실패했습니다: ' + result.message);
                        // 실패 시, select의 값을 이전 상태로 되돌릴 수 있습니다 (선택사항).
                        // location.reload(); 
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('상태 변경 중 오류가 발생했습니다.');
                });
            }
        });
    });
});
</script>

</body>
</html>