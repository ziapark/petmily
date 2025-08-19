<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html >
<html>
<head>
<meta charset="utf-8">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>

</head>
<body>
<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
        <div class="col bg-light p-5 text-start">
            <h2 class="fw-bold">업체등록</h2>
        </div>
    </div>
    
   	<div class="row seller_menu">
		<ul>	
			<li><a href="${contextPath}/business/mypension.do?business_id=${business_id}">펜션예약정보</a></li>
			<li><a href="${contextPath}/business/addpensionForm.do">업체 등록</a></li>
			<li><a href="${contextPath}/reservation/reservation_check.do">예약 확인</a></li>
			<li><a href="${contextPath}/business/businessDetailInfo.do">사업자 정보관리</a></li>
			<li><a href="${contextPath}/business/businessGoodsMain.do">상품관리</a></li>
			<li><a href="${contextPath}/business/addNewGoodsForm.do">상품등록</a></li>
			<li><a href="${contextPath}/mypage/myDetailInfo.do">회원정보관리</a></li>
			<li><a href="${contextPath}/mypage/deleteForm.do">회원탈퇴</a></li>
		</ul>
	</div>
<form name="frm_mod_business" action="${contextPath}/business/addpension.do" method="post">
	<input type="hidden" name="business_id" id="business_id" value="${sessionScope.businessInfo.business_id}"/>
	<div id="">
		<table class="table table-bordered align-middle">
		  <tbody>
		    <tr>
		      <td class="fw-bold" style="width:150px;">업체명</td>
		      <td colspan="2">
		        <input type="text" class="form-control w-50" name="p_name" />
		      </td>
		    </tr>
		
		    <tr>
		      <td class="fw-bold">업체 전화번호</td>
		      <td colspan="2" class="d-flex gap-2 align-items-center">
		        <input type="text" class="form-control w-25" name="tel1" id="tel1">
		        <span>-</span>
		        <input type="text" class="form-control w-25" name="tel2" id="tel2">
		        <span>-</span>
		        <input type="text" class="form-control w-25" name="tel3" id="tel3">
		      </td>
		    </tr>
		
		    <tr>
		      <td class="fw-bold">체크인 시간</td>
		      <td colspan="2">
		        <input type="time" class="form-control w-25" name="checkin_time" id="checkin_time">
		      </td>
		    </tr>
		
		    <tr>
		      <td class="fw-bold">체크아웃 시간</td>
		      <td colspan="2">
		        <input type="time" class="form-control w-25" name="checkout_time" id="checkout_time">
		      </td>
		    </tr>
		
		    <tr>
		      <td class="fw-bold">보유 객실 수</td>
		      <td colspan="2">
		        <input type="text" class="form-control w-25" id="room_count" name="room_count">
		      </td>
		    </tr>
		
		    <tr>
		      <td class="fw-bold">시설 정보</td>
		      <td colspan="2">
		        <input type="text" class="form-control" id="facilities" name="facilities">
		      </td>
		    </tr>
		
		    <tr>
		      <td class="fw-bold">펜션 설명</td>
		      <td colspan="2">
		        <input type="text" class="form-control" id="description" name="description">
		      </td>
		    </tr>
		  </tbody>
		</table>

		</div>
		<div class="clear">
		<br><br>
		<table align=center>
		<tr>
			<td >
				<input name="btn_cancel_business" type="submit"  value="등록하기">
				<input name="btn_cancel_business" type="reset" value="다시 입력">
			</td>
		</tr>
	</table>
	</div>
</form>	
</div>

</body>
</html>
