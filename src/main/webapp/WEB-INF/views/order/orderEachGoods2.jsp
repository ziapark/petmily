<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
</head>
	<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
	<script>
		function execDaumPostcode() {
  			new daum.Postcode({
    			oncomplete: function(data) {
      				var fullRoadAddr = data.roadAddress;
      				var extraRoadAddr = '';
      				if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
        				extraRoadAddr += data.bname;
      				}
      				if (data.buildingName !== '' && data.apartment === 'Y') {
        				extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
      				}
      				if (extraRoadAddr !== '') {
        				extraRoadAddr = ' (' + extraRoadAddr + ')';
      				}
      				if (fullRoadAddr !== '') {
        				fullRoadAddr += extraRoadAddr;
      				}
				    document.getElementById('zipcode').value = data.zonecode;
				    document.getElementById('roadAddress').value = fullRoadAddr;
				    document.getElementById('jibunAddress').value = data.jibunAddress;
				    if (data.autoRoadAddress) {
        				var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
        				document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
      				} else if (data.autoJibunAddress) {
        				var expJibunAddr = data.autoJibunAddress;
        				document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
      				} else {
       	 				document.getElementById('guide').innerHTML = '';
      				}
    			}
  			}).open();
		}

		async function requestCardPayment() {
			console.log("함수 진입");
  			const f = document.forms['form_order'];
  			const orderName = "펫밀리 주문결제";
  			const price = f['total_price'] ? f['total_price'].value : 1000;
  			const or_idx = Number(f?.order_id?.value) > 0 ? f.order_id.value : new Date().getTime();
  			console.log("or_idx:", or_idx);
  			const ctx = "${pageContext.request.contextPath}";

			// 휴대폰 번호 3개 입력값 합치기
			const tel1 = f['tel1']?.value.trim();
			const tel2 = f['tel2']?.value.trim();
			const tel3 = f['tel3']?.value.trim();
			const phoneRaw = [tel1, tel2, tel3].join('');
			// 휴대폰번호 필수 체크 (11자리)
			if (!phoneRaw || phoneRaw.length !== 11 || !/^\d{11}$/.test(phoneRaw)) {
				alert("휴대폰 번호를 정확히 입력해 주세요! (예: 010-1234-5678)");
			    return;
			}
  			console.log("phoneRaw = [" + phoneRaw + "]");
  			// 주소 필수값(도로명 or 지번)
  			const roadAddress = f['roadAddress']?.value.trim();
  			const jibunAddress = f['jibunAddress']?.value.trim();
  			if (!roadAddress && !jibunAddress) {
    			alert("주소를 입력해 주세요!");
    			return;
  			}

  			const data = {
    			or_idx: or_idx,
    			pd_name: orderName,
    			price: price,
    			receiver_name: f['receiver_name']?.value,
    			tel1: tel1,
			    tel2: tel2,
			    tel3: tel3,
			    goods_num: f['goods_num']?.value,
			    goods_name: f['goods_name']?.value,
			    goods_sales_price: f['goods_sales_price']?.value,
			    order_name: f['order_name']?.value,
			    order_num : f['order_num']?.value,
			    zipcode: f['zipcode']?.value,
			    roadAddress: roadAddress,
			    jibunAddress: jibunAddress,
			    namujiAddress: f['namujiAddress']?.value,
			    delivery_message: f['delivery_message']?.value,
			    pay_order_tel: f['pay_order_tel']?.value
  			};
  			const paymentId = `PAYMENT_${Date.now()}_${Math.floor(Math.random() * 1000000)}`;

  			console.log({
	  			name: data.receiver_name,
	  			phone: phoneRaw,
	  			email: "${sessionScope.memberInfo.email1}@${sessionScope.memberInfo.email2}",
	  
	  			address: {
	    			addressLine1: roadAddress || jibunAddress,
	    			addressLine2: data.namujiAddress,
	    			postalCode: data.zipcode
	  			}
			});
  
  			// 결제창 호출 (storeId, channelKey는 네 실제값으로 교체!!)
  			const response = await PortOne.requestPayment({
    			storeId:"store-292f1f91-b8c2-4608-9394-615315d5f811",   // ★교체필수
    			channelKey: "channel-key-16983525-2a28-41f4-b177-b4f8e27769dc", // ★교체필수
    			paymentId: paymentId,
    			orderName: data.pd_name,
    			totalAmount: data.price,
    			currency: "CURRENCY_KRW",
    			payMethod: "CARD",
    			customer: {	
      				fullName: data.receiver_name,
      				phoneNumber: String(phoneRaw), // 11자리 숫자!
      				email: "${sessionScope.memberInfo.email1}@${sessionScope.memberInfo.email2}",
      				address: {
        				addressLine1: roadAddress || jibunAddress,  // 필수(도로명/지번 둘 중 하나라도)
        				addressLine2: data.namujiAddress,           // 상세주소(없으면 빈값)
        				postalCode: data.zipcode                    // 우편번호(없으면 빈값)
      				}
    			}
  			});
  			console.log("💳 [PortOne 결제 응답 전체]", response);
  			alert("[PortOne 결제 응답 전체]\n" + JSON.stringify(response, null, 2));
  			// 결제 실패
  			if (response.code != null) {
    			alert(response.message);
    			return;
  			}
  			// 결제 식별자 추출 (paymentKey, imp_uid, txId 중 실제로 오는 값!)
  			const paymentKey = response.paymentKey || response.imp_uid || response.id || response.txId;
  			const txId = response.txId;
  			if (!paymentKey && !txId) {
	  			alert("결제는 되었지만 paymentKey를 받지 못했습니다. 관리자에게 문의하세요.");
	  			console.error("📛 결제 응답 이상:", response);
	  			return;
			}
  
			//어떤 식별자인지(프론트에서 서버로 함께 전달)
  			let paymentKeyType = "unknown";
  			if (response.paymentKey) paymentKeyType = "paymentKey";
  			else if (response.imp_uid) paymentKeyType = "imp_uid";
  			else if (response.id) paymentKeyType = "id";
  			else if (response.txId) paymentKeyType = "txId";
  
  			// 결제 성공시 서버로 주문/결제 내역 전달
  			try {
  				const res = await fetch("/petmillie/order/payToOrderGoods.do", {
	    			method: "POST",
	    			headers: { "Content-Type": "application/json" },
	    				body: JSON.stringify({
	      				...data,
	      				paymentId: paymentId,
	      				portone_paymentKey: paymentKey,
	      				paymentStatus: response.status
	    			})
  				});
   				const text = await res.text();
  				try {
    				const result = JSON.parse(text);
    				alert(result.message || "주문이 완료되었습니다!");
    				if (result.success) {
      					window.location.href = `${ctx}/order/payComplete.do`;
    				}
  				} catch (e) {
    				console.error("❌ JSON 파싱 실패! 응답 텍스트:", text);
    				alert("서버에서 이상한 응답이 왔어요. 관리자에게 문의해주세요.");
  				}

			} catch (e) {
	  			console.error("❌ fetch 요청 실패:", e);
  				alert("서버와의 통신 중 오류 발생! 결제는 되었을 수 있으니 꼭 확인 부탁드립니다!");
			}
		}
	</script>

