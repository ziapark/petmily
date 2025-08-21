<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />

<!DOCTYPE html >
<html>
<head>
	<meta charset="utf-8">
	<script>
		function search_order_history(fixedSearchPeriod){
			var formObj=document.createElement("form");
			var i_fixedSearch_period = document.createElement("input");
			i_fixedSearch_period.name="fixedSearchPeriod";
			i_fixedSearch_period.value=fixedSearchPeriod;
    		formObj.appendChild(i_fixedSearch_period);
    		document.body.appendChild(formObj); 
    		formObj.method="get";
    		formObj.action="${contextPath}/mypage/listMyOrderHistory.do";
    		formObj.submit();
		}

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
				<h2 class="fw-bold">주문내역</h2>
			</div>
		</div>
	    <div class="row seller_menu">
			<ul>	
				<li><a href="${contextPath}/mypage/myDetailInfo.do">내 정보</a></li>
				<li><a href="${contextPath}/mypage/myPetInfo.do">나의 반려동물</a></li>
				<li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문/배송 조회</a></li>
				<li><a href="${contextPath}/reservation/myReservations.do">예약확인</a></li>				
				<li><a href="${contextPath}/mypage/myReview.do">나의 리뷰</a></li>
				<li><a href="${contextPath}/mypage/likeGoods.do">나의 관심상품</a></li>				
				<li><a href="${contextPath}/mypage/deleteForm.do">회원탈퇴</a></li>
			</ul>
		</div>
		<form  method="post">
			<table class="table">
				<tbody>
					<tr>
						<td>
							<input type="radio" name="simple"  checked/> 간단조회 &nbsp;&nbsp;&nbsp;
							<input type="radio" name="simple" /> 일간  &nbsp;&nbsp;&nbsp;
							<input type="radio" name="simple" /> 월간
						</td>
					</tr>
					<tr>
						<td>
					  		<select name="curYear">
					    		<c:forEach var="i" begin="0" end="5" >
					      			<c:choose>
					        			<c:when test="${endYear==endYear-i }">
					          				<option value="${endYear}" selected>${endYear}</option>
					        			</c:when>
					        			<c:otherwise>
					         	 			<option value="${endYear-i }">${endYear-i }</option>
					        			</c:otherwise>
					      			</c:choose>
					    		</c:forEach>
							</select>년
							<select name="curMonth" >
						 		<c:forEach var="i" begin="1" end="12">
						      		<c:choose>
						        		<c:when test="${endMonth==i }">
						          			<option value="${i }"  selected>${i }</option>
						        		</c:when>
						        		<c:otherwise>
						          			<option value="${i }">${i }</option>
						        		</c:otherwise>
						      		</c:choose>
						    	</c:forEach>					
							</select>월					
					 		<select name="curDay">
					  			<c:forEach var="i" begin="1" end="31">
					      			<c:choose>
					        			<c:when test="${endDay==i }">
					          				<option value="${i }"  selected>${i }</option>
					        			</c:when>
					        			<c:otherwise>
					          				<option value="${i }">${i }</option>
					        			</c:otherwise>
					      			</c:choose>
					    		</c:forEach>	
							</select>일  &nbsp;이전&nbsp;&nbsp;&nbsp;&nbsp; 
							<a href="javascript:search_order_history('today')">
					   			<img src="${contextPath}/resources/image/btn_search_one_day.jpg">
							</a>
							<a href="javascript:search_order_history('one_week')">
					   			<img src="${contextPath}/resources/image/btn_search_1_week.jpg">
							</a>
							<a href="javascript:search_order_history('two_week')">
					   			<img src="${contextPath}/resources/image/btn_search_2_week.jpg">
							</a>
							<a href="javascript:search_order_history('one_month')">
					   			<img src="${contextPath}/resources/image/btn_search_1_month.jpg">
							</a>
							<a href="javascript:search_order_history('two_month')">
					   			<img src="${contextPath}/resources/image/btn_search_2_month.jpg">
							</a>
							<a href="javascript:search_order_history('three_month')">
					   			<img src="${contextPath}/resources/image/btn_search_3_month.jpg">
							</a>
							<a href="javascript:search_order_history('four_month')">
					   			<img src="${contextPath}/resources/image/btn_search_4_month.jpg">
							</a>
							&nbsp;까지 조회
						</td>
					</tr>
					<tr>
				  		<td>
				    		<select name="search_condition">
								<option value="2015" checked>전체</option>
								<option value="2014">수령자</option>
								<option value="2013">주문자</option>
								<option value="2012">주문번호</option>
							</select>
							<input type="text"  size="30" />  
							<input type="button"  value="조회"/>
				  		</td>
					</tr>
					<tr>
				  		<td>
							조회한 기간:<input  type="text"  size="4" value="${beginYear}" />년
							<input  type="text"  size="4" value="${beginMonth}"/>월	
							<input  type="text"  size="4" value="${beginDay}"/>일	
							&nbsp; ~
							<input  type="text"  size="4" value="${endYear}" />년 
							<input  type="text"  size="4" value="${endMonth}"/>월	
							<input  type="text"  size="4" value="${endDay}"/>일							 
				  		</td>
					</tr>
				</tbody>
			</table>
		</form>	
		<div class="clear"></div>
		<table class="table">
			<tbody align=center >
				<tr style="background:#33ff00" >
					<td class="fixed" >주문번호</td>
					<td class="fixed">주문일자</td>
					<td>주문내역</td>
					<td>주문금액/수량</td>
					<td>주문상태</td>
					<td>수령자</td>
					<td>리뷰</td>
					<td>주문취소</td>
				</tr>
   				<c:choose>
     				<c:when test="${empty myOrderHistList }">			
						<tr>
		       				<td colspan=8 class="fixed">
				  				<strong>주문한 상품이 없습니다.</strong>
			   				</td>
		     			</tr>
	 				</c:when>
	 				<c:otherwise>
	 					<c:set var="pre_order_id" value="" />
						<c:set var="orderTotalAmount" value="0" />
						<c:set var="orderTotalQty" value="0" />	
     					<c:forEach var="item" items="${myOrderHistList}" varStatus="i">
     					    <c:if test="${item.order_id != pre_order_id and not empty pre_order_id}">
                    			<%-- 이전 주문의 합계를 출력 --%>
                    			<tr style="background:#e0e0e0">
                        			<td colspan="3" align="right"><strong>주문 합계</strong></td>
                        			<td><strong><fmt:formatNumber value="${currentOrderAmount}" type="number" />원 / ${currentOrderQty}개</strong></td>
                        			<td colspan="4"></td>
                    			</tr>
                    			<%-- 다음 주문을 위해 합계 변수 초기화 --%>
                   	 			<c:set var="currentOrderAmount" value="0" />
                    			<c:set var="currentOrderQty" value="0" />
                			</c:if>
        					<c:choose>
          						<c:when test="${item.order_id != pre_order_id }">   
            						<tr>       
										<td>${item.order_id}</td>
										<td><strong>${item.order_time }</strong></td>
										<td><strong>
					   						<c:forEach var="item2" items="${myOrderHistList}" varStatus="j">
				          						<c:if test="${item.order_id ==item2.order_id}" >
				            						<a href="${contextPath}/goods/goodsDetail.do?goods_num=${item2.goods_num }">${item2.goods_name }</a><br>
				         						</c:if>   
					 						</c:forEach>
					 					</strong></td>
										<td><strong>
									    	<c:forEach var="item2" items="${myOrderHistList}" varStatus="j">
									         	<c:if test="${item.order_id ==item2.order_id}" >
									            	${item.goods_sales_price*item.goods_qty }원/${item.goods_qty }개<br>
									            	<c:set var="totalAmount" value="${totalAmount + (item.goods_sales_price * item.goods_qty)}" />
													<c:set var="totalQty" value="${totalQty + item.goods_qty}" />
									         	</c:if>   
										 	</c:forEach>
				   						</strong></td>
										<td><strong>
				    						<c:choose>
					    						<c:when test="${item.delivery_state=='delivery_prepared' }">배송준비중</c:when>
					    						<c:when test="${item.delivery_state=='delivering' }">배송중</c:when>
											    <c:when test="${item.delivery_state=='finished_delivering' }">배송완료</c:when>
											    <c:when test="${item.delivery_state=='finished' }">구매확정</c:when>
											    <c:when test="${item.delivery_state=='cancel_order' }">주문취소</c:when>
											    <c:when test="${item.delivery_state=='returning_goods' }">반품</c:when>
				  							</c:choose>
				  						</strong></td>
										<td><strong>${item.receiver_name }</strong></td>
										<td>
				    						<c:choose>
				    							<c:when test="${item.delivery_state=='finished' }">
				    								<c:choose>
						         						<c:when test="${item.hasReview}">
						            						<a href="${contextPath}/mypage/myReview.do?goods_num=${item.goods_num}">
						                						<strong>리뷰보기</strong>
						            						</a>
						        						</c:when>
						        					<c:otherwise>
						            					<a href="${contextPath}/mypage/writeReviewForm.do?order_num=${item.order_id}&goods_name=${item.goods_name}">
						                					<strong>리뷰쓰기</strong>
						            					</a>
						        					</c:otherwise>
						       					</c:choose>
						  					</c:when>
											<c:otherwise>
												<strong>리뷰쓰기</strong>
											</c:otherwise>
									    </c:choose>
									</td>
									<td>
								    	<c:choose>
								   			<c:when test="${item.delivery_state=='delivery_prepared'}">
								       			<input  type="button" onClick="fn_cancel_order('${item.order_id}')" value="주문취소"  />
								  		 	</c:when>
								   			<c:when test="${item.delivery_state=='finished_delivering' }">
										 		<input  type="button" onClick="fn_exchange_order('${item.order_id}')" value="반품" />
											</c:when>
											<c:when test="${item.delivery_state=='finished' }">
										 		<input  type="button" onClick="fn_finish_order('${item.order_id}')" value="구매확정" />
											</c:when>
											<c:when test="${item.delivery_state=='delivering' }">
										  		배송중
											</c:when>
											<c:when test="${item.delivery_state=='cancel_order' }">
										  		주문취소
											</c:when>
											<c:when test="${item.delivery_state=='returning_goods' }">
										  		반품
											</c:when>
								  		</c:choose>
								    </td>
								</tr>
							</c:when>
						</c:choose>
		                <c:set var="currentOrderAmount" value="${currentOrderAmount + (item.goods_sales_price * item.goods_qty)}" />
		                <c:set var="currentOrderQty" value="${currentOrderQty + item.goods_qty}" />
		                <c:set var="pre_order_id" value="${item.order_id}" />

		                <c:if test="${i.last}">
		                    <tr style="background:#e0e0e0">
		                        <td colspan="3" align="right"><strong>주문 합계</strong></td>
		                        <td><strong><fmt:formatNumber value="${currentOrderAmount}" type="number" />원 / ${currentOrderQty}개</strong></td>
		                        <td colspan="4"></td>
		                    </tr>
		                </c:if>
					</c:forEach>
				</c:otherwise>
			</c:choose>			   
		</tbody>
	</table>
	<div class="clear"></div>
</div>
</body>
</html>