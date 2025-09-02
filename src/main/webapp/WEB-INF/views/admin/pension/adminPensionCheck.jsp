<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>관리자 예약 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
        <div class="col bg-light p-5 text-start">
            <h2 class="fw-bold">관리자 예약 관리</h2>
        </div>
    </div>
	    <div class="row seller_menu">
			<ul>	
				<li><a href="${contextPath}/admin/goods/addNewGoodsForm.do">상품등록</a></li>
				<li><a href="${contextPath}/admin/goods/adminGoodsMain.do">상품관리</a></li>
				<li><a href="${contextPath}/admin/order/adminOrderMain.do">주문/배송관리</a></li>
				<li><a href="${contextPath}/business/admin/pensionList.do">펜션관리</a></li>
				<li><a href="${contextPath}/reservation/adminPensionCheck.do">예약관리</a></li>								
				<li><a href="${contextPath}/admin/member/adminMemberMain.do">회원관리</a></li>
				<li><a href="${contextPath}/account/accountMain.do">회계관리</a></li>
			</ul>
		</div>
    
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:choose>
            <c:when test="${not empty allReservations}"> <%-- 컨트롤러에서 전달하는 변수명을 allReservations로 가정 --%>
                <c:forEach var="reservationItem" items="${allReservations}">
                    <div class="col">
                        <div class="card shadow-sm h-100">
                            <div class="card-body">
                                <h5 class="card-title">예약 번호: ${reservationItem.reservation_id}</h5>
                                <p class="card-text mb-1"><strong>펜션 이름:</strong> ${reservationItem.p_name}</p> <!-- 펜션 이름 추가 -->
                                <p class="card-text mb-1"><strong>객실 이름:</strong> ${reservationItem.room_name}</p>
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

<!-- 확인을 위한 부트스트랩 모달 -->
<div class="modal fade" id="confirmationModal" tabindex="-1" aria-labelledby="confirmationModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="confirmationModalLabel">상태 변경 확인</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body" id="confirmationModalBody">
        <!-- 확인 메시지는 자바스크립트가 동적으로 설정합니다. -->
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
        <button type="button" class="btn btn-primary" id="confirmChangeBtn">변경 확정</button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- 사업자용 페이지의 스크립트와 동일한 로직을 사용합니다. -->
<script>
document.addEventListener('DOMContentLoaded', function () {
    // 1. 필요한 모든 요소를 미리 찾아둡니다.
    const confirmationModalEl = document.getElementById('confirmationModal');
    const confirmationModal = new bootstrap.Modal(confirmationModalEl);
    const modalBody = document.getElementById('confirmationModalBody');
    const confirmBtn = document.getElementById('confirmChangeBtn');
    const allSelects = document.querySelectorAll('.reservation-status-select');

    // 2. 현재 작업 중인 select 요소와 그 원래 값을 저장할 변수를 만듭니다.
    let activeSelect = null;
    let originalStatus = null;
    let isConfirmedAction = false; // '변경 확정' 버튼을 눌렀는지 확인

    // 3. 각 select 요소에 이벤트 리스너를 추가합니다.
    allSelects.forEach(select => {
        // 사용자가 select를 클릭(focus)했을 때, 원래 값을 저장합니다.
        select.addEventListener('focus', function() {
            originalStatus = this.value;
        });

        // 사용자가 값을 변경(change)했을 때, 모달을 띄웁니다.
        select.addEventListener('change', function () {
            activeSelect = this; // 현재 작업 중인 select 요소를 저장
            isConfirmedAction = false; // 작업 시작 시 초기화

            const reservationId = activeSelect.getAttribute('data-id');
            const newStatus = activeSelect.value;

            if (!reservationId || !newStatus) {
                alert("오류: 예약 정보를 가져올 수 없습니다.");
                activeSelect.value = originalStatus; // 즉시 원상 복구
                return;
            }

            // 모달 창의 내용을 채우고 보여줍니다.
            modalBody.innerHTML = `예약 번호 <strong>${reservationId}</strong>의 상태를 '<strong>${newStatus}</strong>'(으)로 변경하시겠습니까?`;
            confirmationModal.show();
        });
    });

    // 4. 모달의 '변경 확정' 버튼에 클릭 이벤트 리스너를 추가합니다.
    confirmBtn.addEventListener('click', function () {
        if (!activeSelect) return; // 작업 대상이 없으면 아무것도 하지 않음
        
        isConfirmedAction = true; // 사용자가 확정했음을 표시

        const dataToUpdate = {
            reservation_id: activeSelect.getAttribute('data-id'),
            reservation_status: activeSelect.value
        };

        fetch('${contextPath}/reservation/updateStatus', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(dataToUpdate),
        })
        .then(response => response.json().then(data => ({ ok: response.ok, data })))
        .then(({ ok, data }) => {
            if (ok && data.success) {
                alert(data.message || '예약 상태가 성공적으로 변경되었습니다.');
            } else {
                alert(data.message || '상태 변경에 실패했습니다.');
                activeSelect.value = originalStatus; // 실패 시 원래 값으로 되돌림
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('상태 변경 중 오류가 발생했습니다.');
            if(activeSelect) activeSelect.value = originalStatus; // 오류 발생 시에도 되돌림
        })
        .finally(() => {
            confirmationModal.hide();
        });
    });
    
    // 5. 모달이 닫힐 때의 처리를 추가합니다.
    confirmationModalEl.addEventListener('hide.bs.modal', function() {
        // '변경 확정'을 누르지 않고 모달이 닫혔다면
        if (!isConfirmedAction && activeSelect) {
             activeSelect.value = originalStatus; // 원래 값으로 되돌립니다.
        }
        // 다음에 모달이 열릴 것을 대비해 작업 대상 정보를 초기화합니다.
        activeSelect = null;
        originalStatus = null;
    });
});
</script>

</body>
</html>
