<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
</head>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<!-- PortOne Browser SDK v2만! -->
<script src="https://cdn.portone.io/v2/browser-sdk.js"></script>
<script>
/**
 * 다음 우편번호 API 연동
 */
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

/**
 * 결제방법 선택 시 카드/할부 UI 토글
 */
function togglePaymentOptions() {
  const selected = document.querySelector("select[name='pay_method']").value;
  const cardSection = document.getElementById("cardSection");
  const monthSection = document.getElementById("monthSection");
  if (selected === "card") {
    cardSection.style.display = "";
    monthSection.style.display = "";
  } else {
    cardSection.style.display = "none";
    monthSection.style.display = "none";
  }
}
window.onload = togglePaymentOptions;

/**
 * PortOne Browser SDK v2 카드결제 (필수 파라미터 모두 포함!)
 * 결제버튼 클릭 시 호출!
 */
async function requestCardPayment() {
  const f = document.forms['form_order'];
  const orderName = "펫밀리 주문결제";
  const price = f['total_price'] ? f['total_price'].value : 1000;
  const or_idx = f['order_id'] ? f['order_id'].value : new Date().getTime();
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
    zipcode: f['zipcode']?.value,
    roadAddress: roadAddress,
    jibunAddress: jibunAddress,
    namujiAddress: f['namujiAddress']?.value,
    delivery_message: f['delivery_message']?.value,
    delivery_method: f['delivery_method']?.value,
    pay_method: f['pay_method']?.value,
    card_com_name: f['card_com_name']?.value,
    card_pay_month: f['card_pay_month']?.value,
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
    // 추가 필드는 PortOne 공식문서 참고
  });

  // 결제 실패
  if (response.code != null) {
    alert(response.message);
    return;
  }

  // 결제 성공시 서버로 주문/결제 내역 전달
  try {
    const res = await fetch("${ctx}/order/payToOrderGoods.do", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        ...data,
        paymentId: paymentId,
        portone_paymentKey: response.paymentKey,
        paymentStatus: response.status
      })
    });
    const result = await res.json();
    alert(result.message || "주문이 완료되었습니다!");
    if(result.success) {
      window.location.href = "${contextPath}/order/payComplete.do";
    }
  } catch (e) {
	  console.error("❌ 예외 발생:", e);
    alert("서버 오류! 결제는 이미 되었을 수도 있으니, 반드시 관리자에게 문의해 주세요!");
  }
}
</script>

<BODY>
  <H1>주문하기</H1>
  <form name="form_order">
    <TABLE class="list_view">
      <TBODY align=center>
        <tr style="background: #33ff00">
          <td>주문번호 </td>
          <td colspan=2 class="fixed">주문상품명</td>
          <td>수량</td>
          <td>주문금액</td>
          <td>배송비</td>
          <td>예상적립금</td>
          <td>주문금액합계</td>
        </tr>
        <c:forEach var="item" items="${myOrderList}">
          <tr>
            <td>${item.order_id}</td>
            <td class="goods_image">
              <a href="${contextPath}/goods/goodsDetail.do?goods_num=${item.goods_num}">
                <img width="75" alt="" src="${contextPath}/thumbnails.do?goods_num=${item.goods_num}&fileName=${item.goods_fileName}">
              </a>
            </td>
            <td>
              <h2>
                <a href="${contextPath}/goods/goodsDetail.do?goods_num=${item.goods_num}">${item.goods_name}</a>
              </h2>
            </td>
            <td><h2>${item.goods_qty}개</h2></td>
            <td><h2>${item.goods_qty * item.goods_sales_price}원 (10% 할인)</h2></td>
            <td><h2>0원</h2></td>
            <td><h2>${1500 * item.goods_qty}원</h2></td>
            <td>
              <h2>
                ${item.goods_qty * item.goods_sales_price}원
                <input type="hidden" name="total_price" value="${item.goods_qty * item.goods_sales_price}">
                <input type="hidden" name="order_id" value="${item.order_id}">
              </h2>
            </td>
          </tr>
        </c:forEach>
      </TBODY>
    </TABLE>
    <DIV class="clear"></DIV>
    <br><br>
    <H1>2.배송지 정보</H1>
    <DIV class="detail_table">
      <TABLE>
        <TBODY>
          <TR class="dot_line">
            <TD class="fixed_join">배송방법</TD>
            <TD>
              <input type="text" name="delivery_method" id="delivery_method" value="택배" readonly>
            </TD>
          </TR>
          <TR class="dot_line">
            <TD class="fixed_join">수령인 </TD>
            <TD>
              <input type="text" name="receiver_name" id="receiver_name">
            </TD>
          </TR>
          <TR class="dot_line">
            <TD class="fixed_join">수령인 휴대폰번호</TD>
            <TD>
              <input type="text" size="4" name="tel1" id="tel1" value="010" readonly>-
              <input type="text" size="4" name="tel2" id="tel2">-
              <input type="text" size="4" name="tel3" id="tel3">
            </TD>
          </TR>
          <TR class="dot_line">
            <td class="fixed_join">배송지 주소</td>
            <td>
              <input type="text" id="zipcode" name="zipcode" size="10"> 
              <a href="javascript:execDaumPostcode()">우편번호검색</a>
              <br>
              <p> 
                지번 주소:<br>
                <input type="text" id="roadAddress" name="roadAddress" size="50"><br><br>
                도로명 주소: 
                <input type="text" id="jibunAddress" name="jibunAddress" size="50"><br><br>
                나머지 주소: <input type="text" name="namujiAddress" size="50" />
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
    <div>
      <br><br>
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
    <br><br><br>
    <H1>3.결제정보</H1>
    <DIV class="detail_table">
      <table>
        <TBODY>
          <TR class="dot_line">
            <TD class="fixed_join">결제방법</TD>
            <TD>
              <select name="pay_method" onchange="togglePaymentOptions()">
                <option value="card" selected>카드</option>
                <option value="pay">계좌이체</option>
              </select>
            </TD>
          </TR>
          <TR class="dot_line" id="cardSection">
            <TD class="fixed_join">결제카드</TD>
            <TD>
              <input type="text" name="card_com_name" placeholder="카드사 입력">
            </TD>
          </TR>
          <TR class="dot_line" id="monthSection">
            <TD class="fixed_join">할부기간</TD>
            <TD>
              <select name="card_pay_month">
                <option value="0">일시불</option>
                <option value="2">2개월</option>
                <option value="3">3개월</option>
                <option value="6">6개월</option>
              </select>
            </TD>
          </TR>
        </TBODY>
      </table>
    </DIV>
  </form>
  <DIV class="clear"></DIV>
  <br><br><br><br><br>
  <!-- 결제버튼 -->
  <input type="button" value="최종결제하기" onclick="requestCardPayment()" />
  <a href="${contextPath}/main/main.do">
    <img width="75" alt="" src="${contextPath}/resources/image/btn_shoping_continue.jpg">
  </a>
  <DIV class="clear"></DIV>
</BODY>