<BODY>
	<H1>주문하기</H1>
  	<form name="form_order">
        <c:set var="totalOrderPrice" value="0" />
        <c:set var="totalOrderPoints" value="0" />
        <c:set var="totalDeliveryPrice" value="0" />
        <c:set var="totalGoodsNum" value="0" />
    	
    	<TABLE class="list_view">
      		<TBODY align=center>
        		<tr style="background: #33ff00">
	          		<td>번호</td>
	          		<td>이미지</td>
	          		<td>주문상품</td>
	          		<td>주문금액</td>
	          		<td>수량</td>	          		
	          		<td>배송비</td>
	          		<td>주문금액합계</td>
	          		<td>예상적립금</td>
        		</tr>
        		<c:forEach var="item" items="${myOrderList}" varStatus="loop">
          			<tr>
            			<td>${loop.count}</td>
            			<td class="goods_image">
	              			<a href="${contextPath}/goods/goodsDetail.do?goods_num=${item.goods_num}">
	                			<img width="75" alt="${item.fileName}" src="${contextPath}/download.do?goods_num=${item.goods_num}&fileName=${item.fileName}">
	              			</a>
            			</td>
            			<td>
              				<h2><a href="${contextPath}/goods/goodsDetail.do?goods_num=${item.goods_num}">${item.goods_name}</a></h2>
            			</td>
            			<td>
						    <c:choose>
						        <c:when test="${not empty item.goods_sales_price}">
						            <fmt:formatNumber value="${item.goods_sales_price}" pattern="#,###원" />
						        </c:when>
						        <c:otherwise>
						            0원
						        </c:otherwise>
						    </c:choose>
						</td>
            			<td>${item.goods_qty}개</td>
            			<td><h2>${item.goods_delivery_price}</h2></td>
	            		<td>
						    <c:choose>
						        <c:when test="${not empty item.goods_sales_price}">
						            <fmt:formatNumber value="${item.goods_sales_price * item.goods_qty}" pattern="#,###원" />
						        </c:when>
						        <c:otherwise>
						            0원
						        </c:otherwise>
						    </c:choose>
						</td>
						<td>
						    <c:choose>
						        <c:when test="${not empty item.goods_sales_price and not empty item.point}">
						            <fmt:formatNumber value="${item.goods_qty * item.goods_sales_price * item.point * 0.01}" maxFractionDigits="0"/> P
						        </c:when>
						        <c:otherwise>
						            0 P
						        </c:otherwise>
						    </c:choose>
						</td>
					</tr>			
                    <c:set var="totalOrderPrice" value="${totalOrderPrice + (item.goods_qty * item.goods_sales_price)}" />
                    <c:set var="totalOrderPoints" value="${totalOrderPoints + (item.goods_qty * item.goods_sales_price * item.point * 0.01)}" />
                    <c:set var="totalGoodsNum" value="${totalGoodsNum + 1}" /></c:forEach>
      		</TBODY>
    	</TABLE>
    	<br><br>
    	<table width=80% class="table" style="background: #cacaff">
			<tbody>
				<tr align=center class="fixed">
					<td class="fixed">총 항목 수</td>
					<td>총 상품금액</td>
					<td></td>
					<td>총 배송비</td>
					<td></td>
					<td>최종 결제금액</td>
					<td>최종 적립 포인트</td>
				</tr>
				<tr cellpadding=40 align=center>
					<td>
						<p>${totalGoodsNum}개</p> 
					</td>
					<td>
						<p><fmt:formatNumber value="${totalOrderPrice}" type="number" />원</p> 
					</td>
					<td></td>
					<td>
						<p><fmt:formatNumber value="${totalDeliveryPrice}" type="number" /></p> 
					</td>
					<td></td>
					<td>
						<p><strong><fmt:formatNumber value="${totalOrderPrice + totalDeliveryPrice}" type="number" />원</strong></p> 
					</td>
					<td>
						<p><fmt:formatNumber value="${totalOrderPoints}" type="number" /> P</p>
					</td>
				</tr>
			</tbody>
		</table>
    	<input type="hidden" name="total_price" value="${totalOrderPrice + totalDeliveryPrice}">
	    <DIV class="clear"></DIV>
	    <br><br>
	    <H1>2.배송지 정보</H1>
	    <DIV class="detail_table">
	    	<TABLE>
	        	<TBODY>
	          		<TR class="dot_line">
	            		<TD class="fixed_join">수령인 </TD>
	            		<TD>
	              			<input type="text" name="receiver_name" id="receiver_name" value="${sessionScope.memberInfo.member_name}">
	            		</TD>
	          		</TR>
	          		<TR class="dot_line">
	            		<TD class="fixed_join">수령인 휴대폰번호</TD>
	            		<TD>
	              			<input type="text" size="4" name="tel1" id="tel1" value="${sessionScope.memberInfo.tel1}">-
	              			<input type="text" size="4" name="tel2" id="tel2" value="${sessionScope.memberInfo.tel2}">-
	              			<input type="text" size="4" name="tel3" id="tel3" value="${sessionScope.memberInfo.tel3}">
	            		</TD>
	          		</TR>
	          		<TR class="dot_line">
	            		<td class="fixed_join">배송지 주소</td>
	            		<td>
	              			<input type="text" id="zipcode" name="zipcode" size="10" value="${sessionScope.memberInfo.zipcode}"> 
	              				<a href="javascript:execDaumPostcode()">우편번호검색</a><br>
	              			<p>
		              			지번 주소:<br>
		               	 		<input type="text" id="roadAddress" name="roadAddress" size="50" value="${sessionScope.memberInfo.roadAddress}"><br><br>
		                		도로명 주소: 
		                		<input type="text" id="jibunAddress" name="jibunAddress" size="50" value="${sessionScope.memberInfo.jibunAddress}"><br><br>
		                		나머지 주소: <input type="text" name="namujiAddress" size="50" value="${sessionScope.memberInfo.namujiAddress}"/>
		                		<span id="guide" style="color:#999"></span>
	              			</p>
	            		</td>
	          		</TR>
	          		<TR class="dot_line">
	            		<TD class="fixed_join">배송 메시지</TD>
	            		<TD>
	              			<select name="delivery_message">
	                			<option value="message1" selected>부재시 문 앞</option>
	                			<option value="message2">직접 받고 부재시 문 앞</option>
	                			<option value="message3">경비실</option>
	                			<option value="message4">택배함</option>
	              			</select>
	            		</TD>
	          		</TR>
	        	</TBODY>
	      	</TABLE>
	    </DIV>
	   	<div><br><br>
	    	<h2>주문고객</h2>
	      	<table>
	        	<TBODY>
	          		<tr class="dot_line">
	            		<td><h2>이름</h2></td>
	            		<td>
	              			<input type="text" value="${sessionScope.memberInfo.member_name}" size="15" readonly />
	            		</td>
	          		</tr>
	          		<tr class="dot_line">
	            		<td><h2>핸드폰</h2></td>
	            		<td>
	              			<input type="text" name="pay_order_tel" id="pay_order_tel" value="${sessionScope.memberInfo.tel1}-${sessionScope.memberInfo.tel2}-${sessionScope.memberInfo.tel3}" size="15" readonly />
	            		</td>
	          		</tr>
	          		<tr class="dot_line">
	            		<td><h2>이메일</h2></td>
	            		<td>
	              			<input type="text" value="${sessionScope.memberInfo.email1}@${sessionScope.memberInfo.email2}" size="15" readonly />
	            		</td>
	          		</tr>
	        	</TBODY>
	      	</table>
	    </div>
	<DIV class="clear"></DIV>
	<br><br>
	<!-- 결제버튼 -->
	<input type="button" value="최종결제하기" onclick="requestCardPayment()" />
	<a href="${contextPath}/main/main.do">
		<img width="75" alt="" src="${contextPath}/resources/image/btn_shoping_continue.jpg">
	</a>
	<DIV class="clear"></DIV>
</BODY>
