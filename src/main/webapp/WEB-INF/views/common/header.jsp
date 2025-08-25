<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%-- ======================================================== --%>
<%--                1. 기존 JavaScript 코드                    --%>
<%-- ======================================================== --%>
<script type="text/javascript">
	var loopSearch = true;
	function keywordSearch() {
		if (loopSearch == false)
			return;
		var value = document.frmSearch.searchWord.value;
		$.ajax({
			type : "get",
			async : true, //false인 경우 동기식으로 처리한다.
			url : "${contextPath}/goods/keywordSearch.do",
			data : {
				keyword : value
			},
			success : function(data, textStatus) {
				var jsonInfo = JSON.parse(data);
				displayResult(jsonInfo);
			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다." + data);
			},
			complete : function(data, textStatus) {
				//alert("작업을완료 했습니다");
			}
		}); //end ajax	
	}

	function displayResult(jsonInfo) {
		var count = jsonInfo.keyword.length;
		if (count > 0) {
			var html = '';
			for ( var i in jsonInfo.keyword) {
				html += "<a href=\"javascript:select('" + jsonInfo.keyword[i]
						+ "')\">" + jsonInfo.keyword[i] + "</a><br/>";
			}
			var listView = document.getElementById("suggestList");
			listView.innerHTML = html;
			show('suggest');
		} else {
			hide('suggest');
		}
	}

	function select(selectedKeyword) {
		document.frmSearch.searchWord.value = selectedKeyword;
		loopSearch = false;
		hide('suggest');
	}

	function show(elementId) {
		var element = document.getElementById(elementId);
		if (element) {
			element.style.display = 'block';
		}
	}

	function hide(elementId) {
		var element = document.getElementById(elementId);
		if (element) {
			element.style.display = 'none';
		}
	}
</script>

<%-- ======================================================== --%>
<%--       2. 최종 원시그널(OneSignal) 스크립트                --%>
<%-- (초기화와 사용자 ID 등록 로직이 모두 포함되어 있습니다)      --%>
<%-- ======================================================== --%>
<script src="https://cdn.onesignal.com/sdks/web/v16/OneSignalSDK.page.js" defer></script>
<script>
  window.OneSignalDeferred = window.OneSignalDeferred || [];
  OneSignalDeferred.push(async function(OneSignal) {
    
    // 원시그널 초기화
    await OneSignal.init({
      appId: "14ed38d9-71e5-4fc8-aec3-457b8a7ca88d", // 당신의 App ID
    });

    // JSTL을 사용해 로그인 상태에 따라 사용자 ID 등록
    <c:choose>
        <%-- 일반 회원으로 로그인한 경우 --%>
        <c:when test="${isLogOn == true && not empty memberInfo.member_id}">
            var userId = "${memberInfo.member_id}";
            await OneSignal.login(userId);
            console.log("OneSignal External ID (Member) has been set to: " + userId);
        </c:when>
        
        <%-- 사업자 회원으로 로그인한 경우 --%>
        <c:when test="${isLogOn == true && not empty businessInfo.business_id}">
            var userId = "${businessInfo.business_id}"; // business_id는 실제 변수명으로 변경
            await OneSignal.login(userId);
            console.log("OneSignal External ID (Business) has been set to: " + userId);
        </c:when>
    </c:choose>
    
  });
</script>

