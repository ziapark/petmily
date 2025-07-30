<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"	isELIgnored="false"
	%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<%
  request.setCharacterEncoding("UTF-8");
%>  
<!-- 메인배너 start -->
<div class="mainbanner_wrap">
	<div id="carouselExampleCaptions" class="carousel slide" data-bs-ride="carousel">
		<div class="carousel-indicators">
		  <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
		  <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="1" aria-label="Slide 2"></button>
		  <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="2" aria-label="Slide 3"></button>
		</div>
		<div class="carousel-inner">
		  <div class="carousel-item active" data-bs-interval="3000">
		    <img src="..." class="d-block w-100" alt="...">
		    <div class="carousel-caption d-none d-md-block">
		      <h5>First slide label</h5>
		      <p>Some representative placeholder content for the first slide.</p>
		    </div>
		  </div>
		  <div class="carousel-item" data-bs-interval="3000">
		    <img src="..." class="d-block w-100" alt="...">
		    <div class="carousel-caption d-none d-md-block">
		      <h5>Second slide label</h5>
		      <p>Some representative placeholder content for the second slide.</p>
		    </div>
		  </div>
		  <div class="carousel-item" data-bs-interval="3000">
		    <img src="..." class="d-block w-100" alt="...">
		    <div class="carousel-caption d-none d-md-block">
		      <h5>Third slide label</h5>
		      <p>Some representative placeholder content for the third slide.</p>
		    </div>
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
<!-- 메인배너 end -->
<!-- 메인하단 본문영역 start -->
<div class="contents_wrap">

<!-- 날씨정보 start -->
<div class="weather_wrap">
	<h2>날씨정보</h2>
	<div class="weather_api_box container">
		<div class="row">
			<div class="col">날씨정보 표시란 </div>
			<div class="weather_comment col">코멘트 출력 ex) 오늘은 자외선 지수가 높아요! 저녁에 산책해보시는건 어떨까요?</div>
		</div>
	</div>

	<div class="weather_goods container">
		<div class="row">
			<div class="col"><div class="goods_item">날씨기반 추천상품1</div></div>
			<div class="col"><div class="goods_item">날씨기반 추천상품2</div></div>
			<div class="col"><div class="goods_item">날씨기반 추천상품3</div></div>
		</div>
	</div>
</div>
<!-- 날씨정보 end -->


<!-- 베스트제품 start -->
	<div class="main_book">
	   <c:set  var="goods_count" value="0" />
		<h3>베스트제품</h3>
		<c:forEach var="item" items="${goodsMap.bestseller }">
		   <c:set  var="goods_count" value="${goods_count+1 }" />
			<div class="book">
				<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">
				<img class="link"  src="${contextPath}/resources/image/1px.gif"> 
				</a> 
					<img width="121" height="154" 
					     src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
	
				<div class="title">${item.goods_title }</div>
				<div class="price">
			  	   <fmt:formatNumber  value="${item.goods_price}" type="number" var="goods_price" />
			          ${goods_price}원
				</div>
			</div>
		   <c:if test="${goods_count==15   }">
	         <div class="book">
	           <font size=20> <a href="#">more</a></font>
	         </div>
	     </c:if>
	  </c:forEach>
	</div>
<!-- 베스트제품 end -->
	<div class="clear"></div>
<!-- 신상품 start -->	
	<div class="main_book" >
	<c:set  var="goods_count" value="0" />
		<h3>신상품</h3>
		<c:forEach var="item" items="${goodsMap.newbook }" >
		   <c:set  var="goods_count" value="${goods_count+1 }" />
			<div class="book">
			  <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">
		       <img class="link"  src="${contextPath}/resources/image/1px.gif"> 
		      </a>
			 <img width="121" height="154" 
					src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
			<div class="title">${item.goods_title }</div>
			<div class="price">
			    <fmt:formatNumber  value="${item.goods_price}" type="number" var="goods_price" />
			       ${goods_price}원
			  </div>
		</div>
		 <c:if test="${goods_count==15   }">
	     <div class="book">
	       <font size=20> <a href="#">more</a></font>
	     </div>
	   </c:if>
		</c:forEach>
	</div>
<!-- 신상품 end -->	
</div>



<!-- 메인하단 본문영역 end -->
<div class="clear"></div>