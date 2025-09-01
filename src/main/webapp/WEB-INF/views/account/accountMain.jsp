<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="contextPath"  value="${pageContext.request.contextPath}" />

<html>
<head>
	<meta charset="utf-8">
	<title>회계 관리</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<style>
		/* 전체적인 레이아웃 스타일 */
		.accounting-container { padding: 20px; background-color: #f9f9f9; }
		.section-header { margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #eee; }
		.section-header h2, .section-header h5 { font-weight: bold; color: #333; }
		/* 날짜 선택 영역 스타일 */
		.date-selector { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
		.date-selector .btn-group .btn { margin-right: 5px; }
		/* 순위 테이블 컨테이너 */
		.table-container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
		.table th, .table td { vertical-align: middle; text-align: center; }
		.table .store-name { text-align: left; }
		.table .net-sales { font-weight: bold; color: #007bff; }
        /* 수수료 입력칸 스타일 */
        .commission-cell { display: flex; align-items: center; justify-content: center; gap: 5px; }
        .commission-cell input { width: 60px; text-align: right; }
	</style>
    <script>
        function updateCommission(seller_id) {
            const inputElement = document.getElementById('commission_' + seller_id);
            const newRate = inputElement.value;

            if (newRate === '' || isNaN(newRate) || newRate < 0) {
                alert("올바른 수수료율을 입력해주세요.");
                return;
            }

            if (!confirm(newRate + "%로 수수료율을 변경하시겠습니까?")) {
                return;
            }

            $.ajax({
                type: "post",
                url: "${contextPath}/account/updateCommission.do", // 이 URL을 처리할 컨트롤러 메소드가 필요합니다.
                data: {
                    seller_id: seller_id,
                    commission_rate: newRate
                },
                success: function(data) {
                    if (data.trim() === 'success') {
                        alert("수수료율이 성공적으로 변경되었습니다.");
                        location.reload(); // 변경사항을 반영하기 위해 페이지 새로고침
                    } else {
                        alert("변경에 실패했습니다. 다시 시도해주세요.");
                    }
                },
                error: function() {
                    alert("오류가 발생했습니다.");
                }
            });
        }
    </script>
</head>
<body>
	<div class="container text-center mt-3 mb-3">
	  	<div class="row row-cols-1 mb-3">
			<div class="col bg-light p-5 text-start">
				<h2 class="fw-bold">회계 관리 대시보드</h2>
				<p class="text-muted">전체 상점의 매출 순위를 확인합니다.</p>
			</div>
		</div>
		<%-- 관리자 공통 메뉴 부분 --%>
		 <div class="row seller_menu">
			<ul>	
				<li><a href="${contextPath}/admin/goods/addNewGoodsForm.do">상품등록</a></li>
				<li><a href="${contextPath}/admin/goods/adminGoodsMain.do">상품관리</a></li>
				<li><a href="${contextPath}/admin/order/adminOrderMain.do">주문/배송관리</a></li>							
				<li><a href="${contextPath}/admin/member/adminMemberMain.do">회원관리</a></li>
				<li><a href="${contextPath}/admin/accounting/main.do">회계관리</a></li>
		
				<li><a href="${contextPath}/business/admin/pensionList.do">펜션관리</a></li>
				<li><a href="${contextPath}/reservation/adminPensionCheck.do">예약관리</a></li>	
			</ul>
		</div>

		<div class="accounting-container">
			<div class="date-selector">
				<div class="btn-group" role="group">
					<button type="button" class="btn btn-outline-secondary">오늘</button>
					<button type="button" class="btn btn-outline-secondary">최근 7일</button>
					<button type="button" class="btn btn-outline-secondary">이번 달</button>
				</div>
				<input type="date" class="form-control" style="width: 180px;">
				<span class="mx-2">~</span>
				<input type="date" class="form-control" style="width: 180px;">
				<button type="button" class="btn btn-primary ms-2">조회</button>
			</div>

			<div class="table-container">
				<div class="section-header">
					<h5>상점별 매출 순위</h5>
				</div>
				<table class="table table-hover">
					<thead>
						<tr>
							<th>순위</th>
							<th style="text-align: left;">상점명</th>
							<th>매출</th>
							<th>건수</th>
							<th>수수료 (%)</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="store" items="${storeRankingList}" varStatus="loop">
							<tr>
								<td><h4>${loop.count}</h4></td>
								<td class="store-name">
									<a href="${contextPath}/account/accountDetail.do?seller_id=${store.seller_id}">
                                        <strong>${store.business_name}</strong>
                                    </a>
                                </td>
								<td class="net-sales"><fmt:formatNumber value="${store.netSales}" pattern="#,###" />원</td>
                                <td>${store.orderCount}건</td>
								<td>
                                    <div class="commission-cell">
                                        <input type="number" class="form-control form-control-sm" id="commission_${store.seller_id}" value="${store.commission_rate}" step="0.1">
                                        <button class="btn btn-sm btn-secondary" onclick="updateCommission('${store.seller_id}')">수정</button>
                                    </div>
								</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</body>
</html>
