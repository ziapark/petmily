<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />
<%
  request.setCharacterEncoding("utf-8");
%>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
	
	<script src="${contextPath}/resources/jquery/jquery-1.6.2.min.js" type="text/javascript"></script>
	<script src="${contextPath}/resources/jquery/jquery.easing.1.3.js" type="text/javascript"></script>
	<script src="${contextPath}/resources/jquery/stickysidebar.jquery.js" type="text/javascript"></script>
	<script src="${contextPath}/resources/jquery/basic-jquery-slider.js" type="text/javascript"></script>
	<script src="${contextPath}/resources/jquery/tabs.js" type="text/javascript"></script>
	<script src="${contextPath}/resources/jquery/carousel.js" type="text/javascript"></script>
	<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=0351a11278cad14d12e263429c917675&libraries=services"></script>
	
	<link href="${contextPath}/resources/css/main.css" rel="stylesheet" type="text/css" media="screen">
	<link href="${contextPath}/resources/css/mobile.css" rel="stylesheet" type="text/css">
	<link href="${contextPath}/resources/css/common.css" rel="stylesheet" type="text/css" media="screen">
	<script>
		// 슬라이드 
		$(document).ready(function() {
			$('#ad_main_banner').bjqs({
				'width' : 775,
				'height' : 145,
				'showMarkers' : true,
				'showControls' : false,
				'centerMarkers' : false
			});
		});
		// 스티키 		
		$(function() {
			$("#sticky").stickySidebar({
				timer : 100,
				easing : "easeInBounce"
			});
		});
	</script>
	<title><jsp:include page="${title}" /></title>
</head>
<body> 
	<div>		
		<header>
			   <jsp:include page="header.jsp" />
		</header>
		<div class="clear"></div>
		<div id="wrap">
			<article>
				<jsp:include page="${body}" /> 
			</article> 
			<div class="clear"></div>
			<footer>
        		<jsp:include page="footer.jsp"/>
        	</footer>
		</div>
		 <jsp:include page="quickMenu.jsp"/>
    </div>        	
    <script>
    
    const contextPath = '${pageContext.request.contextPath}';
    
    //카카오맵 api- 사용자 동네정보 얻기 
	function sendLocationToServer(lat, lon) {
		fetch(contextPath + '/location', {
	    method: 'POST',
	    headers: { 'Content-Type': 'application/json' },
	    body: JSON.stringify({ latitude: lat, longitude: lon })
	  })
	  .then(res => res.json())
	  .then(data => {
	    // 서버가 보내준 위치명 화면에 표시 (예: 대전 유성구)
	    document.getElementById('locationDisplay').innerText = data.address || "위치 정보 없음";
	  })
	  .catch(err => {
	    console.error("위치 전송 오류:", err);
	  });
	}
	
	function requestUserLocation() {
	  if (navigator.geolocation) {
	    navigator.geolocation.getCurrentPosition(
	      position => {
	        sendLocationToServer(position.coords.latitude, position.coords.longitude);
	      },
	      error => {
	        console.error("위치 정보 요청 거부됨 또는 오류", error);
	      }
	    );
	  } else {
	    alert("위치 정보가 지원되지 않는 브라우저입니다.");
	  }
	}
	
	window.onload = () => {
        <c:if test="${not empty message}">
        	alert("${message}");
    	</c:if>
    
	  	requestUserLocation();
	}
	
	navigator.geolocation.getCurrentPosition(function(position) {
	    var lat = position.coords.latitude;
	    var lng = position.coords.longitude;
	    console.log("현재위치:", lat, lng);
	
	   /* var container = document.getElementById('map');
	    var options = {
	        center: new kakao.maps.LatLng(lat, lng),
	        level: 3
	    };
	    var map = new kakao.maps.Map(container, options);
	
	    // 마커 찍기
	    var marker = new kakao.maps.Marker({
	        position: new kakao.maps.LatLng(lat, lng)
	    });
	    marker.setMap(map);*/
	}, function(error) {
	    console.error('위치 정보를 가져오는데 실패했습니다.', error);
	});
</script>
</body>      
        
        