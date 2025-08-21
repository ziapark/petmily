<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" isELIgnored="false"%>   
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="goodsVO" value="${goodsVO}" />
<c:set var="goodsImageList" value="${goodsImageList}" />

<html>
<head>
	<style>
		#layer {position: fixed; top: 0; left: 0; width: 100%; height: 100%; visibility: hidden; background-color: rgba(0, 0, 0, 0.6); z-index: 1000; display: flex; justify-content: center; align-items: center;}
		#popup {background: white; padding: 40px; border-radius: 10px; text-align: center;}
		#close {position: absolute; top: 10px; right: 10px; cursor: pointer;}
	</style>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		var contextPath = "${pageContext.request.contextPath}";

		function add_cart(goods_num) {	
		    var isLogOn = document.getElementById("isLogOn").value;
		    if (isLogOn == "false" || isLogOn == '') {
		        alert("로그인 후 장바구니 이용이 가능합니다.");
		        window.location.href = contextPath + '/member/loginForm.do';
		        return;
		    }
		    
    		$.ajax({
        		type: "post",
        		url: contextPath + "/cart/addGoodsInCart.do",
        		data: { goods_num: goods_num },
        		success: function(data) {
	            	console.log("서버 응답:", data);

	            	if(data === 'increase_success'){
	            		alert("이미 카트에 등록된 상품입니다. 상품 수량 1개 증가했습니다.");
	            	}else{
	            		alert("장바구니에 상품을 추가했습니다.");
	            	}
        		},
        		error: function(xhr, status, error) {
            		console.error("Ajax 에러:", error);
            		alert("에러가 발생했습니다.");
        		}
    		});
		}
	
		function fn_order_each_goods(goods_num, goods_name, goods_sales_price, fileName){
	    	var isLogOn = document.getElementById("isLogOn").value;
	    	if(isLogOn == "false" || isLogOn == '') {
	        	alert("로그인 후 주문이 가능합니다!!!");
	        	return;
	   	 	}
	
		    var order_goods_qty = document.getElementById("order_goods_qty").value;
	    	var formObj = document.createElement("form");
	    	var i_goods_num = document.createElement("input"); 
	    	var i_goods_name = document.createElement("input");
	    	var i_goods_sales_price = document.createElement("input");
	    	var i_fileName = document.createElement("input");
	    	var i_order_goods_qty = document.createElement("input");
	    	i_goods_num.name = "goods_num";
	    	i_goods_name.name = "goods_name";
	    	i_goods_sales_price.name = "goods_sales_price";
	    	i_fileName.name = "fileName";
	    	i_order_goods_qty.name = "order_goods_qty";
	    	i_goods_num.value = goods_num;
	    	i_goods_name.value = goods_name;
	    	i_goods_sales_price.value = goods_sales_price;
	    	i_fileName.value = fileName;
	    	i_order_goods_qty.value = order_goods_qty;
	    	formObj.appendChild(i_goods_num);
	    	formObj.appendChild(i_goods_name);
	    	formObj.appendChild(i_goods_sales_price);
	    	formObj.appendChild(i_fileName);
	    	formObj.appendChild(i_order_goods_qty);
	    	document.body.appendChild(formObj);
	    	formObj.method = "post";
	    	formObj.action = contextPath + "/order/orderEachGoods.do";
	    	formObj.submit();
		}
	</script>
