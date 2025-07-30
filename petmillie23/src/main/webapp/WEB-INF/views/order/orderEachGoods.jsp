<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!-- 주문자 휴대폰 번호 저장 -->
<c:set var="orderer_tel" value="" />
<!-- 최종 결제 금액 저장 -->
<c:set var="final_total_order_price" value="0" />
<!-- 총주문 금액 저장 -->
<c:set var="total_order_price" value="0" />
<!-- 총 상품수 저장 -->
<c:set var="total_order_goods_qty" value="0" />
<!-- 총할인금액 저장 -->
<c:set var="total_discount_price" value="0" />
<!-- 총 배송비 저장 -->
<c:set var="total_delivery_price" value="0" />

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
// 주소 검색
function execDaumPostcode() {
    new daum.Postcode({ oncomplete: function(data) {
        var fullRoadAddr = data.roadAddress;
        var extraRoadAddr = '';
        if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)) extraRoadAddr += data.bname;
        if(data.buildingName !== '' && data.apartment === 'Y') extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
        if(extraRoadAddr !== '') extraRoadAddr = ' (' + extraRoadAddr + ')';
        if(fullRoadAddr !== '') fullRoadAddr += extraRoadAddr;
        document.getElementById('zipcode').value = data.zonecode;
        document.getElementById('roadAddress').value = fullRoadAddr;
        document.getElementById('jibunAddress').value = data.jibunAddress;
        if(data.autoRoadAddress) {
            var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
            document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
        } else if(data.autoJibunAddress) {
            var expJibunAddr = data.autoJibunAddress;
            document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
        } else {
            document.getElementById('guide').innerHTML = '';
        }
    }}).open();
}

// 페이지 로드 시 기본 전화번호 세팅
window.onload = function() { init(); };
function init() {
    var form_order = document.form_order;
    var h1 = form_order.h_tel1.value;
    var h2 = form_order.h_tel2.value;
    var h3 = form_order.h_tel3.value;
    form_order.tel1.value = h1;
    form_order.tel2.value = h2;
    form_order.tel3.value = h3;
}

// 배송지 입력 초기화
function reset_all() {
    var f = document.form_order;
    f.receiver_name.value = '';
    f.tel1.value = '';
    f.tel2.value = '';
    f.tel3.value = '';
    f.zipcode.value = '';
    f.roadAddress.value = '';
    f.jibunAddress.value = '';
    f.namujiAddress.value = '';
}
// 배송지 복원
function restore_all() {
    var f = document.form_order;
    f.receiver_name.value = f.h_receiver_name.value;
    f.tel1.value = f.h_tel1.value;
    f.tel2.value = f.h_tel2.value;
    f.tel3.value = f.h_tel3.value;
    f.zipcode.value = f.h_zipcode.value;
    f.roadAddress.value = f.h_roadAddress.value;
    f.jibunAddress.value = f.h_jibunAddress.value;
    f.namujiAddress.value = f.h_namujiAddress.value;
}
// 결제 방식에 따라 입력란 토글
function fn_pay_phone(){ document.getElementById('tr_pay_card').style.visibility='hidden'; document.getElementById('tr_pay_phone').style.visibility='visible'; }
function fn_pay_card(){ document.getElementById('tr_pay_card').style.visibility='visible'; document.getElementById('tr_pay_phone').style.visibility='hidden'; }
// 레이어 팝업 제어
function imagePopup(type) {
    var layer = document.getElementById('layer');
    if(type=='open') { layer.style.visibility='visible'; layer.style.height = document.documentElement.scrollHeight + 'px'; }
    else layer.style.visibility='hidden';
}

