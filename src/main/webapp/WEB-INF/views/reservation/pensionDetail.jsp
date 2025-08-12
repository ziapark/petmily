<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${pension.p_name} 상세 정보</title>
<style>
    .pension-detail { 
        width: 80%; 
        max-width: 800px;
        margin: 20px auto; 
        border: 1px solid #ddd; 
        padding: 30px; /* 안쪽 여백을 좀 더 줍니다 */
        border-radius: 8px; 
    }
    .pension-detail h2 { 
        border-bottom: 2px solid #007bff; 
        padding-bottom: 10px; 
        text-align: center;
        margin-bottom: 25px; /* 제목과 이미지 사이 여백 */
    }
    .pension-detail p { 
        font-size: 1.1em; 
        line-height: 1.6; 
    }
    .pension-detail .label { 
        font-weight: bold; 
        color: #555; 
        display: inline-block; 
        width: 120px;
    }
    .pension-main-image {
        width: 350px;
        height: auto;
        border-radius: 8px;
        margin: 15px 0 25px 0;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    
    /* ▼▼▼ 버튼 스타일 추가 ▼▼▼ */
    .button-container {
        text-align: center; /* 버튼들을 중앙에 정렬 */
        margin-top: 40px;
        padding-top: 20px;
        border-top: 1px solid #eee; /* 구분선 추가 */
    }
    .button-container a {
        text-decoration: none;
        padding: 12px 25px;
        border-radius: 5px;
        font-size: 1.1em;
        font-weight: bold;
        margin: 0 10px;
        transition: all 0.2s ease-in-out;
        display: inline-block;
    }
    .reserve-button {
        background-color: #007bff;
        color: white;
        border: 1px solid #007bff;
    }
    .reserve-button:hover {
        background-color: #0056b3;
        transform: scale(1.05); /* 살짝 커지는 효과 */
    }
    .back-button {
         background-color: #6c757d;
         color: white;
         border: 1px solid #6c757d;
    }
    .back-button:hover {
        background-color: #5a6268;
    }
</style>
</head>
<body>
    <div class="pension-detail">
        <h2>${pension.p_name}</h2>
        
        <div>
            <img src="${contextPath}/thumbnails.do?goods_id=${pension.p_num}" alt="${pension.p_name} 대표 이미지" class="pension-main-image"
                 onerror="this.onerror=null; this.src='${contextPath}/resources/image/default_pension.png';">
        </div>
        
        <p><span class="label">연락처:</span> ${pension.tel1}-${pension.tel2}-${pension.tel3}</p>
        <p><span class="label">체크인:</span> ${pension.checkin_time}</p>
        <p><span class="label">체크아웃:</span> ${pension.checkout_time}</p>
        <p><span class="label">주요 시설:</span></p>
        <div>${pension.facilities}</div>
        <hr>
        <p><span class="label">상세 설명:</span></p>
        <div>${pension.description}</div>
        
        <div class="button-container">
            <a href="${contextPath}/reservation/pensionList.do" class="back-button">목록으로</a>
            <a href="${contextPath}/reservation/reservationForm.do?p_num=${pension.p_num}" class="reserve-button">예약하기</a>
        </div>
         </div>
</body>
</html>











	
	<head>
	  <meta charset="utf-8">
	  <title>카카오맵 마커 테스트</title>
	  <style>
	    #map {
	      width: 100%;
	      height: 400px;
	    }
	  </style>
	  <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4ba40da625f31c62dc8b1b85842e096b&libraries=services"></script>
	</head>
	<body>

	<h2>마커 테스트</h2>
	<div id="map"></div>

	<script>
	  var container = document.getElementById('map');
	  var options = {
	    center: new kakao.maps.LatLng(37.5665, 126.9780),
	    level: 3
	  };

	  var map = new kakao.maps.Map(container, options);
	  var geocoder = new kakao.maps.services.Geocoder();

	  var address = "서울특별시 중구 퇴계로 100";

	  geocoder.addressSearch(address, function(result, status) {
	    if (status === kakao.maps.services.Status.OK) {
	      var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
	      console.log("좌표:", coords);

	      var marker = new kakao.maps.Marker({
	        map: map,
	        position: coords
	      });

	      console.log("마커 생성 완료");

	      map.setCenter(coords);
	    } else {
	      alert("주소 찾기 실패");
	    }
	  });
	</script>









