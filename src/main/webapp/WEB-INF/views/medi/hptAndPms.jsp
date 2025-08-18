<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=0351a11278cad14d12e263429c917675"></script>
</head>
<body>
<div class="container text-center mt-3 mb-3">
    <div class="row row-cols-1 mb-3">
        <div class="col bg-light p-5 text-start">
            <h2 class="fw-bold">전국 동물병원/약국 정보</h2>
        </div>
    </div>
    <div class="row row-cols-1">
        <div class="search_medi">
            <form action="${contextPath}/medi/search.do" method="get">
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

                <!-- 병원/약국 이름 검색 -->
                <input type="text" name="keyword" placeholder="병원/약국 이름 검색" class="form-control">

                <button type="submit" class="btn btn-primary">검색</button>
            </form>
        </div>

        <div style="display:flex;">
            <!-- 지도 -->
            <div id="map" style="width:70%; height:600px;"></div>

            <!-- 리스트 -->
            <div style="width:30%; height:600px; overflow-y:auto; border:1px solid #ccc; padding:10px;">
                <c:if test="${empty places}">
                    <div>검색 결과가 없습니다.</div>
                </c:if>

                <c:forEach var="p" items="${places}">
                    <div class="place-item" style="margin-bottom:10px; cursor:pointer;"
                         onclick="moveTo('${p.lat}', '${p.lng}')">
                        <b>[${p.type}] ${p.name}</b><br>
                        ${p.addr}<br>
                        <c:if test="${not empty p.tel}">☎ ${p.tel}</c:if><br>
                        ${p.oprTime}<br>
                        <p><a href="${p.homepage}" style="color:blue">${p.homepage}</a></p>
                    </div>
                    <hr>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
    var mapContainer = document.getElementById('map'),
        mapOption = { center: new kakao.maps.LatLng(36.635, 127.491), level: 5 };

    var map = new kakao.maps.Map(mapContainer, mapOption);

    // DB 결과 -> JS 배열
    var places = [
        <c:forEach var="p" items="${places}" varStatus="status">
            {
                type: "${p.type}",
                name: "${p.name}",
                lat: ${p.lat},
                lng: ${p.lng},
                addr: "${p.addr}"
            }<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    var markers = [];

    // 마커 찍기
    places.forEach(function(p) {
        if(!p.lat || !p.lng) return;

        var markerImage = new kakao.maps.MarkerImage(
            p.type === "HOSPITAL" 
            ? "${contextPath}/resources/image/hospital.png"
            : "${contextPath}/resources/image/pharmacy2.png",
            new kakao.maps.Size(32, 32)
        );

        var marker = new kakao.maps.Marker({
            map: map,
            position: new kakao.maps.LatLng(p.lat, p.lng),
            image: markerImage
        });

        markers.push(marker);

        var infowindow = new kakao.maps.InfoWindow({
            content: '<div style="padding:5px;font-size:13px;">[' + p.type + '] ' + p.name + '</div>'
        });

        kakao.maps.event.addListener(marker, 'click', function() {
            infowindow.open(map, marker);
        });
    });

    // 리스트 클릭 시 지도 이동
    function moveTo(lat, lng) {
        if(!lat || !lng) return;
        var moveLatLon = new kakao.maps.LatLng(lat, lng);
        map.panTo(moveLatLon);
    }

    // 검색 후 첫 결과로 지도 중심 이동
    if (places.length > 0 && places[0].lat && places[0].lng) {
        map.setCenter(new kakao.maps.LatLng(places[0].lat, places[0].lng));
    }
    
    
    const gunguData = {
    		
		  "서울특별시": [
		    "강남구", "강동구", "강북구", "강서구", 
		    "관악구", "광진구", "구로구", "금천구",
		    "노원구", "도봉구", "동대문구", "동작구",
		    "마포구", "서대문구", "서초구", "성동구",
		    "성북구", "송파구", "양천구", "영등포구",
		    "용산구", "은평구", "종로구", "중구", "중랑구"
		  ],
		  "부산광역시": [
		    "강서구", "금정구", "기장군", "남구", "동구",
		    "동래구", "부산진구", "북구", "사상구", "사하구",
		    "서구", "수영구", "연제구", "영도구", "중구", "해운대구"
		  ],
		  "대전광역시": ["동구", "중구", "서구", "유성구", "대덕구"],
		  "광주광역시": ["동구", "서구", "남구", "북구", "광산구"],
		  "대구광역시": [
		    "남구", "달서구", "달성군", "동구", "북구",
		    "서구", "수성구", "중구"
		  ],
		  "울산광역시": ["남구", "동구", "북구", "중구", "울주군"],
		  "세종특별자치시": ["세종시"],
		  "경기도": [
		    "수원시", "성남시", "고양시", "용인시", "부천시", "안산시", "안양시",
		    "남양주시", "화성시", "평택시", "의정부시", "시흥시", "파주시", "김포시",
		    "광명시", "광주시", "군포시", "이천시", "오산시", "하남시", "양주시",
		    "구리시", "안성시", "포천시", "의왕시", "여주시", "동두천시", "과천시",
		    "가평군", "양평군", "연천군"
		  ],
		  "충청북도": [
		    "청주시", "충주시", "제천시", "보은군", "옥천군", "영동군",
		    "진천군", "괴산군", "음성군", "단양군"
		  ],
		  "충청남도": [
		    "천안시", "공주시", "보령시", "아산시", "서산시", "논산시",
		    "계룡시", "당진시", "금산군", "부여군", "서천군", "청양군",
		    "홍성군", "예산군", "태안군"
		  ],
		  "전라북도": [
		    "전주시", "군산시", "익산시", "정읍시", "남원시",
		    "김제시", "완주군", "진안군", "무주군", "장수군",
		    "임실군", "순창군", "고창군", "부안군"
		  ],
		  "전라남도": [
		    "목포시", "여수시", "순천시", "나주시", "광양시",
		    "담양군", "곡성군", "구례군", "고흥군", "보성군",
		    "화순군", "장흥군", "강진군", "해남군", "영암군",
		    "무안군", "함평군", "영광군", "장성군", "완도군",
		    "진도군", "신안군"
		  ],
		  "경상북도": [
		    "포항시", "경주시", "김천시", "안동시", "구미시",
		    "영주시", "영천시", "상주시", "문경시", "경산시",
		    "군위군", "의성군", "청송군", "영양군", "영덕군",
		    "청도군", "고령군", "성주군", "칠곡군", "예천군",
		    "봉화군", "울진군", "울릉군"
		  ],
		  "경상남도": [
		    "창원시", "진주시", "통영시", "사천시", "김해시",
		    "밀양시", "거제시", "양산시", "의령군", "함안군",
		    "창녕군", "고성군", "남해군", "하동군", "산청군",
		    "함양군", "거창군", "합천군"
		  ],
		  "강원도": [
		    "춘천시", "원주시", "강릉시", "동해시", "태백시",
		    "속초시", "삼척시", "홍천군", "횡성군", "영월군",
		    "평창군", "정선군", "철원군", "화천군", "양구군",
		    "인제군", "고성군", "양양군"
		  ],
		  "제주특별자치도": ["제주시", "서귀포시"]
		};
     

        function changeGungu() {
            let sido = document.getElementById("sido").value;
            let gunguSelect = document.getElementById("gungu");

            // 초기화
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
