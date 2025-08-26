<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="cartList" value="${cartList}" />

<head>
    <%-- jQuery를 먼저 로드하는 것이 좋습니다. --%>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script type="text/javascript">
		
		// [수정] 수량 변경 함수: 불필요한 동기식 ajax 호출을 제거하고,
		// 사용자 경험을 위해 페이지 새로고침 대신 화면 값만 바꾸도록 개선할 수 있습니다.
		// (지금은 기존 로직을 유지하되, index를 정확히 넘겨주도록 수정했습니다.)
		function modify_cart_qty(goods_num, index){
			var length=document.frm_order_all_cart.cart_goods_qty.length;
   			var _cart_goods_qty=0;
   			
			// 장바구니에 상품이 하나일 때와 여러 개일 때를 구분해서 수량 값을 가져옵니다.
			if(length > 1){
				_cart_goods_qty=document.frm_order_all_cart.cart_goods_qty[index].value;		
			}else{
				_cart_goods_qty=document.frm_order_all_cart.cart_goods_qty.value;
			}
		
			var cart_goods_qty = Number(_cart_goods_qty);
            if (cart_goods_qty <= 0) {
                alert("수량은 1 이상이어야 합니다.");
                return;
            }

			$.ajax({
				type : "post",
				url : "${contextPath}/cart/modifyCartQty.do",
				data : {
					goods_num: goods_num,
					cart_goods_qty: cart_goods_qty
				},
				success : function(data, textStatus) {
					if(data.trim()=='modify_success'){
						alert("수량을 변경했습니다!");
						// 변경 성공 시, 현재 페이지를 새로고침하여 합계 등을 다시 계산합니다.
						location.reload(); 
					}else{
						alert("다시 시도해 주세요!");	
					}			
				},
				error : function(data, textStatus) {
					alert("에러가 발생했습니다."+data);
				}
			});
		}

		// [수정] 상품 삭제 함수: 불필요한 form 생성을 제거하고 jQuery ajax로 개선할 수 있습니다.
		// (지금은 기존 로직을 유지합니다.)
		function delete_cart_goods(cart_id){
			if (!confirm("정말로 이 상품을 삭제하시겠습니까?")) {
				return;
			}
			var formObj=document.createElement("form");
			var i_cart = document.createElement("input");
			i_cart.name="cart_id";
			i_cart.value=cart_id;
	
			formObj.appendChild(i_cart);
    		document.body.appendChild(formObj); 
    		formObj.method="post";
    		formObj.action="${contextPath}/cart/removeCartGoods.do";
    		formObj.submit();
		}

		// [핵심 수정] 개별 상품 주문 함수
		// 어떤 버튼을 눌렀는지 알 수 있도록 'index'를 파라미터로 추가합니다.
		function fn_order_each_goods(goods_num, goods_name, goods_sales_price, fileName, goods_point, index){
			var _order_goods_qty;
			var cart_goods_qty_inputs = document.getElementsByName("cart_goods_qty");

			// 여러 상품 중, 클릭된 버튼과 같은 줄에 있는(index가 같은) 수량 입력칸의 값을 가져옵니다.
			// 상품이 하나만 있을 경우를 대비하여 length 체크를 합니다.
			if (cart_goods_qty_inputs.length > 1) {
				_order_goods_qty = cart_goods_qty_inputs[index].value;
			} else {
				_order_goods_qty = cart_goods_qty_inputs[0].value;
			}
			
			if (Number(_order_goods_qty) <= 0) {
				alert("주문 수량은 1 이상이어야 합니다.");
				return;
			}

			// form을 동적으로 생성하여 서버에 데이터를 전송합니다.
			var formObj=document.createElement("form");
			
			// input 태그들을 생성하고 form에 추가합니다.
			var i_goods_num = document.createElement("input"); 
    		var i_goods_name = document.createElement("input");
    		var i_goods_sales_price=document.createElement("input");
    		var i_fileName=document.createElement("input");
    		var i_goods_qty=document.createElement("input"); // 변수명 통일 (order_goods_qty -> goods_qty)
    		var i_goods_point = document.createElement("input");
    		
    		i_goods_num.name="goods_num";
    		i_goods_name.name="goods_name";
    		i_goods_sales_price.name="goods_sales_price";
    		i_fileName.name="fileName";
    		i_goods_qty.name="goods_qty"; // 컨트롤러에서 받을 이름과 통일
			i_goods_point.name="point";

    		i_goods_num.value=goods_num;
    		i_goods_qty.value=_order_goods_qty;
    		i_goods_name.value=goods_name;
    		i_goods_sales_price.value=goods_sales_price;
    		i_fileName.value=fileName;
    		i_goods_point.value=goods_point;
    		
    		formObj.appendChild(i_goods_num);
    		formObj.appendChild(i_goods_name);
    		formObj.appendChild(i_goods_sales_price);
    		formObj.appendChild(i_fileName);
    		formObj.appendChild(i_goods_qty);
    		formObj.appendChild(i_goods_point);
    		
    		document.body.appendChild(formObj); 
    		formObj.method="post";
    		formObj.action="${contextPath}/order/orderEachGoods.do";
    		formObj.submit();
		}

		// [수정] 선택 상품 주문 함수: 기존 로직은 훌륭해서 그대로 유지합니다.
		function fn_order_all_cart_goods(){
		    var checkedItems = $("input[name='checked_goods']:checked");

		    if (checkedItems.length === 0) {
		        alert("주문할 상품을 선택해주세요.");
		        return;
		    }
		    
		    var newForm = document.createElement("form");
		    newForm.method = "post";
		    newForm.action = "${contextPath}/order/orderAllCartGoods.do";

		    checkedItems.each(function() {
		        var row = $(this).closest('tr');
		        var goods_num = $(this).val();
		        var cart_goods_qty = row.find("input[name='cart_goods_qty']").val();

		        var goodsNumInput = document.createElement("input");
		        goodsNumInput.type = "hidden";
		        goodsNumInput.name = "goods_num";
		        goodsNumInput.value = goods_num;
		        newForm.appendChild(goodsNumInput);

		        var goodsQtyInput = document.createElement("input");
		        goodsQtyInput.type = "hidden";
		        goodsQtyInput.name = "cart_goods_qty";
		        goodsQtyInput.value = cart_goods_qty;
		        newForm.appendChild(goodsQtyInput);
		    });

		    document.body.appendChild(newForm);
		    newForm.submit();
		}
	</script>