</head>
<body>
<div class="container text-center mt-3 mb-3">
    <div class="row row-cols-1 mb-3">
    	<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold h2h2">${goodsVO.goods_name}</h2>
			<p class="h2p">${goodsVO.goods_maker} | ${goodsVO.goods_category}</p>
		</div>
    </div>

	<div id="goods_image">
    	<figure>
        	<c:forEach var="image" items="${goodsImageList}" varStatus="status">
            	<c:if test="${status.index == 0}">
                	<img alt="${goodsVO.goods_name}" src="${contextPath}/goods/thumbnails.do?goods_num=${goodsVO.goods_num}&fileName=${image.fileName}">
            	</c:if>
        	</c:forEach>
    	</figure>
	</div>

    <div id="detail_table">
        <table>
            <tbody>
            	<tr>
            		<td colspan="2" style="font-size:1.5rem;">${goodsVO.goods_name}</td>
            	</tr>       
                <tr class="dot_line">
                	
                    
                    <td colspan="2" class="active price_td">                
		            	<c:choose>
							<c:when test="${goodsVO.goods_sales_price != 0}">
						    	<fmt:formatNumber value="${goodsVO.goods_sales_price}" pattern="#,###원" />
						  	</c:when>
						  	<c:otherwise>
						    	가격 정보가 없습니다.
						  	</c:otherwise>
						</c:choose>
                    </td>
                </tr>
                <tr>
                    <td class="fixed">포인트적립</td>
                    <td class="active"> <fmt:formatNumber value= "${goodsVO.goods_sales_price * goodsVO.goods_point * 0.01}" maxFractionDigits="0"/>P(${goodsVO.goods_point}%적립)</td>
                </tr>
                <tr>
                    <td class="fixed">배송료</td>
                    <td class="fixed"><strong>${goodsVO.goods_delivery_price}</strong></td>
                </tr>         
                <tr>
                    <td class="fixed">재고</td>
                    <td class="fixed"><strong>${goodsVO.goods_stock}</strong></td>
                </tr>
            </tbody>
        </table>
        <ul>
            <li><a class="buy btn btn-primary" href="javascript:fn_order_each_goods('${goodsVO.goods_num}', '${goodsVO.goods_name}', '${goodsVO.goods_sales_price}', '${image.fileName}');">구매하기</a></li>
            <li><a class="cart btn btn-primary" href="javascript:add_cart('${goodsVO.goods_num}');">장바구니</a></li>
            <li><a class="wish btn  btn-pink" href="#">관심상품</a></li>
        </ul>
    </div>

    <div class="clear"></div>

    <!-- 탭 영역 -->
    <div id="container">
        <ul class="tabs">
            <li><a href="#tab1">상품소개</a></li>       
            <li><a href="#tab2">리뷰</a></li>
        </ul>
        <div class="tab_container">
            <div class="tab_content" id="tab1">
                <h4>상품소개</h4>
                <p>${fn:replace(goodsVO.goods_name,"/n", "<br/>")}</p>
                <c:forEach var="image" items="${goodsImageList}">
                    <img src="${contextPath}/download.do?goods_num=${image.goods_num}&fileName=${image.fileName}" alt="상품상세이미지"/><p>
                </c:forEach>
            </div>           
            <div class="tab_content" id="tab2">
    		<h4>리뷰</h4>
    		<c:choose>
        		<c:when test="${not empty reviewList}">
            		<c:forEach var="review" items="${reviewList}">
                		<div class="review-item" style="border-bottom: 1px solid #ddd; margin-bottom: 10px; padding-bottom: 10px;">
                    		<div class="review-header" style="display:flex; align-items:center; margin-bottom:5px;">
                        		<div class="star-rating" style="color: #f44336; margin-right: 10px;">
                            		<c:forEach begin="1" end="5" var="i">
                                		<c:choose>
                                    		<c:when test="${i <= review.rating}">
                                        		★
                                    		</c:when>
                                    		<c:otherwise>
                                        		☆
                                   	 		</c:otherwise>
                                		</c:choose>
                            		</c:forEach>
                            		<span style="margin-left: 5px; color: black;">${review.rating}</span>
                        		</div>
                        		<div>
                            		<span style="margin-left: 5px; color: black;">${review.member_id}</span>
                            		<div class="review-date" style="color: #888;">${review.updated_at}</div>
                        		</div>
                    		</div>
                    		<div class="review-text" style="margin-bottom: 5px;">${review.content}</div>
                    			<c:if test="${not empty review.file_name}">
                        			<img src="${contextPath}/review/image.do?file_name=${review.file_name}&review_id=${review.review_id}" alt="리뷰 이미지" style="max-width: 100px; max-height: 100px;">
                    			</c:if>
                			</div>
            			</c:forEach>
        			</c:when>
		        <c:otherwise>
		            <div style="padding: 20px; text-align: center; color: #888;">
		                등록된 리뷰가 없습니다.
		            </div>
		        </c:otherwise>
		    </c:choose>
      </div>
  </div>
  </div>

    <div class="clear"></div>
    <input type="hidden" name="isLogOn" id="isLogOn" value="${isLogOn}"/>
    </div>

</body>
</html>
