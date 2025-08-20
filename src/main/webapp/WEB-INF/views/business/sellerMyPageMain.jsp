<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>	 
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<c:if test="${message=='cancel_order'}">
		<script>
			window.onload=function()
			{
		  		init();
			}
		
			function init(){
				alert("주문을 취소했습니다.");
			}
		</script>
	</c:if>
	<script>
		function fn_cancel_order(order_id){
			var answer=confirm("주문을 취소하시겠습니까?");
			if(answer==true){
				var formObj=document.createElement("form");
				var i_order_id = document.createElement("input"); 
	    
	    		i_order_id.name="order_id";
	    		i_order_id.value=order_id;
		
	    		formObj.appendChild(i_order_id);
	    		document.body.appendChild(formObj); 
	    		formObj.method="post";
	    		formObj.action="${contextPath}/mypage/cancelMyOrder.do";
	    		formObj.submit();	
			}
		}
	</script>
</head>
<body>
<div class="container text-center mt-3 mb-3">
    <div class="row row-cols-1 mb-3">
        <div class="col bg-light p-5 text-start">
            <h2 class="fw-bold">사업자 마이페이지 메인</h2>
        </div>
    </div>
	<div class="seller_menu">
		<ul>	
			<li><a href="${contextPath}/business/mypension.do?business_id=${business_id}">펜션예약정보</a></li>
			<li><a href="${contextPath}/business/addpensionForm.do">업체 등록</a></li>
			<li><a href="${contextPath}/reservation/reservation_check.do">예약 확인</a></li>
			<li><a href="${contextPath}/business/businessDetailInfo.do">사업자 정보관리</a></li>
			<li><a href="${contextPath}/business/businessGoodsMain.do">상품관리</a></li>
			<li><a href="${contextPath}/business/addNewGoodsForm.do">상품등록</a></li>
			<li><a href="${contextPath}/mypage/myDetailInfo.do">회원정보관리</a></li>
			<li><a href="${contextPath}/business/deleteForm.do">회원탈퇴</a></li>
		</ul>
	</div>
	
</div>
</body>
</html>
