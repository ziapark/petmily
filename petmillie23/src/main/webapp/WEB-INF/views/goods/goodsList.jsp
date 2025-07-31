<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" 	isELIgnored="false"%>   
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<c:set var="goodsList"  value="${goodsList}"  /> 
<link rel="stylesheet" href="css/common.css">
<html>
<head>
<title>상품 리스트</title>

</head>
<body>

<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold">상품 리스트</h2>
			<p>데이터베이스에서 가져온 다양한 상품들을 만나보세요!</p>	
		</div>
	</div>
	
	<div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
	    <c:choose>
	        <c:when test="${not empty goodsList}">
	            <c:forEach var="goods" items="${goodsList}">
	                <div class="col">
	                    <div class="goods-item">
	                        <a href="${contextPath}/goods/goodsDetail.do?goods_num=${goods.goods_num}">
	                            <img src="http://localhost:8090/petupload/goods/${goods.goods_num}/${goods.goods_fileName}" alt="대표 이미지">
	                        </a>
	                        <div class="goods-name">${goods.goods_name}</div>
	                        <div class="goods-price">
	                            <fmt:formatNumber value="${goods.goods_sales_price}" type="number" pattern="#,###원"/>
	                        </div>
	                        <div class="cartAndLike_wrap">
	                        	<input type="button" class="cart_icon_btn" onclick="addToCart('${goods.goods_num}')">
	                        	<input type="button" class="like_icon_btn" onclick="addLikeGoods('${goods.goods_num}')">
	                        </div>

	                    </div>
	                </div>
	            </c:forEach>
	        </c:when>
	        <c:otherwise>
	            <div class="col-12">
	                <p class="text-muted">현재 등록된 상품이 없습니다. 잠시 후 다시 시도해주세요.</p>
	            </div>
	        </c:otherwise>
	    </c:choose>
	</div>
</div>

<input type="hidden" name="isLogOn" id="isLogOn" value="${isLogOn}"/>	

<script>
function addToCart(goodsNum) {
    var isLogOnElement = document.getElementById('isLogOn');
    var isLogOn = isLogOnElement ? isLogOnElement.value : 'false';

    if (isLogOn === 'true' || isLogOn === 'Y') {
        fetch('${contextPath}/cart/addGoodsInCart.do', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: 'goods_num=' + encodeURIComponent(goodsNum)
        })
        .then(response => response.text())
        .then(result => {
            console.log("서버 응답:", result);  // 디버깅용
            if (result.trim() === 'add_success') {
                alert('장바구니에 담겼습니다!');
            } else if (result.trim() === 'increase_success') {
                alert('이미 장바구니에 있는 상품입니다. 수량이 1 증가했습니다.');
            } else {
                alert('장바구니 추가 실패: ' + result);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('서버 오류로 장바구니 추가 실패');
        });
    } else {
        if (confirm('로그인 후 장바구니를 이용할 수 있습니다. 로그인 페이지로 이동하시겠습니까?')) {
            window.location.href = '${contextPath}/member/loginForm.do';
        }
    }
}

</script>

</body>
</html>
