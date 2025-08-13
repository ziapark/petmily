<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>	 
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
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
			<h2 class="fw-bold">마이페이지 </h2>
		</div>
	</div>
	<div class="mypage_wrap"> 
	<div class="side_menu">
		<ul>	
			<li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문내역/배송 조회</a></li>
			<li><a href="${contextPath}/mypage/myReview.do">마이리뷰</a></li>
			<li><a href="${contextPath}/mypage/likeGoods.do">나의 관심상품</a></li>
			<li><a href="${contextPath}/mypage/myDetailInfo.do">회원정보관리</a></li>
			<li><a href="${contextPath}/mypage/deleteForm.do">회원탈퇴</a></li>
		</ul>
	</div>
	<div class="mypage_content">
		<h3 style="text-align:left;">최근주문내역
		    <A href="#"> <IMG  src="${contextPath}/resources/image/btn_more_see.jpg"></A> 
		</h3>
		<table class="table">
				<tbody align=center >
					<tr style="background:#33ff00">
						<td>주문번호</td>
						<td>주문일자</td>
						<td>주문상품</td>
						<td>주문상태</td>
						<td>주문취소</td>
					</tr>
		      <c:choose>
		         <c:when test="${empty myOrderList}">
				  <tr>
				    <td colspan=5 class="fixed">
						  <strong>주문한 상품이 없습니다.</strong>
				    </td>
				  </tr>
		        </c:when>
		        <c:otherwise>
			      <c:forEach var="item" items="${myOrderList }"  varStatus="i">
			       <c:choose> 
		              <c:when test="${order_id == item.order_id}">
		                <c:choose>
			              <c:when test="${item.delivery_state=='delivery_prepared' }">
			                <tr  bgcolor="lightgreen">    
			              </c:when>
			              <c:when test="${item.delivery_state=='finished_delivering' }">
			                <tr  bgcolor="lightgray">    
			              </c:when>
			              <c:otherwise>
			                <tr  bgcolor="orange">   
			              </c:otherwise>
			            </c:choose> 
		            <tr>
		             <td>
				       <a href="${contextPath}/mypage/myOrderDetail.do?order_id=${item.order_id }"><span>${item.order_id }</span>  </a>
				     </td>
				    <td><span>${item.pay_order_time }</span></td>
					<td align="left">
					   <strong>
					      <c:forEach var="item2" items="${myOrderList}" varStatus="j">
					          <c:if  test="${item.order_id ==item2.order_id}" >
					            <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item2.goods_num }">${item2.goods_name }/${item.goods_qty}개</a><br>
					         </c:if>   
						 </c:forEach>
						</strong></td>
					<td>
					  <c:choose>
					    <c:when test="${item.delivery_state=='delivery_prepared' }">
					       배송준비중
					    </c:when>
					    <c:when test="${item.delivery_state=='delivering' }">
					       배송중
					    </c:when>
					    <c:when test="${item.delivery_state=='finished_delivering' }">
					       배송완료
					    </c:when>
					    <c:when test="${item.delivery_state=='cancel_order' }">
					       주문취소
					    </c:when>
					    <c:when test="${item.delivery_state=='returning_goods' }">
					       반품완료
					    </c:when>
					  </c:choose>
					</td>
					<td>
					  <c:choose>
					   <c:when test="${item.delivery_state=='delivery_prepared'}">
					       <input  type="button" onClick="fn_cancel_order('${item.order_id}')" value="주문취소"  />
					   </c:when>
					   <c:otherwise>
					      <input  type="button" onClick="fn_cancel_order('${item.order_id}')" value="주문취소" />
					   </c:otherwise>
					  </c:choose>
					</td>
					</tr>
		          <c:set  var="pre_order_id" value="${item.order_id}" />
		           </c:when>
		      </c:choose>
			   </c:forEach>
			  </c:otherwise>
		    </c:choose> 	    
		</tbody>
		</table>
		
		<br><br><br>	
		<h3 style="text-align:left;">계좌내역
		    <a href="#"> <img  src="${contextPath}/resources/image/btn_more_see.jpg" />  </a>
		</h3>
		<table class="table">
		  <tr>

		    <td>
			   포인트 &nbsp;&nbsp; <strong>2000원</strong>
		   </td>
		   </tr>
		   
		</table>
		
		<br><br><br>	
		<h3 style="text-align:left;">나의 정보
		    <a href="#"> <img  src="${contextPath}/resources/image/btn_more_see.jpg" />  </a>
		</h3>
		
		<table class="table">
		<c:if test="${not empty sessionScope.memberInfo}">
		  <tr>
		    <td>
			   이메일:
		   </td>
		    <td>
			   <strong>${sessionScope.memberInfo.email1 }@${sessionScope.memberInfo.email2}</strong>
		   </td>
		   </tr>
		   <tr>
		    <td>
			   전화번호 
		   </td>
		    <td>
			   <strong>${sessionScope.memberInfo.tel1 }-${sessionScope.memberInfo.tel2}-${sessionScope.memberInfo.tel3 }</strong>
		   </td>
		   </tr>
		   <tr>
		    <td>
			  주소 
		   </td>
		    <td>
				도로명:  &nbsp;&nbsp; <strong>${sessionScope.memberInfo.roadAddress }</strong>  <br>
				지번:   &nbsp;&nbsp; <strong>${sessionScope.memberInfo.jibunAddress }</strong> 
		   </td>
		   </tr>
		   </c:if>
		</table>
	</div>
</div>
</div>
</body>
</html>
