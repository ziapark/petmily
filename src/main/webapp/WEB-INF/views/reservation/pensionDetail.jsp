<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${pension.p_name} 상세 정보</title>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey= 여기에_발급받은_Javascript_키를_입력하세요 &libraries=services"></script>

<style>
    .pension-detail { width: 800px; margin: 20px auto; padding: 20px; }
    .map-container { margin-top: 30px; }
    #map { width:100%; height:400px; border:1px solid #ccc; }
</style>
</head>
<body>
    <div class="pension-detail">
        
        <h2>${pension.p_name}</h2>
        <hr>
        
        <p><strong>연락처:</strong> ${pension.tel1}-${pension.tel2}-${pension.tel3}</p>
        <p><strong>상세 설명:</strong></p>
        <div>${pension.description}</div>
        
        <div class="map-container">
            <h3>찾아오시는 길</h3>
            <div id="map"></div>
        </div>
        
    </div>

    <script>
        var mapContainer = document.getElementById('map'); 
        var options = { 
            center: new kakao.maps.LatLng(37.5665, 126.9780),
            level: 4 
        };
        var map = new kakao.maps.Map(mapContainer, options); 
        var geocoder = new kakao.maps.services.Geocoder();

        // Controller에서 넘겨준 주소
        // PensionVO 객체 안에 있는 business 객체의 roadAddress 속성으로 접근하도록 수정
        var address = "${pension.business.roadAddress}";

        // 주소로 좌표를 검색합니다
        geocoder.addressSearch(address, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);

                var marker = new kakao.maps.Marker({
                    map: map,
                    position: coords
                });

                var infowindow = new kakao.maps.InfoWindow({
                    content: `<div style="width:150px;text-align:center;padding:6px 0;">${pension.p_name}</div>`
                });
                infowindow.open(map, marker);

                map.setCenter(coords);
            } else {
                mapContainer.innerHTML = "<p style='text-align:center; padding-top: 150px;'>위치 정보를 불러올 수 없습니다.</p>";
            }
        });
    </script>
</body>
</html>