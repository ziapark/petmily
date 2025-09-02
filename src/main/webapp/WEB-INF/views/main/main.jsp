<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"	isELIgnored="false"
%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<%
  request.setCharacterEncoding("UTF-8");
%>

<c:if test="${not empty sessionScope.message}">
  	<script>alert("${sessionScope.message}");</script>
  	<c:remove var="message" scope="session" />
</c:if>
<div class="mainbanner_wrap">
	<div id="carouselExampleCaptions" class="carousel slide">

		<div class="carousel-inner">
		  	<div class="carousel-item active" data-bs-interval="3000">
		    	<img src="${contextPath}/resources/image/main_banner1.png" class="d-block w-100" alt="메인배너1">
		  	</div>
		  	
		</div>
		<button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide="prev">
			<span class="carousel-control-prev-icon" aria-hidden="true"></span>
			<span class="visually-hidden">Previous</span>
		</button>
		<button class="carousel-control-next" type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide="next">
		  	<span class="carousel-control-next-icon" aria-hidden="true"></span>
		  	<span class="visually-hidden">Next</span>
		</button>
	</div>
</div>

<!-- 메인하단 본문영역 start -->
<div class="contents_wrap">
	<!-- 날씨정보 start -->
	<div class="weather_wrap">
		<div class="weather_api_box container">
			<h3 style="margin:30px 0 40px 0">날씨맞춤 상품추천</h3>
			<div class="row weather_box_wrap">	
				<div class="">
						<!--카카오맵 <div id="map" style="height:300px;">위치 정보를 불러오는 중...</div> -->
						<span class="lacation_tt">우리동네 날씨 - </span><span id="locationDisplay" class="mt-2 text-primary fw-bold"></span>
					</div>
				<div class="weather_box col">
					
			  		<h3 class="am_h3">오전</h3>
			  		<c:if test="${not empty avgWeatherMap['오전']}">
				    	
			      		<div class="wt_ct"><span class="wt_tt">평균온도&nbsp;&nbsp;</span><fmt:formatNumber value="${avgWeatherMap['오전'].temperature}" pattern="0.0"/> ℃</div>
			      		<div class="wt_ct"><span class="wt_tt">하늘&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>${avgWeatherMap['오전'].sky}</div>
			      		<div class="wt_ct"><span class="wt_tt">강수형태&nbsp;&nbsp;</span>${avgWeatherMap['오전'].precipitation}</div>
			      		<div class="wt_ct"><span class="wt_tt">강수확률&nbsp;&nbsp;</span>${avgWeatherMap['오전'].pop}%</div>
				    	
			  		</c:if>
				</div>
				<div class="weather_box col">
			  		<h3 class="pm_h3">오후</h3>
			  		<c:if test="${not empty avgWeatherMap['오후']}">
				    	
				    	<div class="wt_ct"><span class="wt_tt">평균온도&nbsp;&nbsp;</span><fmt:formatNumber value="${avgWeatherMap['오후'].temperature}" pattern="0.0"/> ℃</div>
				      	<div class="wt_ct"><span class="wt_tt">하늘&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>${avgWeatherMap['오후'].sky}</div>	
				      	<div class="wt_ct"><span class="wt_tt">강수형태&nbsp;&nbsp;</span>${avgWeatherMap['오후'].precipitation}</div>	
				      	<div class="wt_ct"><span class="wt_tt">강수확률&nbsp;&nbsp;</span>${avgWeatherMap['오후'].pop}%</div>
				      	
			  		</c:if>
				</div>	
			</div>
		</div>
		<div class="weather_goods container">
			<div class="row">
				<h3 style="font-size: 1.0rem;">${weatherRecommendation.weatherCondition} - ${weatherRecommendation.comment}</h3>
				<ul>
		  			<c:forEach var="goods" items="${weatherRecommendation.goodsList}">
		    		<li class="goods_item">
		      		<a href="${contextPath}/goods/goodsDetail.do?goods_num=${goods.goods_num}">
		        		<img src="${contextPath}/download.do?goods_num=${goods.goods_num}&fileName=${goods.fileName}" alt="${goods.goods_name}" width="120">		        
		      		</a>
		      		<p>${goods.goods_name}</p>
		      		<p style="text-align:right;">${goods.goods_sales_price} 원</p>
				    </li>
				  </c:forEach>
				</ul>
			</div>
		</div>
</div>
<!-- 날씨정보 end -->

<div class="clear"></div>

	<!-- 베스트 관심 상품 start-->
	
 	<div class="best_wishlist container">
		<div class="row">
			<h3>베스트 관심상품</h3>
			<p class="h34">관심상품으로 가장 많이 선택된 인기순 BEST 상품입니다.</p>
			<ul>
			<c:forEach var="wish" items="${wishlist}">
				<li class="wish_item">
					<a href="${contextPath}/goods/goodsDetail.do?goods_num=${wish.goods_num}">
						<img src="${contextPath}/download.do?goods_num=${wish.goods_num}&fileName=${wish.goods_fileName}" alt="${wish.goods_name}" width="120">
					</a>
					<p>${wish.goods_name}</p>
		      		<p style="text-align:right;">${wish.goods_sales_price} 원</p>
				</li>
			</c:forEach>
			</ul>
		</div>
	</div>
 
 	<!-- 베스트 관심 상품 end -->
 	
</div>

<!-- 메인하단 본문영역 end -->
<div class="clear"></div>

