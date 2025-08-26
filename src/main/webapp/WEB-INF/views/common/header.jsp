<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
			async : true,
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
			}
		});
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
	
	$(function() {
	    $('.btn-group .btn').on('click', function(e) {
	        $('.btn-group .btn').removeClass('active').attr('aria-current', 'false');
	        $(this).addClass('active').attr('aria-current', 'page');
	    });
	});
</script>

<%-- ======================================================== --%>
<%--       2. Scope 설정까지 포함된 최종 원시그널 스크립트       --%>
<%-- ======================================================== --%>
<script src="https://cdn.onesignal.com/sdks/web/v16/OneSignalSDK.page.js" defer></script>
<script>
  window.OneSignalDeferred = window.OneSignalDeferred || [];
  OneSignalDeferred.push(async function(OneSignal) {
    
    await OneSignal.init({
      appId: "14ed38d9-71e5-4fc8-aec3-457b8a7ca88d", // 당신의 App ID
      
      // 1. 파일의 실제 위치를 정확히 알려줍니다.
      serviceWorkerPath: "${contextPath}/resources/js/OneSignalSDKWorker.js",

      // 2. 서비스 워커의 활동 범위를 우리 프로젝트 경로로 강제합니다. (이것이 핵심!)
      serviceWorkerParam: { scope: '${contextPath}/' },
      
      allowLocalhostAsSecureOrigin: true
    });

    const isSubscribed = await OneSignal.isPushNotificationsEnabled();
    
    if (isSubscribed) {
        console.log("User is already subscribed.");
        setExternalId(OneSignal);
    } else {
        OneSignal.on('subscriptionChange', function(isSubscribedNow) {
            if (isSubscribedNow) {
                console.log("User has just subscribed.");
                setExternalId(OneSignal);
            }
        });
    }
  });

  // 사용자 ID를 등록하는 함수
  async function setExternalId(OneSignal) {
    <c:choose>
        <c:when test="${isLogOn == true && not empty memberInfo.member_id}">
            var userId = "${memberInfo.member_id}";
            await OneSignal.login(userId);
            console.log("OneSignal External ID (Member) has been set to: " + userId);
        </c:when>
        <c:when test="${isLogOn == true && not empty businessInfo.business_id}">
            var userId = "${businessInfo.business_id}";
            await OneSignal.login(userId);
            console.log("OneSignal External ID (Business) has been set to: " + userId);
        </c:when>
    </c:choose>
  }
</script>

