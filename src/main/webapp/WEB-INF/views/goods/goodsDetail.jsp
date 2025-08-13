<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" isELIgnored="false"%>   
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="goods" value="${goodsMap.goodsVO}" />
<c:set var="imageList" value="${goodsMap.imageList}" />

<html>
<head>
<style>
#layer {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    visibility: hidden;
    background-color: rgba(0, 0, 0, 0.6);
    z-index: 1000;
    display: flex;
    justify-content: center;
    align-items: center;
}

#popup {
    background: white;
    padding: 40px;
    border-radius: 10px;
    text-align: center;
}

#close {
    position: absolute;
    top: 10px;
    right: 10px;
    cursor: pointer;
}
/* 스타일 생략, 필요하면 넣으세요 */
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- 상단은 그대로 유지됨 -->
<script type="text/javascript">

var contextPath = "${pageContext.request.contextPath}";

function add_cart(goods_num) {
    $.ajax({
        type: "post",
        url: contextPath + "/cart/addGoodsInCart.do",
        data: { goods_num: goods_num },
        success: function(data) {
            console.log("서버 응답:", data);

            if (data === 'add_success' || data === 'plus_success') {
                imagePopup('open');
            } else if (data === 'already_existed') {
                alert("이미 카트에 등록된 상품입니다."); 
            } else {
                alert("장바구니에 상품을 1개 추가하였습니다.: " + data);
            }
        },
        error: function(xhr, status, error) {
            console.error("Ajax 에러:", error);
            alert("에러가 발생했습니다.");
        }
    });
}

function imagePopup(type) {
    if (type == 'open') {
        $('#layer').css('visibility', 'visible');
        $('#layer').height($(document).height());
    } else if (type == 'close') {
        $('#layer').css('visibility', 'hidden');
    }
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
    i_fileName.name = "goods_fileName";
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
<!-- 이하 코드 동일 (HTML 구조, 상품 정보 출력 등) -->

</head>
<body>
    <hgroup>
<!--         <h1>컴퓨터와 인터넷</h1> -->
<!--         <h2>국내외 도서 &gt; 컴퓨터와 인터넷 &gt; 웹 개발</h2> -->
        <h3>${goods.goods_name}</h3>
        <h4>${goods.goods_maker} &nbsp;  | ${goods.goods_publisher}</h4>
    </hgroup>

<div id="goods_image">
    <figure>
        <c:forEach var="image" items="${imageList}" varStatus="status">
            <c:if test="${status.index == 0}">
                <img alt="${goods.goods_name}"
                     src="${contextPath}/goods/thumbnails.do?goods_num=${goods.goods_num}&fileName=${image.fileName}">
            </c:if>
        </c:forEach>
    </figure>
</div>

    <div id="detail_table">
        <table>
            <tbody>
               
                <tr class="dot_line">
                    <td class="fixed">판매가</td>
                    <td class="active">
                  
                         
		             <c:choose>
						  <c:when test="${goods.goods_sales_price != 0}">
						    <fmt:formatNumber value="${goods.goods_sales_price}" pattern="#,###원" />
						  </c:when>
						  <c:otherwise>
						    가격 정보가 없습니다.
						  </c:otherwise>
					</c:choose>

                    </td>
                </tr>
                
 
                <tr>
                    <td class="fixed">포인트적립</td>
                    <td class="active"> <fmt:formatNumber value= "${goods.goods_sales_price * goods.goods_point * 0.01}" maxFractionDigits="0"/>     P(10%적립)</td>
                </tr>
              

<!-- <tr> -->
<!--     <td class="fixed">발행일</td> -->
<!--     <td class="fixed"> -->
<%--         <fmt:formatDate value="${goods.goods_credate}" pattern="yyyy-MM-dd" /> --%>
<!--     </td> -->
<!-- </tr> -->
                <tr>
                    <td class="fixed">배송료</td>
                    <td class="fixed"><strong>무료</strong></td>
                </tr>
             
                <tr>
                    <td class="fixed">도착예정일</td>
                    <td class="fixed">지금 주문 시 내일 도착 예정</td>
                </tr>
                <tr>
                    <td class="fixed">수량</td>
                    <td class="fixed">
                        <select style="width: 60px;" id="order_goods_qty">
                            <option>1</option>
                            <option>2</option>
                            <option>3</option>
                            <option>4</option>
                            <option>5</option>
                        </select>
                    </td>
                </tr>
            </tbody>
        </table>
        <ul>
            <li><a class="buy" href="javascript:fn_order_each_goods('${goods.goods_num}', '${goods.goods_name}', '${goods.goods_sales_price}', '${goods.goods_fileName}');">구매하기</a></li>
            <li><a class="cart" href="javascript:add_cart('${goods.goods_num}');">장바구니</a></li>
            <li><a class="wish" href="#">위시리스트</a></li>
        </ul>
    </div>

    <div class="clear"></div>

    <!-- 탭 영역 -->
    <div id="container">
        <ul class="tabs">
            <li><a href="#tab1">상품소개</a></li>

          
            <li><a href="#tab6">리뷰</a></li>
        </ul>

        <div class="tab_container">
            <div class="tab_content" id="tab1">
                <h4>책소개</h4>
                <p>${fn:replace(goods.goods_intro,"/n", "<br/>")}</p>
                <c:forEach var="image" items="${imageList}">
                    <img src="${contextPath}/download.do?goods_num=${goods.goods_num}&fileName=${image.fileName}" alt="추가 이미지"/>
                </c:forEach>
            </div>
            <div class="tab_content" id="tab2">
                <h4>저자소개</h4>
                <div class="writer">저자 : ${goods.goods_maker}</div>
                <p>${fn:replace(goods.goods_goods_writer_intro, "/n", "<br/>")}</p>
            </div>
           
<!--             <div class="tab_content" id="tab4"> -->
<!--                 <h4>출판사서평</h4> -->
<!--                 <p></p> -->
<!--             </div> -->
           
            <div class="tab_content" id="tab6">
                <h4>리뷰</h4>
            </div>
        </div>
    </div>

    <div class="clear"></div>

    <div id="layer" style="visibility: hidden;">
        <div id="popup">
            <a href="javascript:" onclick="imagePopup('close');">
                <img src="${contextPath}/resources/image/close.png" id="close" alt="닫기"/>
        </a>
            <br/>
            <font size="12" id="contents">장바구니에 담았습니다.</font><br/>
            <form action="${contextPath}/cart/myCartList.do">
                <input type="submit" value="장바구니 보기"/>
            </form>
        </div>
    </div>

    <input type="hidden" name="isLogOn" id="isLogOn" value="${isLogOn}"/>


</body>
</html>
