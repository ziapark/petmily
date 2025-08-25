<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=0351a11278cad14d12e263429c917675&libraries=services"></script>
</head>
<body>
<div class="container text-center mt-3 mb-3">
    <div class="row row-cols-1 mb-3">
        <div class="col bg-light p-5 text-start">
            <h2 class="fw-bold">문화시설 정보</h2>
        </div>
    </div>

    <div class="row row-cols-1">
        <div class="search_medi">
            <form action="${contextPath}/leisure/search.do" method="get">
                <!-- 시/도 선택 -->
                <select name="sido" id="sido" onchange="changeGungu()" class="form-select">
                    <option value="">시/도 선택</option>
                    <option value="서울특별시">서울특별시</option>
                    <option value="부산광역시">부산광역시</option>
                    <option value="대전광역시">대전광역시</option>
                    <option value="충청북도">충청북도</option>
                    <option value="경기도">경기도</option>
                </select>

                <!-- 군/구 선택 -->
                <select name="gungu" id="gungu" class="form-select">
                    <option value="">군/구 선택</option>
                </select>

                <!-- 시설명 검색 -->
                <input type="text" name="keyword" placeholder="문화시설명 검색" class="form-control">

                <button type="submit" class="btn btn-primary">검색</button>
            </form>
        </div>

        <div style="display:flex;">
            <!-- 지도 -->
            <div id="map" style="width:70%;height:600px;"></div>

            <!-- 검색 리스트 -->
            <div style="width:30%; height:600px; overflow-y:auto; border:1px solid #ccc; padding:10px;">
                <ul>
                    <c:if test="${empty leisureList}">
                        <li>검색 결과가 없습니다.</li>
                    </c:if>
                    <c:forEach var="item" items="${leisureList}">
                        <li onclick="moveTo(${item.la_vlue}, ${item.lo_vlue})">
                            <b>${item.fac_nm}</b><br/>
                            시설정보: ${item.info}<br/>
                            운영시간: ${item.opr_time_info}<br/>
                            휴무일: ${item.off_day}<br/>
                            주소: ${item.rn_addr}<br/>
                            전화: ${item.rprs_telno}<br/>
                            홈페이지: ${item.hmpg_url}<br/>
                           
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
    </div>
</div>

<script>
    // 카카오맵 초기화
    var mapContainer = document.getElementById('map');
    var mapOption = { 
        center: new kakao.maps.LatLng(37.5665, 126.9780), 
        level: 7
    };
    var map = new kakao.maps.Map(mapContainer, mapOption);

    // 마커 생성
    var markers = [];
    <c:forEach var="item" items="${leisureList}">
        <c:if test="${not empty item.la_vlue && not empty item.lo_vlue}">
            var marker = new kakao.maps.Marker({
                map: map,
                position: new kakao.maps.LatLng(${item.la_vlue}, ${item.lo_vlue})
            });

            var infowindow = new kakao.maps.InfoWindow({
                content: '<div style="padding:5px;font-size:12px;">${item.fac_nm}</div>'
            });

            kakao.maps.event.addListener(marker, 'mouseover', function() {
                infowindow.open(map, marker);
            });
            kakao.maps.event.addListener(marker, 'mouseout', function() {
                infowindow.close();
            });

            markers.push(marker);
        </c:if>
    </c:forEach>

    // 리스트 클릭 시 지도 이동
    function moveTo(lat, lng) {
        if (!lat || !lng) return;
        var moveLatLon = new kakao.maps.LatLng(lat, lng);
        map.panTo(moveLatLon);
    }

    // 검색 후 첫 결과로 지도 중심 이동
    <c:if test="${not empty leisureList}">
        map.setCenter(new kakao.maps.LatLng(${leisureList[0].la_vlue}, ${leisureList[0].lo_vlue}));
    </c:if>

    // 시군구 데이터
    const gunguData = {
        "서울특별시": ["강남구","강동구","강북구","강서구","관악구","광진구","구로구","금천구","노원구","도봉구","동대문구","동작구","마포구","서대문구","서초구","성동구","성북구","송파구","양천구","영등포구","용산구","은평구","종로구","중구","중랑구"],
        "부산광역시": ["강서구","금정구","기장군","남구","동구","동래구","부산진구","북구","사상구","사하구","서구","수영구","연제구","영도구","중구","해운대구"],
        "대전광역시": ["동구","중구","서구","유성구","대덕구"],
        "충청북도": ["청주시","충주시","제천시","보은군","옥천군","영동군","진천군","괴산군","음성군","단양군"],
        "경기도": ["수원시","성남시","고양시","용인시","부천시","안산시","안양시","남양주시","화성시","평택시","의정부시","시흥시","파주시","김포시","광명시","광주시","군포시","이천시","오산시","하남시","양주시","구리시","안성시","포천시","의왕시","여주시","동두천시","과천시","가평군","양평군","연천군"]
    };

    function changeGungu() {
        let sido = document.getElementById("sido").value;
        let gunguSelect = document.getElementById("gungu");
        gunguSelect.innerHTML = '<option value="">군/구 선택</option>';

        if (gunguData[sido]) {
            gunguData[sido].forEach(function(g) {
                let option = document.createElement("option");
                option.value = g;
                option.text = g;
                gunguSelect.appendChild(option);
            });
        }
    }
</script>
</body>
</html>
