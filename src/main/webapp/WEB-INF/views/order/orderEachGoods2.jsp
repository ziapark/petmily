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
		    // --- 1단계: 기본 데이터 준비 ---
		    console.log("✅ 1단계: 함수 진입 및 기본 데이터 수집 시작");
		    const f = document.forms['form_order'];
		    const orderName = "펫밀리 주문결제";

		    // 장바구니 비었는지 확인
		    const orderItems = [];
		    document.querySelectorAll('.order-item').forEach(itemElement => {
		        orderItems.push({
		            goods_num: itemElement.dataset.goodsNum,
		            goods_qty: itemElement.dataset.goodsQty,
		            fileName: itemElement.dataset.fileName
		        });
		    });

		    if (orderItems.length === 0) {
		        alert("주문할 상품이 없습니다.");
		        return;
		    }
		    console.log("🛒 주문 상품 목록:", orderItems);

		    const price = Number(f['total_price']?.value) || 0;
		    if (price <= 0) {
		        alert("결제 금액이 올바르지 않습니다.");
		        return;
		    }
		    console.log("💰 총 결제 금액:", price);

		    // --- 2단계: 사용자 입력 정보 검증 ---
		    console.log("✅ 2단계: 배송지 정보 유효성 검사 시작");
		    const receiver_name = f['receiver_name']?.value.trim();
		    if (!receiver_name) {
		        alert("수령인 이름을 입력해주세요.");
		        return;
		    }

		    const tel1 = f['tel1']?.value.trim();
		    const tel2 = f['tel2']?.value.trim();
		    const tel3 = f['tel3']?.value.trim();
		    const phoneRaw = [tel1, tel2, tel3].join('');
		    if (!/^\d{10,11}$/.test(phoneRaw)) { // 10자리 또는 11자리 허용
		        alert("휴대폰 번호를 정확히 입력해 주세요! (예: 01012345678)");
		        return;
		    }

		    const roadAddress = f['roadAddress']?.value.trim();
		    const jibunAddress = f['jibunAddress']?.value.trim();
		    if (!roadAddress && !jibunAddress) {
		        alert("주소를 입력해 주세요!");
		        return;
		    }
		    console.log("📝 배송지 정보 검증 완료");

		    // --- 3단계: 포트원 결제 요청 ---
		    const paymentId = `PAYMENT_${Date.now()}_${Math.floor(Math.random() * 1000000)}`;
		    const portoneRequestPayload = {
		        storeId: "store-292f1f91-b8c2-4608-9394-615315d5f811",
		        channelKey: "channel-key-16983525-2a28-41f4-b177-b4f8e27769dc",
		        paymentId: paymentId,
		        orderName: orderName,
		        totalAmount: price,
		        currency: "CURRENCY_KRW",
		        payMethod: "CARD",
		        customer: {
		            fullName: receiver_name,
		            phoneNumber: phoneRaw,
		            email: "${sessionScope.memberInfo.email1}@${sessionScope.memberInfo.email2}",
		            address: {
		                addressLine1: roadAddress || jibunAddress,
		                addressLine2: f['namujiAddress']?.value.trim(),
		                postalCode: f['zipcode']?.value.trim()
		            }
		        }
		    };

		    console.log("✅ 3단계: 포트원 결제창 호출 직전. 요청 데이터:", portoneRequestPayload);

		    try {
		        const response = await PortOne.requestPayment(portoneRequestPayload);
		        console.log("✅ 4단계: 포트원 응답 받음:", response);

		        if (response.code != null) {
		            alert(`결제 실패: ${response.message}`);
		            return;
		        }

		        const paymentKey = response.paymentKey || response.imp_uid || response.id || response.txId;
		        if (!paymentKey) {
		            alert("결제 응답에 고유 키가 없습니다. 관리자에게 문의하세요.");
		            console.error("📛 결제 응답 이상:", response);
		            return;
		        }

		        // --- 5단계: 서버에 결제 결과 전송 ---
		        const serverPayload = {
		            price: price,
		            receiver_name: receiver_name,
		            tel1: tel1,
		            tel2: tel2,
		            tel3: tel3,
		            zipcode: f['zipcode']?.value.trim(),
		            roadAddress: roadAddress,
		            jibunAddress: jibunAddress,
		            namujiAddress: f['namujiAddress']?.value.trim(),
		            delivery_message: f['delivery_message']?.value,
		            orderItems: orderItems,
		            imp_uid: paymentKey,
		            paymentStatus: response.status,
		            pay_method: response.pg_provider
		        };

		        console.log("✅ 5단계: 백엔드 서버로 데이터 전송 직전. 전송 데이터:", serverPayload);
		        
		        const res = await fetch("/petmillie/order/payToOrderGoods.do", {
		            method: "POST",
		            headers: { "Content-Type": "application/json" },
		            body: JSON.stringify(serverPayload)
		        });

		        console.log("✅ 6단계: 서버 응답 받음. 상태:", res.status);

		        if (!res.ok) {
		            alert(`서버 통신 오류가 발생했습니다. (상태: ${res.status})`);
		            return;
		        }

		        const text = await res.text();
		        console.log("✅ 7단계: 서버 응답 텍스트:", text);
		        
		        // --- 8단계: 최종 결과 처리 ---
		        console.log("✅ 8단계: 서버 응답 처리 시작");
		        try {
		            const result = JSON.parse(text);
		            alert(result.message || "주문이 완료되었습니다!");
		            if (result.success) {
		                const ctx = "${pageContext.request.contextPath}";
		                window.location.href = `${ctx}/order/payComplete.do`;
		            }
		        } catch (e) {
		            console.error("❌ 최종 결과 처리 중 JSON 파싱 실패!", e);
		            alert("서버 응답을 처리하는 데 실패했습니다. 관리자에게 문의해주세요.");
		        }

		    } catch (error) {
		        console.error("❌ 포트원 결제 또는 서버 통신 중 예측하지 못한 에러 발생!", error);
		        alert("결제 과정 중 오류가 발생했습니다.");
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
          			<tr class="order-item" data-goods-num="${item.goods_num}" data-goods-qty="${item.goods_qty}" data-file-name="${item.fileName}">
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
