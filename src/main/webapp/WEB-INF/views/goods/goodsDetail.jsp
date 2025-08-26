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
		
		/* ===== 신규 리뷰 디자인 CSS ===== */
		.review-section {
		    font-family: 'Malgun Gothic', sans-serif;
		    padding: 10px 0;
		}
		
		.review-item {
		    display: flex; /* 가로 정렬을 위한 flexbox */
		    align-items: flex-start; /* 상단 정렬 */
		    padding: 24px 10px;
		    border-bottom: 1px solid #f0f0f0;
		    gap: 20px; /* 이미지와 내용 사이의 간격 */
		}
		
		.review-item:last-child {
		    border-bottom: none;
		}
		
		.review-image-box {
		    flex-shrink: 0; /* 이미지가 찌그러지지 않도록 설정 */
		    width: 80px;
		    height: 80px;
		    border-radius: 10px;
		    overflow: hidden; /* 둥근 모서리를 위해 */
		    background-color: #f4f4f4;
		    display: flex;
		    justify-content: center;
		    align-items: center;
		}
		
		.review-image-box img {
		    width: 100%;
		    height: 100%;
		    object-fit: cover; /* 이미지가 비율에 맞게 꽉 차도록 */
		}
		
		/* 이미지가 없을 때를 위한 아이콘 스타일 */
		.review-image-box .no-image-placeholder {
		    width: 40%;
		    height: 40%;
		    color: #cccccc;
		}
		
		.review-details {
		    flex-grow: 1; /* 남은 공간을 모두 차지하도록 */
		    display: flex;
		    flex-direction: column; /* 내용을 세로로 정렬 */
		}
		
		.review-header {
		    display: flex;
		    justify-content: space-between; /* 작성자 정보와 별점을 양 끝으로 */
		    align-items: center;
		    margin-bottom: 8px;
		}
		
		.review-author-info .author {
		    font-weight: bold;
		    color: #333;
		}
		
		.review-author-info .date {
		    font-size: 0.85em;
		    color: #999;
		    margin-left: 8px;
		}
		
		.star-rating {
		    font-size: 1.1em;
		    color: #FFC107; /* 별점 색상 */
		}
		
		.star-rating .empty-star {
		    color: #e0e0e0; /* 빈 별 색상 */
		}
		
		.review-body {
		    font-size: 0.95em;
		    color: #555;
		    line-height: 1.6;
		    text-align: left;
		}
		
		.no-reviews-message {
		    padding: 60px 20px;
		    text-align: center;
		    color: #888;
		    background-color: #fafafa;
		    border-radius: 8px;
		    margin-top: 20px;
		}
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
		
		//관심상품 추가 
		function toggleLikeGoods(btn) {
	    	var member_id = "${sessionScope.memberInfo.member_id}"; 
	    	if (!member_id) {
	        	alert("로그인 후 이용 가능합니다.");
	        	return;
	    	}
	   	 	var goods_num = $(btn).data("goods-num");  // data-goods-num에서 값 가져오기
	    	var isLiked = $(btn).hasClass("like_on");  // 클릭한 버튼 기준으로 상태 확인
	
	    	$.ajax({
	        	url: "${pageContext.request.contextPath}/mypage/toggleLikeGoods.do",
	        	type: "POST",
	        	dataType: "json",
	        	data: { member_id: member_id, goods_num: goods_num },
	        	success: function(response) {
	            	if(response.success) {
	                	if(response.status === "added") {
	                		alert("나의 관심상품에 추가되었습니다.");
	                    	$(btn).removeClass("like_off").addClass("like_on");
	                	} else if(response.status === "deleted") {
	                		alert("나의 관심상품에서 해제되었습니다.");
	                    	$(btn).removeClass("like_on").addClass("like_off");
	                	}
	            	} else {
	                	alert("처리에 실패했습니다.");
	            	}
	        	},
	        	error: function() {
	            	alert("좋아요 처리 중 오류가 발생했습니다.");
	        	}
	    	});
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

        <ul class="detail_buttons">
            <li><a class="buy btn btn-primary" href="javascript:fn_order_each_goods('${goodsVO.goods_num}', '${goodsVO.goods_name}', '${goodsVO.goods_sales_price}', '${image.fileName}');">구매하기</a></li>
            <li><a class="cart btn btn-primary" href="javascript:add_cart('${goodsVO.goods_num}');">장바구니</a></li>
            <li>
	            <c:set var="liked" value="${likedGoodsSet.contains(goodsVO.goods_num)}" />
				<input type="button" class="btn btn-danger ${liked ? 'like_on' : 'like_off'}" data-goods-num="${goodsVO.goods_num}" onclick="toggleLikeGoods(this)" value="관심상품" />
            </li>
        </ul>
    </div>

    <div class="clear"></div>

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
				<div class="review-section">
				    <c:choose>
				        <c:when test="${not empty reviewList}">
				            <c:forEach var="review" items="${reviewList}">
				                <div class="review-item">
				                    <div class="review-image-box">
				                        <c:choose>
				                            <c:when test="${not empty review.file_name}">
				                                <img src="${contextPath}/review/image.do?file_name=${review.file_name}&review_id=${review.review_id}" alt="리뷰 이미지">
				                            </c:when>
				                            <c:otherwise>
				                                <svg class="no-image-placeholder" xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 16 16">
				                                  <path d="M6.002 5.5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"/>
				                                  <path d="M2.002 1a2 2 0 0 0-2 2v10a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V3a2 2 0 0 0-2-2h-12zm12 1a1 1 0 0 1 1 1v6.5l-3.777-1.947a.5.5 0 0 0-.577.093l-3.71 3.71-2.66-1.772a.5.5 0 0 0-.63.062L1.002 12V3a1 1 0 0 1 1-1h12z"/>
				                                </svg>
				                            </c:otherwise>
				                        </c:choose>
				                    </div>
				
				                    <div class="review-details">
				                        <div class="review-header">
				                            <div class="review-author-info">
				                                <span class="author">${review.member_id}</span>
				                                <span class="date"><fmt:formatDate value="${review.updated_at}" pattern="yyyy-MM-dd"/></span>
				                            </div>
				                            <div class="star-rating">
				                                <c:forEach begin="1" end="${review.rating}">★</c:forEach>
				                                <c:forEach begin="${review.rating + 1}" end="5"><span class="empty-star">★</span></c:forEach>
				                            </div>
				                        </div>
				                        <div class="review-body">
				                            ${review.content}
				                        </div>
				                    </div>
				                </div>
				            </c:forEach>
				        </c:when>
				        <c:otherwise>
				            <div class="no-reviews-message">
				                등록된 리뷰가 없습니다.
				            </div>
				        </c:otherwise>
				    </c:choose>
				</div>
      		</div>
  		</div>
  </div>

    <div class="clear"></div>
    <input type="hidden" name="isLogOn" id="isLogOn" value="${isLogOn}"/>
    </div>

</body>
</html>