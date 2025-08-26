<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"
    %>   
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<head>
 <title>펫밀리</title>
</head>
<body>
<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
	<div class="col bg-light p-5 text-start">
		<h2 class="fw-bold h2h2">상품검색리스트</h2>
		<p class="h2p"></p>
	</div>
	
	<c:if test="${empty goodsList}">
        <div class="alert alert-warning" role="alert">
            검색된 상품이 없습니다.
        </div>
    </c:if>

    <c:if test="${not empty goodsList}">
        <table class="table table-hover mt-3">
            <thead>
                <tr>
                    <th scope="col">이미지</th>
                    <th scope="col">상품명</th>
                    <th scope="col">가격</th>
                    <th scope="col">상세보기</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="goods" items="${goodsList}">
                    <tr>
                        <td>
                            <img src="${contextPath}/download.do?goods_num=${goods.goods_num}&fileName=${goods.fileName}" 
                                 alt="${goods.goods_name}" width="100" height="100"/>
                        </td>
                        <td>${goods.goods_name}</td>
                        <td>${goods.goods_sales_price}원</td>
                        <td>
                            <a href="${contextPath}/goods/goodsDetail.do?goods_num=${goods.goods_num}" 
                               class="btn btn-primary btn-sm">상세보기</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
	</div>
</div>