<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="cartList" value="${cartList}" />

<head>
	<script type="text/javascript">
		function calcGoodsPrice(bookPrice,obj){
			var totalPrice,final_total_price,totalNum;
			var goods_qty=document.getElementById("select_goods_qty");
			//alert("총 상품금액"+goods_qty.value);
			var p_totalNum=document.getElementById("p_totalNum");
			var p_totalPrice=document.getElementById("p_totalPrice");
			var p_final_totalPrice=document.getElementById("p_final_totalPrice");
			var h_totalNum=document.getElementById("h_totalNum");
			var h_totalPrice=document.getElementById("h_totalPrice");
			var h_totalDelivery=document.getElementById("h_totalDelivery");
			var h_final_total_price=document.getElementById("h_final_totalPrice");
			if(obj.checked==true){	
				totalNum=Number(h_totalNum.value)+Number(goods_qty.value);
				totalPrice=Number(h_totalPrice.value)+Number(goods_qty.value*bookPrice);
				final_total_price=totalPrice+Number(h_totalDelivery.value);
			}else{
				totalNum=Number(h_totalNum.value)-Number(goods_qty.value);
				totalPrice=Number(h_totalPrice.value)-Number(goods_qty.value)*bookPrice;
				final_total_price=totalPrice-Number(h_totalDelivery.value);
			}
	
			h_totalNum.value=totalNum;
			h_totalPrice.value=totalPrice;
			h_final_total_price.value=final_total_price;
	
			p_totalNum.innerHTML=totalNum;
			p_totalPrice.innerHTML=totalPrice;
			p_final_totalPrice.innerHTML=final_total_price;
		}

		function modify_cart_qty(goods_num,bookPrice,index){
			var length=document.frm_order_all_cart.cart_goods_qty.length;
   			var _cart_goods_qty=0;
			if(length>1){
				_cart_goods_qty=document.frm_order_all_cart.cart_goods_qty[index].value;		
			}else{
				_cart_goods_qty=document.frm_order_all_cart.cart_goods_qty.value;
			}
		
			var cart_goods_qty=Number(_cart_goods_qty);

			$.ajax({
				type : "post",
				async : false, //false인 경우 동기식으로 처리한다.
				url : "${contextPath}/cart/modifyCartQty.do",
				data : {
					goods_num:goods_num,
					cart_goods_qty:cart_goods_qty
				},
				success : function(data, textStatus) {
					if(data.trim()=='modify_success'){
						alert("수량을 변경했습니다!!");
						window.location.href = "${contextPath}/cart/myCartList.do";
					}else{
						alert("다시 시도해 주세요!!");	
					}			
				},
				error : function(data, textStatus) {
					alert("에러가 발생했습니다."+data);
				}
			}); //end ajax	
		}

		function delete_cart_goods(cart_id){
			var cart_id=Number(cart_id);
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

		function fn_order_each_goods(goods_num,goods_name,goods_sales_price,fileName){
			var total_price,final_total_price,_goods_qty;
			var cart_goods_qty=document.getElementById("cart_goods_qty");
	
			_order_goods_qty=cart_goods_qty.value; //장바구니에 담긴 개수 만큼 주문한다.
			var formObj=document.createElement("form");
			var i_goods_num = document.createElement("input"); 
    		var i_goods_name = document.createElement("input");
    		var i_goods_sales_price=document.createElement("input");
    		var i_fileName=document.createElement("input");
    		var i_order_goods_qty=document.createElement("input");
    
    		i_goods_num.name="goods_num";
    		i_goods_name.name="goods_name";
    		i_goods_sales_price.name="goods_sales_price";
    		i_fileName.name="fileName";
    		i_order_goods_qty.name="order_goods_qty";
    
    		i_goods_num.value=goods_num;
    		i_order_goods_qty.value=_order_goods_qty;
    		i_goods_name.value=goods_name;
    		i_goods_sales_price.value=goods_sales_price;
    		i_fileName.value=fileName;
    
    		formObj.appendChild(i_goods_num);
    		formObj.appendChild(i_goods_name);
    		formObj.appendChild(i_goods_sales_price);
    		formObj.appendChild(i_fileName);
    		formObj.appendChild(i_order_goods_qty);

    		document.body.appendChild(formObj); 
    		formObj.method="post";
    		formObj.action="${contextPath}/order/orderEachGoods.do";
    		formObj.submit();
		}

		function fn_order_all_cart_goods(){
			var order_goods_qty;
			var order_goods_num;
			var objForm=document.frm_order_all_cart;
			var cart_goods_qty=objForm.cart_goods_qty;
			var h_order_each_goods_qty=objForm.h_order_each_goods_qty;
			var checked_goods=objForm.checked_goods;
			var length=checked_goods.length;
	
			if(length>1){
				for(var i=0; i<length;i++){
					if(checked_goods[i].checked==true){
						order_goods_num=checked_goods[i].value;
						order_goods_qty=cart_goods_qty[i].value;
						cart_goods_qty[i].value="";
						cart_goods_qty[i].value=order_goods_qty;
						console.log(cart_goods_qty[i].value);
					}
				}	
			}else{
				order_goods_num=checked_goods.value;
				order_goods_qty=cart_goods_qty.value;
				cart_goods_qty.value=order_goods_qty;
			}
		
 			objForm.method="post";
 			objForm.action="${contextPath}/order/orderAllCartGoods.do";
			objForm.submit();
		}
	</script>
</head>
<body>
	<div class="container text-center mt-3 mb-3">
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
								    <h2><a href="${contextPath}/goods/goodsDetail.do?goods_num=${item.goods_num}">${item.goods_name}</a></h2>
								</td>
								<td>
								    <strong><fmt:formatNumber value="${item.goods_sales_price}" type="number" pattern="#,###원" /></strong>
								</td>
								<td>
								    <input type="text" name="cart_goods_qty" size="3" value="${item.cart_goods_qty}">
									<a href="javascript:modify_cart_qty(${item.goods_num}, ${loop.index});">
										<img width="25" alt="수량변경" src="${contextPath}/resources/image/btn_modify_qty.jpg">
								   	</a>
								</td>
								<td>
								    <strong><fmt:formatNumber value="${item.goods_sales_price * item.cart_goods_qty}" type="number" pattern="#,###원" /></strong>
								</td>
								<td>
								    <a href="javascript:fn_order_each_goods('${item.goods_num}','${item.goods_name}','${item.goods_sales_price}','${item.fileName}');">
										<img width="75" alt="주문하기" src="${contextPath}/resources/image/btn_order.jpg">
									</a><br>
									<a href="javascript:delete_cart_goods('${item.cart_id}');">
										<img width="75" alt="삭제하기" src="${contextPath}/resources/image/btn_delete.jpg">
								    </a>
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
		<a href="javascript:fn_order_all_cart_goods()">
			<img width="75" alt="주문하기" src="${contextPath}/resources/image/btn_order_final.jpg">
		</a>
		<a href="${contextPath}/goods/goodsListByCategory.do?goods_category=사료">
			<img width="75" alt="쇼핑계속하기" src="${contextPath}/resources/image/btn_shoping_continue.jpg">
		</a>
	<center>
	</form>			
</div>