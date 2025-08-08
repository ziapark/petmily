<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>최종 주문 내역서</title>
</head>
<body>
    <h1>1. 최종 주문 내역서</h1>
    <table class="list_view">
        <tbody align="center">
            <tr style="background: #33ff00">
                <td>주문번호</td>
                <td colspan="2" class="fixed">주문상품명</td>
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
                        <img width="75" alt="" src="${contextPath}/thumbnails.do?goods_num=${item.goods_num}&fileName=${item.goods_fileName}"/>
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
                <td><h2>${item.goods_qty * item.goods_sales_price}원</h2></td>
            </tr>
            </c:forEach>
        </tbody>
    </table>
    <div class="clear"></div>

    <form name="form_order">
        <br/><br/>
        <h1>2. 배송지 정보</h1>
        <div class="detail_table">
            <table>
                <tbody>
                    <tr class="dot_line">
                        <td class="fixed_join">배송방법</td>
                        <td>${myOrderInfo.delivery_method}</td>
                    </tr>
                    <tr class="dot_line">
                        <td class="fixed_join">받으실 분</td>
                        <td>${myOrderInfo.receiver_name}</td>
                    </tr>
                    <tr class="dot_line">
                        <td class="fixed_join">휴대폰번호</td>
                        <td>${myOrderInfo.tel1}-${myOrderInfo.tel2}-${myOrderInfo.tel3}</td>
                    </tr>
                    <tr class="dot_line">
                        <td class="fixed_join">주소</td>
                        <td>${myOrderInfo.delivery_address}</td>
                    </tr>
                    <tr class="dot_line">
                        <td class="fixed_join">배송 메시지</td>
                        <td>${myOrderInfo.delivery_message}</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div>
            <br/><br/>
            <h2>주문고객</h2>
            <table>
                <tbody>
                    <tr class="dot_line">
                        <td><h2>이름</h2></td>
                        <td>
                            <input type="text" value="${orderer.member_name}" size="15" disabled/>
                        </td>
                    </tr>
                    <tr class="dot_line">
                        <td><h2>핸드폰</h2></td>
                        <td>
                            <input type="text" value="${orderer.tel1}-${orderer.tel2}-${orderer.tel3}" size="15" disabled/>
                        </td>
                    </tr>
                    <tr class="dot_line">
                        <td><h2>이메일</h2></td>
                        <td>
                            <input type="text" value="${orderer.email1}@${orderer.email2}" size="15" disabled/>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </form>

    <div class="clear"></div><br/><br/><br/>

    <h1>3. 결제정보</h1>
    <div class="detail_table">
        <table>
            <tbody>
                <tr class="dot_line">
                    <td class="fixed_join">결제방법</td>
                    <td>${myOrderInfo.pay_method}</td>
                </tr>
                <tr class="dot_line">
                    <td class="fixed_join">결제카드</td>
                    <td>${myOrderInfo.card_com_name}</td>
                </tr>
                <tr class="dot_line">
                    <td class="fixed_join">할부기간</td>
                    <td>${myOrderInfo.card_pay_month}</td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="clear"></div><br/><br/><br/>
        <a href="${contextPath}/main/main.do">
            <img width="75" alt="쇼핑 계속" src="${contextPath}/resources/image/btn_shoping_continue.jpg"/>
        </a>
</body>
</html>