// 주문 상세 팝업
function fn_show_order_detail(){
    var f = document.form_order;
    // 상품 정보
    var goods_id = '', goods_title = '', goods_fileName = '';
    var hidIds = f['h_goods_id'];
    var hidTitles = f['h_goods_title'];
    var hidFiles = f['h_goods_fileName'];
    if(Array.isArray(hidIds)) {
        hidIds.forEach(function(e){ goods_id += e.value + '<br>'; });
        hidTitles.forEach(function(e){ goods_title += e.value + '<br>'; });
        hidFiles.forEach(function(e){ goods_fileName += '<br>'; });
    } else { goods_id = hidIds.value; goods_title = hidTitles.value; goods_fileName = hidFiles.value; }
    var qty = f.h_order_goods_qty.value;
    var totalQty = f.h_total_order_goods_qty.value;
    var eachPrice = f.h_each_goods_price.value;
    var finalPrice = f.h_final_total_Price.value;
    // 주문자/수신자 이름
    var orderer_name = f.h_orderer_name.value;
    var receiver_name = f.receiver_name.value;
    // 휴대폰 번호
    var hp1 = document.getElementById('h_tel1').value;
    var hp2 = document.getElementById('h_tel2').value;
    var hp3 = document.getElementById('h_tel3').value;
    var tel1 = f.tel1.value;
    var tel2 = f.tel2.value;
    var tel3 = f.tel3.value;
    var receiver_hp_num = hp1+'-'+hp2+'-'+hp3;
    var receiver_tel_num = tel1+'-'+tel2+'-'+tel3;
    // 배송지
    var delivery_address = '우편번호:'+ f.zipcode.value +'<br>'+ '도로명 주소:'+ f.roadAddress.value + '<br>' + '[지번 주소:'+ f.jibunAddress.value +']<br>' + f.namujiAddress.value;
    var delivery_message = f.delivery_message.value;
    // 기타
    var delivery_method = f.delivery_method.value;
    var gift_wrapping = f.gift_wrapping.value;
    var pay_method = f.pay_method.value;
    if(pay_method=='신용카드') {
        pay_method += '<br>카드사:'+ f.card_com_name.value + '<br>할부:'+ f.card_pay_month.value;
    } else if(pay_method=='휴대폰결제') {
        pay_method += '<br>결제 휴대폰:'+ f.pay_order_tel1.value+'-'+f.pay_order_tel2.value+'-'+f.pay_order_tel3.value;
    }
    // 팝업 내용 세팅
    document.getElementById('p_order_goods_id').innerHTML = goods_id;
    document.getElementById('p_order_goods_title').innerHTML = goods_title;
    document.getElementById('p_total_order_goods_qty').innerHTML = totalQty+'개';
    document.getElementById('p_total_order_goods_price').innerHTML = total_order_goods_price+'원';
    document.getElementById('p_orderer_name').innerHTML = orderer_name;
    document.getElementById('p_receiver_name').innerHTML = receiver_name;
    document.getElementById('p_receiver_hp_num').innerHTML = receiver_hp_num;
    document.getElementById('p_receiver_tel_num').innerHTML = receiver_tel_num;
    document.getElementById('p_delivery_address').innerHTML = delivery_address;
    document.getElementById('p_delivery_message').innerHTML = delivery_message;
    document.getElementById('p_gift_wrapping').innerHTML = gift_wrapping;
    document.getElementById('p_pay_method').innerHTML = pay_method;
    imagePopup('open');
}

