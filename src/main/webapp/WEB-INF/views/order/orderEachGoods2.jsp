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


<BODY>
<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
        <div class="col bg-light p-5 text-start">
            <h2 class="fw-bold">주문하기</h2>
        </div>
    </div>
    <H1 style="font-size:1.2rem; text-align:left;">상품 정보</H1>
  	<form name="form_order">
        <c:set var="totalOrderPrice" value="0" />
        <c:set var="totalOrderPoints" value="0" />
        <c:set var="totalDeliveryPrice" value="0" />
        <c:set var="totalGoodsNum" value="0" />
    	
    	<TABLE class="table">
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
              				<a href="${contextPath}/goods/goodsDetail.do?goods_num=${item.goods_num}">${item.goods_name}</a>
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
            			<td>${item.goods_delivery_price}</td>
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
		<table class="table table-bordered align-middle">
			<tbody>
				<tr>
					<td class="fw-bold" style="width: 150px;">보유 포인트</td>
					<td>
						<span id="user_total_points"><fmt:formatNumber value="${sessionScope.memberInfo.point}" />p</span>
					</td>
				</tr>
				<tr>
					<td class="fw-bold">사용할 포인트</td>
					<td>
						<div class="d-flex gap-2">
							<input type="number" id="points_to_use" class="form-control w-50" placeholder="사용할 포인트 입력" onkeyup="applyPoints()">
							<button type="button" class="btn btn-secondary" onclick="useAllPoints()">전액사용</button>
							<button type="button" class="btn btn-primary" onclick="applyPoints()">포인트 적용</button>
						</div>
						<div id="point_error_message" class="text-danger mt-1 text-start"></div>
					</td>
				</tr>
			</tbody>
		</table>
		<br><br>
    	<table width=80% class="table" style="background: #cacaff">
			<tbody>
				<tr align=center class="fixed">
					<td class="fixed">총 항목 수</td>
					<td>총 상품금액</td>
					<td></td>
					<td>총 배송비</td>
					<td>포인트 할인</td>
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
					<td>
						<p>
        					<span id="summary_discount_price">0</span><span>원</span>
    					</p> 
					</td>
					<td>
						<p class="text-danger fw-bold"><strong>
				            <span id="summary_final_price">
				                <fmt:formatNumber value="${totalOrderPrice + totalDeliveryPrice}" type="number" />
				            </span>
				            <span>원</span>
        				</strong></p> 
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
	    <H1 style="font-size:1.2rem; text-align:left;">배송지 정보</H1>
	    <table class="table table-bordered align-middle">
  		<tbody>
    		<tr>
      			<td class="fw-bold" style="width: 150px;">수령인</td>
      			<td>
        			<input type="text" class="form-control" name="receiver_name" id="receiver_name" value="${sessionScope.memberInfo.member_name}">
      			</td>
    		</tr>
    		<tr>
      			<td class="fw-bold">수령인 휴대폰번호</td>
      			<td class="d-flex gap-2">
        			<input type="text" class="form-control w-25" name="tel1" id="tel1" value="${sessionScope.memberInfo.tel1}">
        			<span class="align-self-center">-</span>
        			<input type="text" class="form-control w-25" name="tel2" id="tel2" value="${sessionScope.memberInfo.tel2}">
        			<span class="align-self-center">-</span>
        			<input type="text" class="form-control w-25" name="tel3" id="tel3" value="${sessionScope.memberInfo.tel3}">
      			</td>
    		</tr>
    		<tr>
      			<td class="fw-bold">배송지 주소</td>
      			<td>
        			<div class="mb-2 d-flex gap-2">
          				<input type="text" class="form-control w-25" id="zipcode" name="zipcode" value="${sessionScope.memberInfo.zipcode}">
          				<a href="javascript:execDaumPostcode()" class="btn btn-outline-primary">우편번호검색</a>
       	 			</div>
        			<div class="mb-2">
			          	<label class="form-label">지번 주소</label>
			          	<input type="text" class="form-control" id="roadAddress" name="roadAddress" value="${sessionScope.memberInfo.roadAddress}">
        			</div>
			        <div class="mb-2">
			          	<label class="form-label">도로명 주소</label>
			          	<input type="text" class="form-control" id="jibunAddress" name="jibunAddress" value="${sessionScope.memberInfo.jibunAddress}">
			        </div>
			        <div class="mb-2">
          				<label class="form-label">나머지 주소</label>
          				<input type="text" class="form-control" name="namujiAddress" value="${sessionScope.memberInfo.namujiAddress}">
        			</div>
        			<span id="guide" class="text-muted"></span>
      			</td>
    		</tr>
    		<tr>
      			<td class="fw-bold">배송 메시지</td>
      			<td>
        			<select name="delivery_message" class="form-select">
          				<option value="message1" selected>부재시 문 앞</option>
          				<option value="message2">직접 받고 부재시 문 앞</option>
          				<option value="message3">경비실</option>
          				<option value="message4">택배함</option>
        			</select>
      			</td>
    		</tr>
  		</tbody>
	</table>
	<H1 style="font-size:1.2rem; text-align:left;">주문고객</h1>
	<table class="table table-bordered align-middle">
  		<tbody>
    		<tr>
      			<td class="fw-bold" style="width:150px;"><h6 class="mb-0">이름</h6></td>
      			<td>
        			<input type="text" class="form-control w-50" value="${sessionScope.memberInfo.member_name}" readonly>
      			</td>
    		</tr>
    		<tr>
      			<td class="fw-bold"><h6 class="mb-0">핸드폰</h6></td>
      			<td>
        			<input type="text" class="form-control w-50" name="pay_order_tel" id="pay_order_tel"
               		value="${sessionScope.memberInfo.tel1}-${sessionScope.memberInfo.tel2}-${sessionScope.memberInfo.tel3}" readonly>
      			</td>
    		</tr>
    		<tr>
      			<td class="fw-bold"><h6 class="mb-0">이메일</h6></td>
      			<td>
        			<input type="text" class="form-control w-50" value="${sessionScope.memberInfo.email1}@${sessionScope.memberInfo.email2}" readonly>
      			</td>
    		</tr>
  		</tbody>
	</table>
	<DIV class="clear"></DIV>
	<br>
	<!-- 결제버튼 -->
	<input type="button" value="최종결제하기" onclick="requestCardPayment()" class="btn btn-primary" />
	<a href="${contextPath}/main/main.do" class="btn btn-outline-secondary">쇼핑계속하기</a>
	<br><br>
	</form>
