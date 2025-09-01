<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html >
<html>
<head>
<meta charset="utf-8">
<title>관리자 펜션 등록</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
        <div class="col bg-light p-5 text-start">
            <h2 class="fw-bold">관리자 펜션 등록</h2>
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
<form name="frm_add_pension_admin" action="${contextPath}/business/addpension.do" method="post">
	<div>
		<table class="table table-bordered align-middle">
		  <tbody>
		    <!-- [추가] 관리자가 사업자를 선택하는 드롭다운 메뉴 -->
		    <tr>
		      <td class="fw-bold" style="width:150px;">사업자 선택</td>
		      <td colspan="2">
		        <select class="form-select w-50" name="business_id" required>
		            <option value="" selected disabled>펜션을 등록할 사업자를 선택하세요</option>
		            <c:forEach var="business" items="${businessList}"> <%-- 컨트롤러에서 businessList를 전달해야 합니다. --%>
		                <option value="${business.business_id}">${business.business_name} (${business.seller_id})</option>
		            </c:forEach>
		        </select>
		      </td>
		    </tr>
		    
		    <tr>
		      <td class="fw-bold" style="width:150px;">펜션명</td>
		      <td colspan="2">
		        <input type="text" class="form-control w-50" name="p_name" required />
		      </td>
		    </tr>
		
		    <tr>
		      <td class="fw-bold">펜션 전화번호</td>
		      <td colspan="2" class="d-flex gap-2 align-items-center">
		        <input type="text" class="form-control w-25" name="tel1" id="tel1" maxlength="3">
		        <span>-</span>
		        <input type="text" class="form-control w-25" name="tel2" id="tel2" maxlength="4">
		        <span>-</span>
		        <input type="text" class="form-control w-25" name="tel3" id="tel3" maxlength="4">
		      </td>
		    </tr>
		
		    <tr>
		      <td class="fw-bold">체크인 시간</td>
		      <td colspan="2">
		        <input type="time" class="form-control w-25" name="checkin_time" id="checkin_time" required>
		      </td>
		    </tr>
		
		    <tr>
		      <td class="fw-bold">체크아웃 시간</td>
		      <td colspan="2">
		        <input type="time" class="form-control w-25" name="checkout_time" id="checkout_time" required>
		      </td>
		    </tr>
		
		    <tr>
		      <td class="fw-bold">보유 객실 수</td>
		      <td colspan="2">
		        <input type="number" class="form-control w-25" id="room_count" name="room_count" min="1" required>
		      </td>
		    </tr>
		
		    <tr>
		      <td class="fw-bold">시설 정보</td>
		      <td colspan="2">
		        <input type="text" class="form-control" id="facilities" name="facilities" placeholder="예: 수영장, 바베큐, 주차장">
		      </td>
		    </tr>
		
		    <tr>
		      <td class="fw-bold">펜션 설명</td>
		      <td colspan="2">
		        <textarea class="form-control" id="description" name="description" rows="4"></textarea>
		      </td>
		    </tr>
		  </tbody>
		</table>

		</div>
		<div class="d-flex justify-content-center gap-2 mt-4">
			<button type="submit" class="btn btn-primary">등록하기</button>
			<button type="reset" class="btn btn-secondary">다시 입력</button>
		</div>
</form>	
</div>

</body>
</html>
