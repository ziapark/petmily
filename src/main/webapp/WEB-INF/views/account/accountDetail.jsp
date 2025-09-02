<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />

<html>
<head>
	<meta charset="utf-8">
	<title>${summary.storeName} - 상세 회계</title>
	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<style>
		.accounting-container { padding: 20px; background-color: #f9f9f9; }
		.section-header { margin-bottom: 20px; padding-bottom: 10px; border-bottom: 2px solid #eee; }
		.section-header h2, .section-header h5 { font-weight: bold; color: #333; }
		.section-header h5 { margin-bottom: 0; }
		.section-header .info-text { font-size: 0.8rem; color: #888; margin-top: 4px; }
		.date-selector { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
		.summary-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 20px; margin-bottom: 30px; }
		.summary-card { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); text-align: left; }
		.summary-card h3 { font-size: 0.9rem; color: #666; margin-bottom: 10px; font-weight: bold; }
		.summary-card .amount { font-size: 1.5rem; font-weight: bold; color: #333; }
		.summary-card .amount.net-sales { color: #007bff; }
		.summary-card .amount.estimated-settlement { color: #28a745; }
		
		/* [수정] details-section을 2단 그리드 레이아웃으로 변경합니다. */
		.details-section { display: grid; grid-template-columns: 2fr 1fr; gap: 20px; }
		/* [추가] 왼쪽 컬럼의 아이템들을 세로로 쌓기 위한 스타일 */
		.left-column { display: flex; flex-direction: column; gap: 20px; }

		.chart-container, .table-container { background-color: #fff; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
		.chart-container { height: 400px; display: flex; flex-direction: column; }
		.table th, .table td { vertical-align: middle; font-size: 0.9rem; }
        .table .amount-plus { color: blue; }
        .table .amount-minus { color: red; }
		.chart-wrapper { position: relative; flex-grow: 1; }
		.settlement-info-table th { width: 150px; text-align: left; background-color: #fafafa; }
		.settlement-info-table td { text-align: left; }
	</style>
</head>
<body>
	<div class="container text-center mt-3 mb-3">
	  	<div class="row row-cols-1 mb-3">
			<div class="col bg-light p-5 text-start">
				<h2 class="fw-bold">${summary.business_name} 상세 회계</h2>
				<p class="text-muted">상세 매출 현황을 확인합니다</p>
			</div>
		</div>
		<%-- 관리자 공통 메뉴 부분 --%>
		 <div class="row seller_menu">
			<c:choose>
				<c:when test="${isLogOn==true and memberInfo.member_id =='admin' }">
					<ul>	
						<li><a href="${contextPath}/admin/goods/addNewGoodsForm.do">상품등록</a></li>
						<li><a href="${contextPath}/admin/goods/adminGoodsMain.do">상품관리</a></li>
						<li><a href="${contextPath}/admin/order/adminOrderMain.do">주문/배송관리</a></li>
						<li><a href="${contextPath}/business/admin/pensionList.do">펜션관리</a></li>
						<li><a href="${contextPath}/reservation/adminPensionCheck.do">예약관리</a></li>								
						<li><a href="${contextPath}/admin/member/adminMemberMain.do">회원관리</a></li>
						<li><a href="${contextPath}/account/accountMain.do">회계관리</a></li>
					</ul>
				</c:when>
				<c:otherwise>
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
				</c:otherwise>
			</c:choose>
		</div>
	
		<div class="accounting-container">
			<form name="frm_search" method="get" action="${contextPath}/account/accountDetail.do">
				<div class="date-selector">
					<input type="hidden" name="seller_id" value="${not empty param.sellerId ? param.sellerId : param.seller_id}" />
					<input type="month" name="selectedMonth" class="form-control" style="width: 200px;" value="${selectedMonth}">
					<button type="submit" class="btn btn-primary ms-2">조회</button>
					<c:choose>
						<c:when test="${isLogOn==true and memberInfo.member_id =='admin' }">
							<a href="${contextPath}/account/accountMain.do" class="btn btn-secondary ms-auto">목록으로</a>
						</c:when>
					</c:choose>
				</div>
			</form>

			<div class="summary-cards">
				<div class="summary-card">
					<h3>총 매출</h3>
					<p class="amount"><fmt:formatNumber value="${summary.totalSales}" pattern="#,###" />원</p>
				</div>
				<div class="summary-card">
					<h3>사용된 포인트</h3>
					<p class="amount"><fmt:formatNumber value="${summary.usedPoints}" pattern="#,###" /> P</p>
				</div>
				<div class="summary-card">
					<h3>순 매출</h3>
					<p class="amount net-sales"><fmt:formatNumber value="${summary.netSales}" pattern="#,###" />원</p>
				</div>
				<div class="summary-card">
					<h3>총 주문 건수</h3>
					<p class="amount">${summary.orderCount}건</p>
				</div>
                <div class="summary-card">
					<h3>예상 정산액 (${summary.commission_rate}%)</h3>
					<c:set var="estimatedSettlement" value="${summary.netSales * (1 - (summary.commission_rate / 100))}" />
					<p class="amount estimated-settlement"><fmt:formatNumber value="${estimatedSettlement}" pattern="#,###" />원</p>
				</div>
			</div>

			<div class="details-section">
				<div class="left-column">
					<div class="table-container">
						<div class="section-header">
							<h5>정산 계좌 정보</h5>
						</div>
						<table class="table settlement-info-table">
							<tbody>
								<tr>
									<th>은행명</th>
									<td>${summary.bank_name}</td>
								</tr>
								<tr>
									<th>계좌번호</th>
									<td>${summary.bank_account}</td>
								</tr>
								<tr>
									<th>예금주</th>
									<td>${summary.bank_holder}</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="chart-container">
						<div class="section-header">
							<h5>월별 매출 추이</h5>
							<p class="info-text">※ 매출 추이 그래프는 '구매확정' 및 '취소'된 주문 건을 기준으로 집계됩니다.</p>
						</div>
						<div class="chart-wrapper">
							<canvas id="salesChart"></canvas>
						</div>
					</div>
				</div>

				<div class="table-container">
					<div class="section-header">
						<h5>최신 거래 내역</h5>
					</div>
					<table class="table">
						<thead>
							<tr>
								<th>주문일시</th>
								<th>주문번호</th>
								<th>결제금액</th>
								<th>상태</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="tx" items="${transactionList}">
								<tr>
									<td>${tx.date}</td>
									<td>${tx.order_id}</td>
									<td class="${tx.status == 'cancelled' ? 'amount-minus' : 'amount-plus'}">
										<fmt:formatNumber value="${tx.amount}" pattern="#,###" />원
									</td>
									<td>
									<c:choose>
										<c:when test="${tx.delivery_state=='delivery_prepared' }">배송준비</c:when>									
										<c:when test="${tx.delivery_state=='delivering' }">배송중</c:when>									
										<c:when test="${tx.delivery_state=='finished_delivering' }">배송완료</c:when>
										<c:when test="${tx.delivery_state=='finished' }">구매확정</c:when>									
										<c:when test="${tx.delivery_state=='cancel_order' }">주문취소</c:when>										
										<c:when test="${tx.delivery_state=='returning_goods' }">반품</c:when>								
									</c:choose>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>

			</div>
		</div>
	</div>

	<script>
		document.addEventListener("DOMContentLoaded", function() {
			const ctx = document.getElementById('salesChart').getContext('2d');
			
			const chartLabels = [];
			const chartData = [];
			<c:forEach var="sale" items="${dailySalesList}">
				chartLabels.push("${sale.date}일");
				chartData.push(${sale.netSales});
			</c:forEach>

			const salesChart = new Chart(ctx, {
				type: 'line',
				data: {
					labels: chartLabels,
					datasets: [{
						label: '일별 순 매출 (원)',
						data: chartData,
						backgroundColor: 'rgba(0, 123, 255, 0.2)',
						borderColor: 'rgba(0, 123, 255, 1)',
						borderWidth: 2,
						tension: 0.3
					}]
				},
				options: {
					scales: {
						y: {
							beginAtZero: true,
							ticks: {
								callback: function(value, index, values) {
									return value.toLocaleString() + '원';
								}
							}
						}
					},
					responsive: true,
					maintainAspectRatio: false
				}
			});
		});
	</script>
</body>
</html>