</div>
	<script>
		let originalTotalPrice = ${totalOrderPrice + totalDeliveryPrice};
		let availablePoints = ${sessionScope.memberInfo.point};
		let appliedPoints = 0;
	
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

		function useAllPoints() {
	        const pointsInput = document.getElementById('points_to_use');
	        const errorMessageDiv = document.getElementById('point_error_message');
	        errorMessageDiv.textContent = '';

	        if (availablePoints < 5000) {
	            errorMessageDiv.textContent = '보유 포인트가 5,000P 미만이라 사용할 수 없습니다.';
	            pointsInput.value = '';
	            return;
	        }
	        
	        const maxUsablePoints = Math.max(0, originalTotalPrice - 1000);
	        // ★★★ 버그 수정: originalTotalPrice가 아닌 maxUsablePoints를 기준으로 계산 ★★★
	        const maxPointsToUse = Math.min(availablePoints, maxUsablePoints); 
	        
	        pointsInput.value = maxPointsToUse;
	        applyPoints();
	    }
		
	    function applyPoints() {
	        const pointsInput = document.getElementById('points_to_use');
	        const pointsToUse = parseInt(pointsInput.value, 10) || 0;
	        const errorMessageDiv = document.getElementById('point_error_message');
	        errorMessageDiv.textContent = '';

	        if (availablePoints < 5000) {
	            errorMessageDiv.textContent = '보유 포인트가 5,000P 미만이라 사용할 수 없습니다.';
	            resetPoints();
	            return;
	        }
	        if (pointsToUse < 0) {
	            errorMessageDiv.textContent = '사용할 포인트를 정확히 입력해주세요.';
	            pointsInput.value = '';
	            return;
	        }
	        if (pointsToUse > availablePoints) {
	        	errorMessageDiv.textContent = `최대 ${availablePoints.toLocaleString()}P까지 사용 가능합니다.`;
	            pointsInput.value = availablePoints;
	            return;
	        }

	        const maxUsablePoints = Math.max(0, originalTotalPrice - 1000);
	        if (pointsToUse > maxUsablePoints) {
	        	errorMessageDiv.textContent = `최소 결제금액 1,000원을 남겨야 합니다. (최대 ${maxUsablePoints.toLocaleString()}P 사용 가능)`;
	            pointsInput.value = maxUsablePoints;
	            return;
	        }

	        appliedPoints = pointsToUse;
	        const finalPrice = originalTotalPrice - appliedPoints;

	        document.getElementById('summary_discount_price').textContent = appliedPoints.toLocaleString();
	        document.getElementById('summary_final_price').textContent = finalPrice.toLocaleString();
	        document.forms['form_order']['total_price'].value = finalPrice;
	        console.log(`포인트 ${appliedPoints}P 적용. 최종 결제 금액: ${finalPrice}원`);
	    }

	    function resetPoints() {
	        appliedPoints = 0;
	        const finalPrice = originalTotalPrice - appliedPoints;

	        document.getElementById('summary_discount_price').textContent = '0'; 
	        document.getElementById('summary_final_price').textContent = finalPrice.toLocaleString();
	        document.forms['form_order']['total_price'].value = finalPrice;
	        document.getElementById('points_to_use').value = '';
	    }
		
		async function requestCardPayment() {
		    // --- 1단계: 기본 데이터 준비 ---
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

		    const price = Number(f['total_price']?.value) || 0;
		    if (price <= 0) {
		        alert("결제 금액이 올바르지 않습니다.");
		        return;
		    }

		    // --- 2단계: 사용자 입력 정보 검증 ---
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
		        storeId: "store-e922786e-5a3c-4063-8202-ae25a0966363",
		        channelKey: "channel-key-5886f536-8798-4066-aff3-416419fa1d39",
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

		    try {
		        const response = await PortOne.requestPayment(portoneRequestPayload);

		        if (response.code != null) {
		            alert(`결제 실패: ${response.message}`);
		            return;
		        }

		        const paymentKey = response.paymentKey || response.imp_uid || response.id || response.txId;
		        if (!paymentKey) {
		            alert("결제 응답에 고유 키가 없습니다. 관리자에게 문의하세요.");
		            return;
		        }

		        // --- 5단계: 서버에 결제 결과 전송 ---
		        const serverPayload = {
		        	paymentId: paymentId, 
		            price: price,
		            used_point:appliedPoints,
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
		            paymentStatus: response.status
		        };
		        
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
		            	window.location.href = "/petmillie/order/payComplete.do";
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
</BODY>
