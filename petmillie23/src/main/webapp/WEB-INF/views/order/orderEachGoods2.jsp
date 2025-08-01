<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
</head>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
function execDaumPostcode() {
  new daum.Postcode({
    oncomplete: function(data) {
      // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

      // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
      // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
      var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
      var extraRoadAddr = ''; // 도로명 조합형 주소 변수

      // 법정동명이 있을 경우 추가한다. (법정리는 제외)
      // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
      if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
        extraRoadAddr += data.bname;
      }
      // 건물명이 있고, 공동주택일 경우 추가한다.
      if(data.buildingName !== '' && data.apartment === 'Y'){
        extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
      }
      // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
      if(extraRoadAddr !== ''){
        extraRoadAddr = ' (' + extraRoadAddr + ')';
      }
      // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
      if(fullRoadAddr !== ''){
        fullRoadAddr += extraRoadAddr;
      }

      // 우편번호와 주소 정보를 해당 필드에 넣는다.
      document.getElementById('zipcode').value = data.zonecode; //5자리 새우편번호 사용
      document.getElementById('roadAddress').value = fullRoadAddr;
      document.getElementById('jibunAddress').value = data.jibunAddress;

      // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
      if(data.autoRoadAddress) {
        //예상되는 도로명 주소에 조합형 주소를 추가한다.
        var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
        document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';

      } else if(data.autoJibunAddress) {
          var expJibunAddr = data.autoJibunAddress;
          document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
      } else {
          document.getElementById('guide').innerHTML = '';
      }
      
     
    }
  }).open();
}

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

// 페이지 로드 시 초기 상태 설정
window.onload = togglePaymentOptions;

//최종 결제 하기
function fn_process_pay_order() {
    const f = document.forms['form_order'];
    const formObj = document.createElement('form');

    const fields = ['receiver_name','tel1','tel2','tel3','zipcode','roadAddress','jibunAddress','namujiAddress',
                    'delivery_message','delivery_method','pay_method','card_com_name','card_pay_month','pay_order_tel','total_price'];

    fields.forEach(name => {
        const val = f[name]?.value || '';
        const input = document.createElement('input');
        input.name = name;
        input.value = val;
        formObj.appendChild(input);
        console.log(`${name} = ${val}`); // 디버깅 로그
    });

    document.body.appendChild(formObj);
    formObj.method = 'post';
    formObj.action = '${contextPath}/order/payToOrderGoods.do';
    formObj.submit();

    imagePopup('close');
}

</script>
<BODY>
	<H1>주문하기~~~~~~~~~~</H1>
	<form  name="form_order">
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
			<TR>
				<c:forEach var="item" items="${myOrderList }">
				    <td> ${item.order_id }</td>
					<TD class="goods_image">
					  <a href="${contextPath}/goods/goodsDetail.do?goods_num=${item.goods_num }">
					    <IMG width="75" alt=""  src="${contextPath}/thumbnails.do?goods_num=${item.goods_num}&fileName=${item.goods_fileName}">
					  </a>
					</TD>
					<TD>
					  <h2>
					     <A href="${contextPath}/goods/goodsDetail.do?goods_num=${item.goods_num }">${item.goods_name }</A>
					  </h2>
					</TD>
					<td>
					  <h2>${item.goods_qty }개</h2>
					</td>
					<td><h2>${item.goods_qty *item.goods_sales_price}원 (10% 할인)</h2></td>
					<td><h2>0원</h2></td>
					<td><h2>${1500 *item.goods_qty }원</h2></td>
					<td>
					  <h2>${item.goods_qty *item.goods_sales_price}원<input type="hidden" name="total_price" value="${item.goods_qty *item.goods_sales_price}"></h2>
					</td>
			</TR>
			</c:forEach>
		</TBODY>
	</TABLE>
	<DIV class="clear"></DIV>

	<br>
	<br>
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
					  <input type="text" size="4" name="tel1" id="tel1" value="010" readonly>-<input type="text" size="4" name="tel2" id="tel2">-<input type="text" size="4" name="tel3" id="tel3">
				  </TR>
				<TR class="dot_line">
					<td class="fixed_join">배송지 주소</td>
					<td>
					   <input type="text" id="zipcode" name="zipcode" size="10" > <a href="javascript:execDaumPostcode()">우편번호검색</a>
					  <br>
					  <p> 
					   지번 주소:<br><input type="text" id="roadAddress"  name="roadAddress" size="50"><br><br>
					  도로명 주소: <input type="text" id="jibunAddress" name="jibunAddress" size="50"><br><br>
					  나머지 주소: <input type="text"  name="namujiAddress" size="50" />
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
	<div >
	  <br><br>
	   <h2>주문고객</h2>
		 <table >
		   <TBODY>
			 <tr class="dot_line">
				<td ><h2>이름</h2></td>
				<td>
				 <input  type="text" value="${sessionScope.memberInfo.member_name}" size="15" readonly />
				</td>
			  </tr>
			  <tr class="dot_line">
				<td ><h2>핸드폰</h2></td>
				<td>
				 <input  type="text" name="pay_order_tel" id="pay_order_tel" value="${sessionScope.memberInfo.tel1}-${sessionScope.memberInfo.tel2}-${sessionScope.memberInfo.tel3}" size="15" readonly />
				</td>
			  </tr>
			  <tr class="dot_line">
				<td ><h2>이메일</h2></td>
				<td>
				   <input  type="text" value="${sessionScope.memberInfo.email1}@${sessionScope.memberInfo.email2}" size="15" readonly />
				</td>
			  </tr>
		   </TBODY>
		</table>
	</div>
	<DIV class="clear"></DIV>
	<br>
	<br>
	<br>
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
            <!-- 필요한 옵션 추가 -->
        </select>
    </TD>
</TR>

			</TBODY>
		</table>
	</DIV>
</form>
    <DIV class="clear"></DIV>
	<br>
	<br>
	<br>
	<center>
		<br>
		<br>
		<tr><td colspan="2" align="center"><input type="button" value="최종결제하기" onClick="fn_process_pay_order()" /></td></tr>
		<a href="${contextPath}/main/main.do"> 
		   <IMG width="75" alt="" src="${contextPath}/resources/image/btn_shoping_continue.jpg">
		</a>
<DIV class="clear"></DIV>		
	
			
			
			