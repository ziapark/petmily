<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>주문 완료</title>
    <style>
        .container { max-width: 960px; margin: auto; }
        .table th { width: 20%; }
    </style>
</head>
<body>
<div class="container" style="padding: 20px;">
    <div style="text-align: center; margin-bottom: 2rem;">
        <h1>🎉 주문이 성공적으로 완료되었습니다!</h1>
        <p>저희 펫밀리를 이용해주셔서 감사합니다.</p>
        <hr/>
    </div>

    <h3 style="margin-top: 2rem;">주문 상품 정보</h3>
    <table border="1" style="width: 100%; border-collapse: collapse; text-align: center;">
        <thead style="background-color: #f2f2f2;">
            <tr>
                <th>상품 이미지</th>
                <th>상품명</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${myOrderList}">
                <tr>
                    <td>
                        <img src="${contextPath}/download.do?goods_num=${item.goods_num}&fileName=${item.fileName}" width="80">
                    </td>
                    <td>${item.goods_name}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <h3 style="margin-top: 2rem;">결제 및 배송 정보</h3>
    <table border="1" style="width: 100%; border-collapse: collapse;">
        <tbody>
            <tr>
                <th>주문번호</th>
                <td>${myPayInfo.order_id}</td>
            </tr>
            <tr>
                <th>최종 결제금액</th>
                <td><strong><fmt:formatNumber value="${myPayInfo.payment_amount}" pattern="#,###" />원</strong></td>
            </tr>
            <tr>
                <th>받으시는 분</th>
                <td>${myPayInfo.buyer_name}</td>
            </tr>
        </tbody>
    </table>

    <div style="text-align: center; margin-top: 2rem;">
        <a href="${contextPath}/main/main.do">쇼핑 계속하기</a>
        <a href="${contextPath}/mypage/listMyOrderHistory.do">마이페이지로 이동</a>
    </div>
</div>
</body>
</html>