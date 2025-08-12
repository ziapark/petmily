<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${pension.p_name} - 상세 정보</title>

<%-- 카카오맵 API (수정하지 않음) --%>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=YOUR_KAKAO_APP_KEY&libraries=services"></script>

<style>
    body {
        font-family: 'Malgun Gothic', sans-serif;
        background-color: #f4f7f6;
        color: #333;
        margin: 0;
    }
    .main-container {
        width: 90%;
        max-width: 1100px;
        margin: 30px auto;
    }
    .header-title {
        text-align: center;
        font-size: 2.5rem;
        color: #2c3e50;
        margin-bottom: 20px;
    }

    /* 공통 카드 스타일 */
    .card {
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 6px 12px rgba(0,0,0,0.08);
        padding: 25px;
        margin-bottom: 30px;
    }

    /* 펜션 정보 섹션 */
    .pension-details-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
    }
    .pension-details-grid p {
        margin: 5px 0;
        font-size: 1rem;
        color: #555;
    }
    .pension-details-grid strong {
        color: #34495e;
    }
    .pension-description {
        grid-column: 1 / -1; /* 전체 너비 차지 */
        margin-top: 15px;
        padding-top: 15px;
        border-top: 1px solid #eee;
    }
    
    /* 카카오맵 (수정하지 않음) */
    #map {
        width: 100%;
        height: 400px;
        border-radius: 8px;
    }

    /* 섹션 제목 스타일 */
    .section-title {
        text-align: center;
        font-size: 1.8rem;
        color: #3498db;
        margin-top: 40px;
        margin-bottom: 30px;
        padding-bottom: 10px;
        border-bottom: 2px solid #3498db;
        display: inline-block;
    }
    .center-align { text-align: center; }

    /* 객실 목록 컨테이너 */
    .room-container {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
        gap: 30px;
    }

    /* 객실 카드 */
    .room-card {
        background: #fff;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        transition: transform 0.3s ease, box-shadow 0.3s ease;
        display: flex;
        flex-direction: column;
    }
    .room-card:hover {
        transform: translateY(-8px);
        box-shadow: 0 8px 20px rgba(0,0,0,0.12);
    }
    .room-card-image img {
        width: 100%;
        height: 220px;
        object-fit: cover;
    }
    .room-card-body {
        padding: 20px;
        flex-grow: 1;
        display: flex;
        flex-direction: column;
    }
    .room-card-body h4 {
        margin-top: 0;
        margin-bottom: 15px;
        font-size: 1.6rem;
        color: #2980b9;
    }
    .room-card-body p {
        margin: 6px 0;
        color: #666;
        font-size: 0.95rem;
    }
    .room-price {
        font-size: 1.3rem;
        font-weight: bold;
        color: #e74c3c;
        margin-top: auto; /* 가격과 버튼을 아래로 밀어냄 */
        text-align: right;
        padding-top: 15px;
    }
    .btn-reserve {
        display: block;
        width: 100%;
        padding: 12px;
        margin-top: 10px;
        background-color: #27ae60;
        color: white;
        text-align: center;
        text-decoration: none;
        border: none;
        border-radius: 5px;
        font-weight: bold;
        font-size: 1rem;
        transition: background-color 0.2s;
        cursor: pointer;
    }
    .btn-reserve:hover {
        background-color: #229954;
    }
    .no-content {
        text-align: center;
        padding: 50px;
        color: #888;
        font-size: 1.1rem;
        grid-column: 1 / -1;
    }
</style>
</head>
<body>

<div class="main-container">
    <h2 class="header-title">${pension.p_name}</h2>

    <div class="card">
        <div class="pension-details-grid">
            <p><strong>연락처:</strong> ${pension.tel1}-${pension.tel2}-${pension.tel3}</p>
            <p><strong>체크인:</strong> ${pension.checkin_time}</p>
            <p><strong>체크아웃:</strong> ${pension.checkout_time}</p>
            <p><strong>주요시설:</strong> ${pension.facilities}</p>
            <div class="pension-description">
                <p><strong>펜션소개:</strong> ${pension.description}</p>
            </div>
        </div>
    </div>
    
    <%-- 카카오맵 표시 영역 (수정하지 않음) --%>
    <div class="card">
        <div id="map"></div>
    </div>

    <div class="center-align">
        <h3 class="section-title">객실 안내 및 예약</h3>
    </div>
    
    <div class="room-container">
        <c:choose>
            <c:when test="${not empty roomList}">
                <c:forEach var="room" items="${roomList}">
                    <div class="room-card">
                        <div class="room-card-image">
                            <img src="${contextPath}/resources/images/room/${room.fileimage}"
                                 alt="${room.room_name} 이미지"
                                 onerror="this.src='${contextPath}/resources/image/default_room.png';">
                        </div>
                        <div class="room-card-body">
                            <h4>${room.room_name}</h4>
                            <p><strong>객실유형:</strong> ${room.room_type}</p>
                            <p><strong>수용인원:</strong> 최대 ${room.max_capacity}명</p>
                            <p><strong>객실크기:</strong> ${room.room_size}</p>
                            <p><strong>구비시설:</strong> ${room.amenities}</p>
                            <p class="room-price">
                                1박 <strong><fmt:formatNumber value="${room.price}" pattern="#,###" />원</strong>
                            </p>
                            <a href="${contextPath}/reservation/reservationForm.do?roomId=${room.room_id}&p_num=${pension.p_num}" class="btn-reserve">
                                예약하기
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p class="no-content">현재 등록된 객실 정보가 없습니다.</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%-- 카카오맵 스크립트 (수정하지 않음) --%>
<script>
    var mapContainer = document.getElementById('map');
    var address = "${pension.business.roadAddress}"; 
    var pensionName = "${pension.p_name}";

    if (address) {
        var options = {
            center: new kakao.maps.LatLng(37.5665, 126.9780),
            level: 4
        };
        var map = new kakao.maps.Map(mapContainer, options);
        var geocoder = new kakao.maps.services.Geocoder();

        geocoder.addressSearch(address, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                var marker = new kakao.maps.Marker({
                    map: map,
                    position: coords
                });
                var infowindow = new kakao.maps.InfoWindow({
                    content: `<div style="width:180px;text-align:center;padding:6px 0;">\${pensionName}</div>`
                });
                infowindow.open(map, marker);
                map.setCenter(coords);
            } else {
                displayErrorMessage("위치 정보를 불러올 수 없습니다. (주소: " + address + ")");
            }
        });
    } else {
        displayErrorMessage("등록된 주소 정보가 없습니다.");
    }

    function displayErrorMessage(message) {
        mapContainer.style.display = 'flex';
        mapContainer.style.alignItems = 'center';
        mapContainer.style.justifyContent = 'center';
        mapContainer.innerHTML = `<p style='text-align:center;'>\${message}</p>`;
    }
</script>

</body>
</html>