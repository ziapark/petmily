<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>관리자 펜션 관리</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    body {
        background-color: #f8f9fa;
    }
    .room-details-container {
        display: none; /* 처음에는 객실 목록 숨김 */
        margin-top: 20px;
        padding-top: 20px;
        border-top: 2px solid #dee2e6;
    }
    .card-footer {
        background-color: #fff;
    }
    .pension-details {
        font-size: 0.9rem;
    }
</style>
</head>
<body>

<div class="container mt-3 mb-3">
    <div class="row row-cols-1 mb-3">
        <div class="col bg-light p-5 text-start rounded">
            <h2 class="fw-bold">관리자 펜션 관리</h2>
        </div>
    </div>

    <div class="row seller_menu">
			<ul>	
				<li><a href="${contextPath}/admin/goods/addNewGoodsForm.do">상품등록</a></li>
				<li><a href="${contextPath}/admin/goods/adminGoodsMain.do">상품관리</a></li>
				<li><a href="${contextPath}/admin/order/adminOrderMain.do">주문/배송관리</a></li>							
				<li><a href="${contextPath}/admin/member/adminMemberMain.do">회원관리</a></li>
				<li><a href="${contextPath}/account/accountMain.do">회계관리</a></li>
	
				<li><a href="${contextPath}/business/admin/pensionList.do">펜션관리</a></li>
				<li><a href="${contextPath}/reservation/adminPensionCheck.do">예약관리</a></li>	
			</ul>
		</div>

    <h3 class="mb-4">전체 펜션 목록</h3>
    <div class="list-group">
        <c:choose>
            <c:when test="${not empty allPensions}">
                <c:forEach var="pension" items="${allPensions}">
                    <div class="list-group-item list-group-item-action flex-column align-items-start mb-3 shadow-sm rounded">
                        <div class="d-flex w-100 justify-content-between">
                            <h5 class="mb-1">${pension.p_name}</h5>
                            <%-- ▼▼▼▼▼ [수정] 문자열을 Date 타입으로 먼저 변환 후 포맷팅 ▼▼▼▼▼ --%>
                            <fmt:parseDate value="${pension.reg_date}" pattern="yyyy-MM-dd HH:mm:ss" var="parsedRegDate" />
                            <small>등록일: <fmt:formatDate value="${parsedRegDate}" pattern="yyyy-MM-dd" /></small>
                            <%-- ▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲▲ --%>
                        </div>
                        <div class="pension-details mt-2">
                             <p class="mb-1">
                                <strong>사업자:</strong> ${pension.business_name} (${pension.seller_id}) | 
                                <strong>대표:</strong> ${pension.owner_name} | 
                                <strong>사업자번호:</strong> ${pension.business_number}
                            </p>
                            <p class="mb-1">
                                <strong>주소:</strong> ${pension.roadAddress} | 
                                <strong>연락처:</strong> ${pension.tel1}-${pension.tel2}-${pension.tel3}
                            </p>
                        </div>
                        <div class="d-flex align-items-center justify-content-end mt-2">
                            <div class="me-3">
                                <strong>승인 상태:</strong>
                                <select class="form-select form-select-sm d-inline-block w-auto pension-status-select" data-pnum="${pension.p_num}">
                                    <option value="pending" ${pension.pension_status == 'pending' ? 'selected' : ''}>승인대기</option>
                                    <option value="approve" ${pension.pension_status == 'approve' ? 'selected' : ''}>승인완료</option>
                                </select>
                            </div>
                            <button class="btn btn-primary btn-sm view-rooms-btn" data-pnum="${pension.p_num}">
                                객실 보기
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p class="text-center text-muted">등록된 펜션이 없습니다.</p>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- AJAX로 객실 목록을 불러올 컨테이너 -->
    <div id="room-details-container" class="room-details-container">
        <h4 id="room-list-title"></h4>
        <div id="room-list-content" class="row row-cols-1 row-cols-md-2 g-4"></div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
$(document).ready(function() {
    // 1. 펜션 승인 상태 변경 처리
    $('.pension-status-select').on('change', function() {
        const p_num = $(this).data('pnum');
        const newStatus = $(this).val();
        const pensionName = $(this).closest('.list-group-item').find('h5').text();
        const originalStatus = $(this).find('option:not(:selected)').val();

        const statusText = (newStatus === 'approve') ? '승인완료' : '승인대기';
        const confirmMessage = "'" + pensionName + "' 펜션의 상태를 '" + statusText + "' (으)로 변경하시겠습니까?";

        if (confirm(confirmMessage)) {
            $.ajax({
                type: "POST",
                url: "${contextPath}/business/admin/pension/updatePensionStatus.do",
                data: { 
                    p_num: p_num,
                    status: newStatus 
                },
                dataType: "json",
                success: function(response) {
                    if (response.success) {
                        alert("상태가 성공적으로 변경되었습니다.");
                    } else {
                        alert("상태 변경에 실패했습니다: " + (response.message || '알 수 없는 오류'));
                        $(this).val(originalStatus);
                    }
                },
                error: function() {
                    alert("서버와 통신 중 오류가 발생했습니다.");
                    $(this).val(originalStatus);
                }
            });
        } else {
            $(this).val(originalStatus);
        }
    });

    // 2. '객실 보기' 버튼 클릭 처리
    $('.view-rooms-btn').on('click', function() {
        const p_num = $(this).data('pnum');
        const pensionName = $(this).closest('.list-group-item').find('h5').text();

        $.ajax({
            type: "GET",
            url: "${contextPath}/business/admin/pension/getRoomList.do",
            data: { p_num: p_num },
            dataType: "html",
            success: function(roomHtml) {
                $('#room-list-title').text("'" + pensionName + "'의 객실 목록");
                $('#room-list-content').html(roomHtml);
                $('#room-details-container').data('pnum', p_num).slideDown();
            },
            error: function() {
                alert("객실 정보를 불러오는 데 실패했습니다.");
            }
        });
    });

    // 3. 동적으로 생성된 객실의 삭제/복구 버튼 처리 (이벤트 위임)
    $('#room-list-content').on('click', '.room-action-btn', function() {
        const action = $(this).data('action');
        const roomId = $(this).data('roomid');
        const roomName = $(this).closest('.card').find('.card-title').text();
        const p_num = $('#room-details-container').data('pnum');
        
        let confirmMessage = "";
        let url = "";

        if (action === 'delete') {
            confirmMessage = "'" + roomName + "' 객실을 '삭제됨' 상태로 변경하시겠습니까?";
            url = "${contextPath}/business/removeroom.do";
        } else if (action === 'restore') {
            confirmMessage = "'" + roomName + "' 객실을 '예약가능' 상태로 복구하시겠습니까?";
            url = "${contextPath}/business/restoreroom.do";
        }

        if (confirm(confirmMessage)) {
            $.ajax({
                type: "POST",
                url: url,
                data: { room_id: roomId },
                dataType: "text",
                success: function(response) {
                    if ($.trim(response) === "true") {
                        alert("객실이 성공적으로 " + (action === 'delete' ? '삭제' : '복구') + " 처리되었습니다.");
                        $('.view-rooms-btn[data-pnum="' + p_num + '"]').click();
                    } else {
                        alert("작업에 실패했습니다.");
                    }
                },
                error: function() {
                    alert("서버와 통신 중 오류가 발생했습니다.");
                }
            });
        }
    });
});
</script>
</body>
</html>