<body>
	<div class="header_wrap">
		<div id="logo">
			<a href="${contextPath}/main/main.do"> <img alt="petmily"
				src="${contextPath}/resources/image/logo.png">
			</a>
		</div>
		
		<c:set var="queryString" value="${pageContext.request.queryString}" />

		<div class="btn-group lang_btn" role="group" aria-label="Language toggle button">
		    <c:set var="baseQuery" value="${queryString}" />
		    
		    <c:if test="${not empty baseQuery}">
		        <c:set var="baseQuery" value="${fn:replace(baseQuery, 'lang=ko', '')}" />
		        <c:set var="baseQuery" value="${fn:replace(baseQuery, 'lang=en', '')}" />
		        <c:set var="baseQuery" value="${fn:replace(baseQuery, '&&', '&')}" />
		        <c:set var="baseQuery" value="${fn:trim(baseQuery)}" />
		        <c:if test="${baseQuery ne ''}">
		            <c:set var="baseQuery" value="${baseQuery}&" />
		        </c:if>
		    </c:if>
		
		    <a href="?${baseQuery}lang=ko"
		       class="btn btn-primary ${lang == 'ko' ? 'active' : ''}"
		       aria-current="${lang == 'ko' ? 'page' : 'false'}">한국어</a>
		
		    <a href="?${baseQuery}lang=en"
		       class="btn btn-primary ${lang == 'en' ? 'active' : ''}"
		       aria-current="${lang == 'en' ? 'page' : 'false'}">English</a>
		</div>
		
		<div id="head_link">
			<ul>
				<c:choose>
					<c:when test="${isLogOn==true and memberInfo.member_id =='admin' }">					
						<li><a href="${contextPath}/admin/goods/addNewGoodsForm.do"
							class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.admin"/>
						</a></li>
						<li><a href="#" class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.cs"/>
						</a></li>
						<li><a href="${contextPath}/member/logout.do"
							class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.logout"/>
						</a></li>
					</c:when>
					
					<c:when test="${isLogOn==true and not empty memberInfo}">					
					    <li>
					        <a href="#" class="btn-sm btn btn-outline-warning">
					            <i class="bi bi-coin" style="color: #E8C164; vertical-align: -0.1em;"></i> ${memberInfo.point} P
					        </a>
					    </li>
						<li><a href="${contextPath}/mypage/myDetailInfo.do"
							class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.mypage"/>
						</a></li>
						<li><a href="${contextPath}/cart/myCartList.do"
							class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.cart"/>
						</a></li>
						<li><a href="${contextPath}/mypage/listMyOrderHistory.do"
							class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.order"/>
						</a></li>
						<li><a href="#" class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.cs"/>
						</a></li>
						<li><a href="${contextPath}/member/logout.do"
							class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.logout"/>
						</a></li>
					</c:when>
					
					<c:when test="${isLogOn==true and not empty businessInfo}">
						<li><a href="${contextPath}/business/businessDetailInfo.do"
							class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.mypage"/>
						</a></li>
						<li><a href="${contextPath}/member/logout.do"
							class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.logout"/>
						</a></li>
					</c:when>
					
					<c:otherwise>
						<li><a href="${contextPath}/member/loginForm.do"
							class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.login"/>
						</a></li>
						<li><a href="${contextPath}/member/memberForm.do"
							class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.signup"/>
						</a></li>
						<li><a href="${contextPath}/business/loginForm.do"
							class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.businessLogin"/>
						</a></li>
						<li><a href="${contextPath}/business/businessForm.do"
							class="btn-sm btn btn-outline-dark">
							<spring:message code="menu.businessSignup"/>
						</a></li>
					</c:otherwise>
				</c:choose>
			</ul>
		</div>
		<div class="clear"></div>
		<div id="search">
		    <form name="frmSearch" action="${contextPath}/goods/searchGoods.do" method="get">
		    	<div class="search_box">
		    		<input name="searchWord" class="form-control search_input"
		               type="text" placeholder="<spring:message code='search.placeholder'/>">
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
				<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=사료">
					<spring:message code="menu.food"/>
				</a></li>
				<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=봉제장난감">
					<spring:message code="menu.toy"/>
				</a></li>
				<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=애견샴푸">
					<spring:message code="menu.clean"/>
				</a></li>
				<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=목줄/하네스">
					<spring:message code="menu.walk"/>
				</a></li>
				<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=식기">
					<spring:message code="menu.living"/>
				</a></li>
				<li><a href="${contextPath}/reservation/pensionList.do">
					<spring:message code="menu.leisure"/>
				</a></li>
				<li><a href="${contextPath}/board/boardList.do?board_type=notice">
					<spring:message code="menu.community"/>
				</a></li>
			</ul>

			<div class="submenu-wrap">
				<ul class="submenu">
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=사료">
						<spring:message code="submenu.feed"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=간식">
						<spring:message code="submenu.snack"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=영양제">
						<spring:message code="submenu.supplement"/>
					</a></li>
				</ul>
				<ul class="submenu">
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=봉제장난감">
						<spring:message code="submenu.dolltoy"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=공/원반">
						<spring:message code="submenu.discball"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=터그놀이">
						<spring:message code="submenu.tugToystugToys"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=낚시대">
						<spring:message code="submenu.fishingRod"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=먹이퍼즐">
						<spring:message code="submenu.puzzleFeeder"/>
					</a></li>
				</ul>
				<ul class="submenu">
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=애견샴푸">
						<spring:message code="submenu.shampoo"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=칫솔치약">
						<spring:message code="submenu.tooth"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=수건">
						<spring:message code="submenu.towel"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=미용기">
						<spring:message code="submenu.beauty"/>
					</a></li>
				</ul>
				<ul class="submenu">
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=목줄/하네스">
						<spring:message code="submenu.leash"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=유모차">
						<spring:message code="submenu.stroller"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=배변봉투">
						<spring:message code="submenu.bag"/>
					</a></li>
				</ul>
				<ul class="submenu">
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=식기">
						<spring:message code="submenu.bowl"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=스크래처">
						<spring:message code="submenu.scratcher"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=의류">
						<spring:message code="submenu.cloth"/>
					</a></li>
					<li><a href="${contextPath}/goods/goodsListByCategory.do?goods_category=신발">
						<spring:message code="submenu.shoes"/>
					</a></li>
				</ul>
				<ul class="submenu">
					<li><a href="${contextPath}/reservation/pensionList.do">
						<spring:message code="submenu.pension"/>
					</a></li>
					<li><a href="${contextPath}/leisure/leisure.do">
						<spring:message code="submenu.culture"/>
					</a></li>
				</ul>
				<ul class="submenu">
					<li><a href="${contextPath}/board/boardList.do?board_type=notice">
						<spring:message code="submenu.notice"/>
					</a></li>
					<li><a href="${contextPath}/board/boardList.do?board_type=qna">
						<spring:message code="submenu.qna"/>
					</a></li>
					<li><a href="${contextPath}/board/boardList.do?board_type=comu_dog">
						<spring:message code="submenu.comuDog"/>
					</a></li>
					<li><a href="${contextPath}/board/boardList.do?board_type=comu_cat">
						<spring:message code="submenu.comuCat"/>
					</a></li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>