// 최종 결제 처리
function fn_process_pay_order(){
    var f = document.form_order;
    var formObj = document.createElement('form');
    ['receiver_name','receiver_tel1','receiver_tel2','receiver_tel3','delivery_address','delivery_message','delivery_method','gift_wrapping','pay_method','card_com_name','card_pay_month','pay_orderer_hp_num']
    .forEach(function(name){
        var inp = document.createElement('input'); inp.name = name;
        inp.value = f[name] ? f[name].value : '';
        formObj.appendChild(inp);
    });
    document.body.appendChild(formObj);
    formObj.method='post'; formObj.action='${contextPath}/order/payToOrderGoods.do';
    formObj.submit(); imagePopup('close');
}
</script>
</head>
<body>
<h1>1.주문확인</h1>
<form name="form_order">
  <table class="list_view">
    <tbody align="center">
      <tr style="background:#33ff00">
        <td colspan="2" class="fixed">주문상품명</td>
        <td>수량</td>
        <td>주문금액</td>
        <td>배송비</td>
        <td>예상적립금</td>
        <td>주문금액합계</td>
      </tr>
      <c:forEach var="item" items="${myOrderList}">
      <tr>
        <td class="goods_image">
          <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
            <img width="75" alt="" src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}" />
            <input type="hidden" id="h_goods_id" name="h_goods_id" value="${item.goods_id}" />
            <input type="hidden" id="h_goods_fileName" name="h_goods_fileName" value="${item.goods_fileName}" />
          </a>
        </td>
        <td>
          <h2><a href="${contextPath}/goods/goods.do?goods_id=${item.goods_id}">${item.goods_title}</a>
            <input type="hidden" id="h_goods_title" name="h_goods_title" value="${item.goods_title}" />
          </h2>
        </td>
        <td>
          <h2>${item.order_goods_qty}개</h2>
          <input type="hidden" id="h_order_goods_qty" name="h_order_goods_qty" value="${item.order_goods_qty}" />
        </td>
        <td><h2>${item.goods_sales_price}원 (10% 할인)</h2></td>
        <td><h2>0원</h2></td>
        <td><h2>${1500 * item.order_goods_qty}원</h2></td>
        <td>
          <h2>${item.goods_sales_price * item.order_goods_qty}원</h2>
          <input type="hidden" id="h_each_goods_price" name="h_each_goods_price" value="${item.goods_sales_price * item.order_goods_qty}" />
        </td>
      </tr>
      <c:set var="final_total_order_price" value="${final_total_order_price + (item.goods_sales_price * item.order_goods_qty)}" />
      <c:set var="total_order_price" value="${total_order_price + (item.goods_sales_price * item.order_goods_qty)}" />
      <c:set var="total_order_goods_qty" value="${total_order_goods_qty + item.order_goods_qty}" />
      </c:forEach>
    </tbody>
  </table>

  <!-- 배송지 정보 섹션 생략... (나머지 JSP 내용 역시 필요하면 추가 수정) -->

  <!-- 기본 배송지 전화번호 hidden fields -->
  <input type="hidden" id="h_tel1" name="h_tel1" value="${orderer.tel1}" />
  <input type="hidden" id="h_tel2" name="h_tel2" value="${orderer.tel2}" />
  <input type="hidden" id="h_tel3" name="h_tel3" value="${orderer.tel3}" />

  <div>
    <a href="javascript:fn_show_order_detail();"><img width="125" alt="" src="${contextPath}/resources/image/btn_gulje.jpg" /></a>
    <a href="${contextPath}/main/main.do"><img width="75" alt="" src="${contextPath}/resources/image/btn_shoping_continue.jpg" /></a>
  </div>
</form>

<div id="layer" style="visibility:hidden">
  <div id="popup_order_detail">
    <a href="javascript:imagePopup('close');"><img src="${contextPath}/resources/image/close.png" id="close" alt="닫기" /></a>
    <div class="detail_table">
      <h1>최종 주문 사항</h1>
      <table>
        <tbody>
          <tr><td>주문상품번호:</td><td><p id="p_order_goods_id"></p></td></tr>
          <tr><td>주문상품명:</td><td><p id="p_order_goods_title"></p></td></tr>
          <tr><td>주문상품개수:</td><td><p id="p_total_order_goods_qty"></p></td></tr>
          <tr><td>주문금액합계:</td><td><p id="p_total_order_goods_price"></p></td></tr>
          <tr><td>주문자:</td><td><p id="p_orderer_name"></p></td></tr>
          <tr><td>받는사람:</td><td><p id="p_receiver_name"></p></td></tr>
          <tr><td>받는사람 휴대폰번호:</td><td><p id="p_receiver_hp_num"></p></td></tr>
          <tr><td>주문전화번호:</td><td><p id="p_receiver_tel_num"></p></td></tr>
          <tr><td>배송주소:</td><td><p id="p_delivery_address"></p></td></tr>
          <tr><td>배송메시지:</td><td><p id="p_delivery_message"></p></td></tr>
          <tr><td>선물포장 여부:</td><td><p id="p_gift_wrapping"></p></td></tr>
          <tr><td>결제방법:</td><td><p id="p_pay_method"></p></td></tr>
          <tr><td colspan="2" align="center"><input type="button" value="최종결제하기" onClick="fn_process_pay_order()" /></td></tr>
        </tbody>
      </table>
    </div>
  </div>
</div>
</body>
</html>