</head>
<body>
<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
        <div class="col bg-light p-5 text-start">
            <h2 class="fw-bold">장바구니</h2>
        </div>
    </div>
		<form name="frm_order_all_cart">
		<table class="table">
			<tbody align=center>
			    <c:set var="totalGoodsPrice" value="0" />
    			<c:set var="totalGoodsNum" value="0" />
				<c:set var="totalDeliveryPrice" value="0" />
				
				<tr style="background: #33ff00">
					<td class="fixed">구분</td>
					<td>이미지</td>
					<td>상품명</td>
					<td>판매가</td>
					<td>수량</td>
					<td>합계</td>
					<td>주문</td>
				</tr>
				<c:choose>
					<c:when test="${ empty cartList}">
						<tr>
							<td colspan=8 class="fixed"><strong>장바구니에 상품이 없습니다.</strong></td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:forEach var="item" items="${cartList}" varStatus="loop">
                        	<tr>
								<td>
									<input type="checkbox" name="checked_goods" checked value="${item.goods_num}">
								</td>
								<td class="goods_image">
								    <a href="${contextPath}/goods/goodsDetail.do?goods_num=${item.goods_num}">
										<img width="75" alt="${item.goods_name}" src="${contextPath}/download.do?goods_num=${item.goods_num}&fileName=${item.fileName}" />
								    </a>
								</td>
								<td>
								    <a href="${contextPath}/goods/goodsDetail.do?goods_num=${item.goods_num}" style="color:blue;">${item.goods_name}</a>
								</td>
								<td>
								    <strong><fmt:formatNumber value="${item.goods_sales_price}" type="number" pattern="#,###원" /></strong>
								</td>
								<td>
									<%-- [수정] 수량 변경 함수에 현재 아이템의 순서(loop.index)를 넘겨줍니다. --%>
								    <input type="text" name="cart_goods_qty" size="3" value="${item.cart_goods_qty}">
									<a href="javascript:modify_cart_qty(${item.goods_num}, ${loop.index});">
										<img width="25" alt="수량변경" src="${contextPath}/resources/image/btn_modify_qty.jpg">
								   	</a>
								</td>
								<td>
								    <strong><fmt:formatNumber value="${item.goods_sales_price * item.cart_goods_qty}" type="number" pattern="#,###원" /></strong>
								</td>
								<td>
									<%-- [핵심 수정] 개별 주문 함수에 현재 아이템의 순서(loop.index)를 함께 넘겨줍니다. --%>
								    <a href="javascript:fn_order_each_goods('${item.goods_num}','${item.goods_name}','${item.goods_sales_price}','${item.fileName}', '${item.goods_point}', ${loop.index});" class="btn btn-primary"style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;">주문하기</a>
									<a href="javascript:delete_cart_goods('${item.cart_id}');" class="btn btn-danger"style="--bs-btn-padding-y: .25rem; --bs-btn-padding-x: .5rem; --bs-btn-font-size: .75rem;">삭제하기</a>
								</td>
							</tr>
                            <c:set var="totalGoodsPrice" value="${totalGoodsPrice + (item.goods_sales_price * item.cart_goods_qty)}" />
                            <c:set var="totalGoodsNum" value="${totalGoodsNum + 1}" />
                        </c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
		<br><br>
		<table width=80% class="table" style="background: #cacaff">
			<tbody>
				<tr align=center class="fixed">
					<td class="fixed">총 항목 수</td>
					<td>총 상품금액</td>
					<td></td>
					<td>총 배송비</td>
					<td></td>
					<td></td>
					<td>최종 결제금액</td>
				</tr>
				<tr cellpadding=40 align=center>
					<td id="">
						<p id="p_totalGoodsNum">${totalGoodsNum}개</p> 
						<input id="h_totalGoodsNum" type="hidden" value="${totalGoodsNum}" />
					</td>
					<td>
						<p id="p_totalGoodsPrice">
							<fmt:formatNumber value="${totalGoodsPrice}" type="number" var="total_goods_sales_price" />${total_goods_sales_price}원
						</p> 
						<input id="h_totalGoodsPrice" type="hidden" value="${totalGoodsPrice}" />
					</td>
					<td><img width="25" alt="" src="${contextPath}/resources/image/plus.jpg"></td>
					<td>
						<p id="p_totalDeliveryPrice">${totalDeliveryPrice }원</p> 
						<input id="h_totalDeliveryPrice" type="hidden" value="${totalDeliveryPrice}" />
					</td>
					<td><img width="25" alt="" src="${contextPath}/resources/image/equal.jpg"></td>
					<td colspan="2">
						<p id="p_final_totalPrice">
							<fmt:formatNumber value="${totalGoodsPrice+totalDeliveryPrice}" type="number" var="total_price" />${total_price}원
						</p> 
						<input id="h_final_totalPrice" type="hidden" value="${totalGoodsPrice+totalDeliveryPrice}" />
					</td>
				</tr>
			</tbody>
		</table>
	<center>
	<br><br> 
		<a href="javascript:fn_order_all_cart_goods()" class="btn btn-primary">주문하기</a>
		<a href="${contextPath}/goods/goodsListByCategory.do?goods_category=사료" class="btn btn-outline-secondary">쇼핑 계속하기</a>
	<center>
	</form>			
</div>
</body>
