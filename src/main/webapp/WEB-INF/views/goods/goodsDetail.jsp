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
		/* ===== 기존 스타일 유지 ===== */
		#layer {position: fixed; top: 0; left: 0; width: 100%; height: 100%; visibility: hidden; background-color: rgba(0, 0, 0, 0.6); z-index: 1000; display: flex; justify-content: center; align-items: center;}
		#popup {background: white; padding: 40px; border-radius: 10px; text-align: center;}
		#close {position: absolute; top: 10px; right: 10px; cursor: pointer;}
		.review-section { font-family: 'Malgun Gothic', sans-serif; padding: 10px 0; }
		.review-item { display: flex; align-items: flex-start; padding: 24px 10px; border-bottom: 1px solid #f0f0f0; gap: 20px; }
		.review-item:last-child { border-bottom: none; }
		.review-image-box { flex-shrink: 0; width: 80px; height: 80px; border-radius: 10px; overflow: hidden; background-color: #f4f4f4; display: flex; justify-content: center; align-items: center; }
		.review-image-box img { width: 100%; height: 100%; object-fit: cover; }
		.review-image-box .no-image-placeholder { width: 40%; height: 40%; color: #cccccc; }
		.review-details { flex-grow: 1; display: flex; flex-direction: column; }
		.review-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px; }
		.review-author-info .author { font-weight: bold; color: #333; }
		.review-author-info .date { font-size: 0.85em; color: #999; margin-left: 8px; }
		.star-rating { font-size: 1.1em; color: #FFC107; }
		.star-rating .empty-star { color: #e0e0e0; }
		.review-body { font-size: 0.95em; color: #555; line-height: 1.6; text-align: left; }
		.no-reviews-message { padding: 60px 20px; text-align: center; color: #888; background-color: #fafafa; border-radius: 8px; margin-top: 20px; }
		.quantity-selector {
			display: flex;
			align-items: center;
			border: 1px solid #ccc;
			border-radius: 5px;
			padding: 5px;
			width: fit-content; /* 테이블 셀 안에서 너비가 꽉 차지 않도록 설정 */
		}
		.quantity-selector button {
			border: none;
			background-color: #f0f0f0;
			font-size: 1.2rem;
			font-weight: bold;
			cursor: pointer;
			width: 30px;
			height: 30px;
			line-height: 30px;
			text-align: center;
		}
		.quantity-selector input {
			width: 50px;
			text-align: center;
			border: none;
			font-size: 1rem;
			font-weight: bold;
		}
		/* input 태그의 화살표 제거 */
		.quantity-selector input[type="number"]::-webkit-inner-spin-button,
		.quantity-selector input[type="number"]::-webkit-outer-spin-button {
			-webkit-appearance: none;
			margin: 0;
		}
	</style>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript">
		var contextPath = "${pageContext.request.contextPath}";

		// 장바구니 추가 함수
		function add_cart(goods_num) {	
		    var isLogOn = document.getElementById("isLogOn").value;
		    if (isLogOn == "false" || isLogOn == '') {
		        alert("로그인 후 장바구니 이용이 가능합니다.");
		        window.location.href = contextPath + '/member/loginForm.do';
		        return;
		    }
		    
			var cart_goods_qty = document.getElementById("cart_goods_qty").value;
			if (Number(cart_goods_qty) <= 0) {
				alert("수량은 1 이상이어야 합니다.");
				return;
			}

    		$.ajax({
        		type: "post",
        		url: contextPath + "/cart/addGoodsInCart.do",
        		data: { 
					goods_num: goods_num,
					cart_goods_qty: cart_goods_qty 
				},
        		success: function(data) {
	            	if(data === 'add_success'){
	            		alert("장바구니에 상품을 추가했습니다.");
	            	} else if (data === 'increase_success') {
						alert("이미 장바구니에 있는 상품입니다. 수량을 변경했습니다.");
					} else {
						alert("장바구니 추가에 실패했습니다.");
					}
        		},
        		error: function(xhr, status, error) {
            		alert("에러가 발생했습니다.");
        		}
    		});
		}
	
		//바로 구매 함수
		function fn_order_each_goods(goods_num, goods_name, goods_sales_price, fileName, goods_point){
	    	var isLogOn = document.getElementById("isLogOn").value;
	    	if(isLogOn == "false" || isLogOn == '') {
	        	alert("로그인 후 주문이 가능합니다!");
	        	return;
	   	 	}
	
			//수량 입력칸에서 값을 가져옵니다.
		    var goods_qty = document.getElementById("cart_goods_qty").value;
			if (Number(goods_qty) <= 0) {
				alert("주문 수량은 1 이상이어야 합니다.");
				return;
			}

	    	var formObj = document.createElement("form");
	    	var i_goods_num = document.createElement("input"); 
	    	var i_goods_name = document.createElement("input");
	    	var i_goods_sales_price = document.createElement("input");
	    	var i_fileName = document.createElement("input");
	    	var i_goods_qty = document.createElement("input");
	    	var i_goods_point = document.createElement("input");
	    	
	    	i_goods_num.name = "goods_num";
	    	i_goods_name.name = "goods_name";
	    	i_goods_sales_price.name = "goods_sales_price";
	    	i_fileName.name = "fileName";
	    	i_goods_qty.name = "goods_qty"; // 컨트롤러에서 받을 이름과 통일
	    	i_goods_point.name = "point";
	    	
	    	i_goods_num.value = goods_num;
	    	i_goods_name.value = goods_name;
	    	i_goods_sales_price.value = goods_sales_price;
	    	i_fileName.value = fileName;
	    	i_goods_qty.value = goods_qty; // 가져온 수량 값을 설정
	    	i_goods_point.value = goods_point;
	    	
	    	formObj.appendChild(i_goods_num);
	    	formObj.appendChild(i_goods_name);
	    	formObj.appendChild(i_goods_sales_price);
	    	formObj.appendChild(i_fileName);
	    	formObj.appendChild(i_goods_qty);
	    	formObj.appendChild(i_goods_point);
	    	
	    	document.body.appendChild(formObj);
	    	formObj.method = "post";
	    	formObj.action = contextPath + "/order/orderEachGoods.do";
	    	formObj.submit();
		}
		
		function toggleLikeGoods(btn) {
	    	var member_id = "${sessionScope.memberInfo.member_id}"; 
	    	if (!member_id) {
	        	alert("로그인 후 이용 가능합니다.");
	        	return;
	    	}
	   	 	var goods_num = $(btn).data("goods-num");
	    	var isLiked = $(btn).hasClass("like_on");
	
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

		//수량 조절 스크립트
		function changeQty(amount) {
			const qtyInput = document.getElementById('cart_goods_qty');
			let currentQty = parseInt(qtyInput.value);
			let newQty = currentQty + amount;

			if (newQty < 1) {
				newQty = 1;
			}

			if (newQty > ${goodsVO.goods_stock}) {
				newQty = ${goodsVO.goods_stock};
			alert("재고 이상으로 구매할 수 없습니다.");
			}
			qtyInput.value = newQty;
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
               	<img alt="${goodsVO.goods_name}" src="${contextPath}/download.do?goods_num=${goodsVO.goods_num}&fileName=${image.fileName}">
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
				<%-- [수정] 수량 조절 UI를 테이블 안으로 이동시켰습니다. --%>
				<tr>
					<td class="fixed">수량</td>
					<td class="active">
						<div class="quantity-selector">
							<button onclick="changeQty(-1)">-</button>
							<input type="number" id="cart_goods_qty" value="1" min="1">
							<button onclick="changeQty(1)">+</button>
						</div>
					</td>
				</tr>
            </tbody>
        </table>

        <ul class="detail_buttons">
			<%-- [수정] 구매하기 버튼의 파라미터에서 수량 부분을 제거합니다. (스크립트에서 직접 가져오므로) --%>
            <li><a class="buy btn btn-primary" href="javascript:fn_order_each_goods('${goodsVO.goods_num}', '${goodsVO.goods_name}', '${goodsVO.goods_sales_price}', '${goodsImageList[0].fileName}', '${goodsVO.goods_point}');">구매하기</a></li>
            <li><a class="cart btn btn-primary" href="javascript:add_cart('${goodsVO.goods_num}');">장바구니</a></li>
            <li>
	            <c:set var="liked" value="${likedGoodsSet.contains(goodsVO.goods_num)}" />
				<input type="button" class="btn btn-danger ${liked ? 'like_on' : 'like_off'}" data-goods-num="${goodsVO.goods_num}" onclick="toggleLikeGoods(this)" value="관심상품" />
            </li>
        </ul>
    </div>

    <div class="clear"></div>

    <%-- 이하 상품소개, 리뷰 탭 등은 기존 코드와 동일 --%>
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