<body>
	<div class="header_wrap">
		<div id="logo">
			<a href="${contextPath}/main/main.do"> <img alt="petmily"
				src="${contextPath}/resources/image/logo.png">
			</a>
		</div>
		<div id="head_link">
			<ul>
				<c:choose>
					<c:when test="${isLogOn==true and memberInfo.member_id =='admin' }">					
						<li><a href="${contextPath}/admin/goods/addNewGoodsForm.do"
							class="btn-sm btn btn-outline-dark">관리자</a></li>
						<li><a href="#" class="btn-sm btn btn-outline-dark">고객센터</a></li>
						<li><a href="${contextPath}/member/logout.do"
							class="btn-sm btn btn-outline-dark">로그아웃</a></li>
					</c:when>
					<c:when test="${isLogOn==true and not empty memberInfo}">					
					    <li>
					        <a href="#" class="btn-sm btn btn-outline-warning">
					            <i class="bi bi-coin" style="color: #E8C164; vertical-align: -0.1em;"></i> ${memberInfo.point} P
					        </a>
					    </li>
						<li><a href="${contextPath}/mypage/myDetailInfo.do"
							class="btn-sm btn btn-outline-dark">마이페이지</a></li>
						<li><a href="${contextPath}/cart/myCartList.do"
							class="btn-sm btn btn-outline-dark">장바구니</a></li>
						<li><a href="${contextPath}/mypage/listMyOrderHistory.do" class="btn-sm btn btn-outline-dark">주문배송</a></li>
						<li><a href="#" class="btn-sm btn btn-outline-dark">고객센터</a></li>
						<li><a href="${contextPath}/member/logout.do"
							class="btn-sm btn btn-outline-dark">로그아웃</a></li>
					</c:when>
					
					<c:when test="${isLogOn==true and not empty businessInfo}">
					<li><a href="${contextPath}/business/businessDetailInfo.do" class="btn-sm btn btn-outline-dark">사업자 마이페이지</a></li>
						<li><a href="${contextPath}/member/logout.do"
							class="btn-sm btn btn-outline-dark">로그아웃</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="${contextPath}/member/loginForm.do"
							class="btn-sm btn btn-outline-dark">로그인</a></li>
						<li><a href="${contextPath}/member/memberForm.do"
							class="btn-sm btn btn-outline-dark">회원가입</a></li>
						<li><a href="${contextPath}/business/loginForm.do"
							class="btn-sm btn btn-outline-dark">사업자 로그인</a></li>
						<li><a href="${contextPath}/business/businessForm.do"
							class="btn-sm btn btn-outline-dark">사업자 회원가입</a></li>
					</c:otherwise>
				</c:choose>
			</ul>
		</div>
		<div class="clear"></div>
		<div id="search">
		    <form name="frmSearch" action="${contextPath}/goods/searchGoods.do" method="get">
		    	<div class="search_box">
		    		<input name="searchWord" class="form-control search_input"
		               type="text" placeholder="검색어를 입력하세요">
		        	<input type="submit" name="search" class="btn-primary btn-sm search_btn" value=" "/>
		    	</div>
		        
		    </form>
		</div>
		<div id="suggest">
			<div id="suggestList"></div>
		</div>
	</div>
	<div class="nav-area" style="position: relative; clear: both;">
		<div class="nav_inner">
			<ul class="gnb">
				<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=사료">식품</a></li>
				<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=봉제장난감">장난감</a></li>
				<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=애견샴푸">목욕/위생</a></li>
				<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=목줄/하네스">산책용품</a></li>
				<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=식기">생활용품</a></li>
				<li><a href="${contextPath}/reservation/pensionList.do">여가생활</a></li>
				<li><a href="${contextPath}/board/boardList.do?board_type=notice">커뮤니티</a></li>
				
			</ul>

			<div class="submenu-wrap">
				<ul class="submenu">
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=사료">사료</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=간식">간식</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=영양제">영양제</a></li>
				</ul>
				<ul class="submenu">
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=봉제장난감">봉제장난감</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=공/원반">공/원반</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=터그놀이">터그놀이</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=낚시대">낚시대</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=먹이퍼즐">먹이퍼즐</a></li>
				</ul>
				<ul class="submenu">
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=애견샴푸">샴푸</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=칫솔치약">칫솔/치약</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=수건">수건</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=미용기">미용기</a></li>
				</ul>
				<ul class="submenu">
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=목줄/하네스">목줄/하네스</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=유모차">유모차</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=배변봉투">배변봉투</a></li>
				</ul>
				<ul class="submenu">
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=식기">식기</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=스크래처">스크래처</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=의류">의류</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=신발">신발</a></li>
				</ul>
				
				<ul class="submenu">
					<li><a href="${contextPath}/reservation/pensionList.do">애견펜션</a></li>
					<li><a href="${contextPath}/reservation/pensionList.do">문화시설</a></li>
				</ul>
				
				<ul class="submenu">
					<li><a href="${contextPath}/board/boardList.do?board_type=notice">공지사항</a></li>
					<li><a href="${contextPath}/board/boardList.do?board_type=qna">질문게시판</a></li>
					<li><a href="${contextPath}/board/boardList.do?board_type=comu_dog">커뮤니티:강아지</a></li>
					<li><a href="${contextPath}/board/boardList.do?board_type=comu_cat">커뮤니티:고양이</a></li>
				</ul>
				
			</div>
		</div>
	</div>
</body>
</html>