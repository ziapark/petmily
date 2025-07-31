<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>관리자 상품 조회</title>
<style>
    /* 기본적인 스타일링을 추가하여 페이지 가독성을 높입니다. */

    table {
        width: 100%;
        border-collapse: collapse;
  
        background-color: #fff;
        box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    table td, table th {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
    }
    table th {
        background-color: #f2f2f2;
    }

    .clear {
        clear: both;
        height: 10px;
    }
    input[type="text"], select {
        padding: 5px;
        border: 1px solid #ccc;
        border-radius: 3px;
    }
    input[type="button"], input[type="submit"] {
        padding: 8px 15px;
        background-color: #007bff;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
    }
    input[type="button"]:hover, input[type="submit"]:hover {
        background-color: #0056b3;
    }
    input[type="button"][disabled], input[type="text"][disabled], select[disabled] {
        background-color: #e9ecef;
        cursor: not-allowed;
    }
    #search a img {
        vertical-align: middle;
        border: 0;
    }
    /* 페이징 스타일 */
    .fixed a {
        display: inline-block;
        padding: 5px 10px;
        margin: 0 2px;
        border: 1px solid #ddd;
        border-radius: 3px;
        text-decoration: none;
        color: #007bff;
    }
    .fixed a:hover {
        background-color: #e9ecef;
    }
    .fixed a b {
        color: #dc3545;
        font-weight: bold;
    }
    /* 판매 상태 표시를 위한 스타일 */
    .status-deleted {
        color: #dc3545; /* 빨간색 */
        font-weight: bold;
    }
    .status-active {
        color: #28a745; /* 초록색 */
    }
</style>
<script>
// 날짜 계산 함수: 현재 날짜를 기준으로 검색 기간을 계산하여 "YYYY-MM-DD,YYYY-MM-DD" 형식으로 반환
function calcPeriod(search_period) {
    var dt = new Date();
    var beginDateObj = new Date(dt.getFullYear(), dt.getMonth(), dt.getDate()); // 시작 날짜 객체
    var endDateObj = new Date(dt.getFullYear(), dt.getMonth(), dt.getDate());   // 종료 날짜 객체 (오늘 날짜)

    if (search_period == 'today') {
        // 오늘 날짜로 이미 설정되어 있음
    } else if (search_period == 'one_week') {
        beginDateObj.setDate(dt.getDate() - 7);
    } else if (search_period == 'two_week') {
        beginDateObj.setDate(dt.getDate() - 14);
    } else if (search_period == 'one_month') {
        beginDateObj.setMonth(dt.getMonth() - 1);
    } else if (search_period == 'two_month') {
        beginDateObj.setMonth(dt.getMonth() - 2);
    } else if (search_period == 'three_month') {
        beginDateObj.setMonth(dt.getMonth() - 3);
    } else if (search_period == 'four_month') {
        beginDateObj.setMonth(dt.getMonth() - 4);
    }

    // 날짜를 YYYY-MM-DD 형식의 문자열로 포맷팅
    var format = function(date) {
        var y = date.getFullYear();
        var m = date.getMonth() + 1; // getMonth()는 0부터 시작
        var d = date.getDate();
        return y + '-' + (m < 10 ? '0' : '') + m + '-' + (d < 10 ? '0' : '') + d;
    };

    var beginDate = format(beginDateObj);
    var endDate = format(endDateObj);

    return beginDate + "," + endDate;
}

// 상품 목록 검색 함수: fixedSearchPeriod에 따라 날짜 파라미터 전송
function search_goods_list(fixedSearchPeriod) {
    var formObj = document.frm_search_goods; // 폼 이름으로 접근
    var period = calcPeriod(fixedSearchPeriod); // 기간 계산
    var dates = period.split(','); // "시작일,종료일" 문자열을 배열로 분리

    formObj.begin_date.value = dates[0]; // 시작일 hidden 필드에 값 설정
    formObj.end_date.value = dates[1];   // 종료일 hidden 필드에 값 설정
    formObj.fixedSearchPeriod.value = fixedSearchPeriod; // 고정 검색 기간 설정

    // 페이지 번호를 1로 초기화하여 새 검색 시 첫 페이지로 이동
    formObj.cur_page.value = "1";
    formObj.chapter.value = "1";

    // 검색 타입 라디오 버튼을 'period'로 설정하고 hidden 필드에 반영
    document.querySelector('input[name="search_type"][value="period"]').checked = true;
    updateSearchTypeHidden('period'); // Hidden 필드 업데이트

    toggleSearchFields(true); // 필드 활성화/비활성화 업데이트

    formObj.method = "get"; // GET 방식으로 변경
    formObj.action = "${contextPath}/admin/goods/adminGoodsMain.do";
    formObj.submit();
}

// 상세 검색 제출 함수 (별도 버튼 클릭 시)
function submit_detail_search() {
    var formObj = document.frm_search_goods;

    // 상세 검색 시에는 날짜 필드를 비워줍니다. (컨트롤러에서 period와 detail을 명확히 구분)
    formObj.begin_date.value = "";
    formObj.end_date.value = "";
    formObj.fixedSearchPeriod.value = ""; // 고정 검색 기간도 초기화

    // 페이지 번호를 1로 초기화하여 새 검색 시 첫 페이지로 이동
    formObj.cur_page.value = "1";
    formObj.chapter.value = "1";

    // 검색 타입 라디오 버튼을 'detail'로 설정하고 hidden 필드에 반영
    document.querySelector('input[name="search_type"][value="detail"]').checked = true;
    updateSearchTypeHidden('detail'); // Hidden 필드 업데이트

    formObj.method = "get";
    formObj.action = "${contextPath}/admin/goods/adminGoodsMain.do";
    formObj.submit();
}

// search_type hidden 필드 값을 업데이트하는 함수
function updateSearchTypeHidden(type) {
    var hiddenField = document.getElementById('search_type_hidden');
    if (!hiddenField) {
        hiddenField = document.createElement('input');
        hiddenField.type = 'hidden';
        hiddenField.id = 'search_type_hidden';
        hiddenField.name = 'search_type';
        document.frm_search_goods.appendChild(hiddenField);
    }
    hiddenField.value = type;
}


// 라디오 버튼 선택에 따라 상세 검색/기간 검색 필드 활성화/비활성화
function toggleSearchFields(isPeriodSearch) {
    // 상세 검색 필드
    document.querySelector('select[name="search_condition"]').disabled = isPeriodSearch;
    document.querySelector('input[name="search_word"]').disabled = isPeriodSearch;
    document.querySelector('input[value="조회"][type="button"]').disabled = isPeriodSearch;

    // 기간 검색 필드
    document.querySelector('select[name="beginYear"]').disabled = !isPeriodSearch;
    document.querySelector('select[name="beginMonth"]').disabled = !isPeriodSearch;
    document.querySelector('select[name="beginDay"]').disabled = !isPeriodSearch;

    // 기간별 검색 이미지 버튼들도 활성화/비활성화
    document.querySelectorAll('#period_search_buttons a').forEach(function(link) {
        if (isPeriodSearch) {
            link.style.pointerEvents = 'auto'; // 클릭 가능
            link.style.opacity = '1';
        } else {
            link.style.pointerEvents = 'none'; // 클릭 불가능
            link.style.opacity = '0.5'; // 비활성화된 느낌
        }
    });
}

// 페이지 로드 시 초기 상태 설정
window.onload = function() {
    // 컨트롤러에서 넘어온 search_type 파라미터에 따라 초기 상태 설정
    var searchType = "${param.search_type}"; // 컨트롤러에서 넘어온 search_type 값
    var currentFixedSearchPeriod = "${param.fixedSearchPeriod}"; // 현재 고정 검색 기간

    if (searchType === 'detail') {
        document.querySelector('input[name="search_type"][value="detail"]').checked = true;
        toggleSearchFields(false);
        updateSearchTypeHidden('detail'); // Hidden 필드 업데이트
    } else { // 기본값 또는 period 검색
        document.querySelector('input[name="search_type"][value="period"]').checked = true;
        toggleSearchFields(true);
        updateSearchTypeHidden('period'); // Hidden 필드 업데이트
        
        // fixedSearchPeriod가 있는 경우 해당 날짜 선택 버튼 활성화 (선택된 것처럼 보이게)
        if (currentFixedSearchPeriod) {
             // 여기에 해당 fixedSearchPeriod 이미지 버튼에 CSS 클래스 추가 등으로 시각적 표시 가능
             // 예: $('#period_search_buttons img[alt="' + currentFixedSearchPeriod + '"]').addClass('selected-period');
        }
    }
};
</script>
</head>
<body>
    <div class="container">
	
	<div class="row row-cols-1">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold h2h2">상품 조회</h2>
			<p class="h2p"></p>
		</div>
	</div>	
    <form name="frm_search_goods" method="get" action="${contextPath}/admin/goods/adminGoodsMain.do" style="margin-top:20px;">
        <TABLE class="table" cellpadding="10">
            <TBODY>
                <TR>
                    <TD>
                        <%-- 라디오 버튼 선택에 따라 하단 검색 필드 활성화/비활성화 --%>
                        <input type="radio" name="search_type" value="period" onclick="toggleSearchFields(true); updateSearchTypeHidden('period');"
                            <c:if test="${param.search_type eq 'period' or empty param.search_type}">checked</c:if>
                        /> 등록일로 조회 &nbsp;&nbsp;&nbsp;
                        <input type="radio" name="search_type" value="detail" onclick="toggleSearchFields(false); updateSearchTypeHidden('detail');"
                            <c:if test="${param.search_type eq 'detail'}">checked</c:if>
                        /> 상세 조회 &nbsp;&nbsp;&nbsp;
                        
                        <input type="hidden" id="search_type_hidden" name="search_type" value="${param.search_type}"/>
                    </TD>
                </TR>
                <TR>
                    <TD>
                        <%-- 날짜 선택 셀렉트 박스: JSTL로 현재 년/월/일 동적으로 설정 --%>
                        <c:set var="now" value="<%=new java.util.Date()%>" />
                        <c:set var="currentYear"><fmt:formatDate value="${now}" pattern="yyyy" /></c:set>
                        <c:set var="currentMonth"><fmt:formatDate value="${now}" pattern="MM" /></c:set>
                        <c:set var="currentDay"><fmt:formatDate value="${now}" pattern="dd" /></c:set>

                        <select name="beginYear" <c:if test="${param.search_type eq 'detail'}">disabled</c:if>>
                            <c:forEach var="i" begin="0" end="5">
                                <c:set var="yearOption" value="${currentYear - i}" />
                                <option value="${yearOption}"
                                    <c:if test="${not empty param.beginYear and param.beginYear eq yearOption}">selected</c:if>
                                    <c:if test="${empty param.beginYear and currentYear eq yearOption}">selected</c:if>
                                >${yearOption}</option>
                            </c:forEach>
                        </select>년
                        <select name="beginMonth" <c:if test="${param.search_type eq 'detail'}">disabled</c:if>>
                            <c:forEach var="i" begin="1" end="12">
                                <c:set var="monthOption" value="${i < 10 ? '0' : ''}${i}" />
                                <option value="${monthOption}"
                                    <c:if test="${not empty param.beginMonth and param.beginMonth eq monthOption}">selected</c:if>
                                    <c:if test="${empty param.beginMonth and currentMonth eq monthOption}">selected</c:if>
                                >${i}</option>
                            </c:forEach>
                        </select>월
                        <select name="beginDay" <c:if test="${param.search_type eq 'detail'}">disabled</c:if>>
                            <c:forEach var="i" begin="1" end="31">
                                <c:set var="dayOption" value="${i < 10 ? '0' : ''}${i}" />
                                <option value="${dayOption}"
                                    <c:if test="${not empty param.beginDay and param.beginDay eq dayOption}">selected</c:if>
                                    <c:if test="${empty param.beginDay and currentDay eq dayOption}">selected</c:if>
                                >${i}</option>
                            </c:forEach>
                        </select>일 &nbsp;이전&nbsp;&nbsp;&nbsp;&nbsp;

                        <%-- 날짜 검색 버튼들을 감싸는 div 추가 (JavaScript에서 활용) --%>
                        <div id="period_search_buttons" style="display:inline-block;">
                            <a href="javascript:search_goods_list('today')">
                                <img src="${contextPath}/resources/image/btn_search_one_day.jpg" alt="오늘">
                            </a>
                            <a href="javascript:search_goods_list('one_week')">
                                <img src="${contextPath}/resources/image/btn_search_1_week.jpg" alt="1주일">
                            </a>
                            <a href="javascript:search_goods_list('two_week')">
                                <img src="${contextPath}/resources/image/btn_search_2_week.jpg" alt="2주일">
                            </a>
                            <a href="javascript:search_goods_list('one_month')">
                                <img src="${contextPath}/resources/image/btn_search_1_month.jpg" alt="1개월">
                            </a>
                            <a href="javascript:search_goods_list('two_month')">
                                <img src="${contextPath}/resources/image/btn_search_2_week.jpg" alt="2개월">
                            </a>
                            <a href="javascript:search_goods_list('three_month')">
                                <img src="${contextPath}/resources/image/btn_search_3_month.jpg" alt="3개월">
                            </a>
                            <a href="javascript:search_goods_list('four_month')">
                                <img src="${contextPath}/resources/image/btn_search_4_month.jpg" alt="4개월">
                            </a>
                        </div>
                        &nbsp;까지 조회
                    </TD>
                </TR>
                <tr>
                    <td>
                        <%-- 상세 검색 필드 (초기에는 비활성화) --%>
                        <select name="search_condition" <c:if test="${param.search_type ne 'detail'}">disabled</c:if>>
                            <option value="all" <c:if test="${param.search_condition eq 'all'}">selected</c:if>>전체</option>
                            <option value="goods_num" <c:if test="${param.search_condition eq 'goods_num'}">selected</c:if>>상품번호</option>
                            <option value="goods_name" <c:if test="${param.search_condition eq 'goods_name'}">selected</c:if>>상품이름</option>
                            <option value="goods_maker" <c:if test="${param.search_condition eq 'goods_maker'}">selected</c:if>>제조사</option>
                        </select>
                        <input type="text" name="search_word" size="30" value="${param.search_word}"
                            <c:if test="${param.search_type ne 'detail'}">disabled</c:if>/>
                        <input type="button" value="조회" onclick="submit_detail_search()"
                            <c:if test="${param.search_type ne 'detail'}">disabled</c:if>/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <%-- 현재 조회 기간 표시 (날짜 값은 컨트롤러에서 Model에 담아 전달해야 함) --%>
                        조회한 기간:
                        <%-- beginDate와 endDate가 null이 아닐 때만 표시. 상세 검색 시에는 비어있음 --%>
                        <c:if test="${not empty beginDate}">
                            <input type="text" size="4" value="<fmt:formatDate value="${beginDate}" pattern="yyyy"/>" readonly />년
                            <input type="text" size="4" value="<fmt:formatDate value="${beginDate}" pattern="MM"/>" readonly />월
                            <input type="text" size="4" value="<fmt:formatDate value="${beginDate}" pattern="dd"/>" readonly />일
                            &nbsp; ~
                            <input type="text" size="4" value="<fmt:formatDate value="${endDate}" pattern="yyyy"/>" readonly />년
                            <input type="text" size="4" value="<fmt:formatDate value="${endDate}" pattern="MM"/>" readonly />월
                            <input type="text" size="4" value="<fmt:formatDate value="${endDate}" pattern="dd"/>" readonly />일
                        </c:if>

                        <%-- 실제 서버로 전송될 hidden 필드 --%>
                        <input type="hidden" name="begin_date" value="<fmt:formatDate value="${beginDate}" pattern="yyyy-MM-dd"/>" />
                        <input type="hidden" name="end_date" value="<fmt:formatDate value="${endDate}" pattern="yyyy-MM-dd"/>" />
                        <input type="hidden" name="fixedSearchPeriod" value="${param.fixedSearchPeriod}" />
                        <input type="hidden" name="cur_page" value="${param.pageNum != null ? param.pageNum : 1}" />
                        <input type="hidden" name="chapter" value="${param.chapter != null ? param.chapter : 1}" />
                    </td>
                </tr>
            </TBODY>
        </TABLE>
        <DIV class="clear"></DIV>
    </form>
    <DIV class="clear"></DIV>
	
		<TABLE class="table">
        <TBODY align="center">
            <tr style="background:#33cc00; color:white;">
                <td>상품번호</td>
                <td>상품이름</td>
                <td>제조사</td>
                <td>판매가격(할인 후)</td>
                <td>등록일</td>
                <td>판매상태</td>
            </tr>
            <c:choose>
                <c:when test="${empty newGoodsList}">
                    <TR>
                        <TD colspan="6" class="fixed">
                            <strong>조회된 상품이 없습니다.</strong>
                        </TD>
                    </TR>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${newGoodsList}">
                        <TR>
                            <TD>
                                <strong>${item.goods_num}</strong>
                            </TD>
                            <TD>
                                <a href="${contextPath}/admin/goods/modifyGoodsForm.do?goods_num=${item.goods_num}">
                                    <strong>${item.goods_name}</strong>
                                </a>
                            </TD>
                            <TD>
                                <strong>${item.goods_maker}</strong>
                            </TD>
                            <td>
                                <strong><fmt:formatNumber value="${item.goods_sales_price}" type="number" /></strong>
                            </td>
                            <td>
                                <strong><fmt:formatDate value="${item.goods_credate}" pattern="yyyy-MM-dd" /></strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${item.del_yn eq 'Y'}">
                                        <strong class="status-deleted">삭제됨</strong>
                                    </c:when>
                                    <c:otherwise>
                                        <strong class="status-active">판매중</strong>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </TR>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            <tr>
                <td colspan="6" class="fixed">
                    <%-- 페이징: chapter와 pageNum을 사용하여 페이지 이동. 필요에 따라 현재 페이지를 나타내는 로직 추가 --%>
                    <c:if test="${section > 1}">
                        <a href="${contextPath}/admin/goods/adminGoodsMain.do?chapter=${section-1}&pageNum=1
                            <c:if test="${not empty param.fixedSearchPeriod}">
                                &fixedSearchPeriod=${param.fixedSearchPeriod}
                            </c:if>
                            <c:if test="${not empty param.search_type}">
                                &search_type=${param.search_type}
                            </c:if>
                            <c:if test="${not empty param.search_condition}">
                                &search_condition=${param.search_condition}&search_word=${param.search_word}
                            </c:if>
                            ">&lt;&lt; 이전</a>
                    </c:if>

                    <c:forEach var="page" begin="1" end="10" step="1">
                        <c:set var="currentPageNum" value="${(section-1)*10 + page}" />
                        <%-- 전체 상품 개수가 0보다 크고, 해당 페이지가 전체 상품 개수 범위 내에 있을 때만 페이지 번호 표시 --%>
                        <c:if test="${totalGoodsCount > 0 && currentPageNum le totalGoodsCount}">
                            <a href="${contextPath}/admin/goods/adminGoodsMain.do?chapter=${section}&pageNum=${currentPageNum}
                                <c:if test="${not empty param.fixedSearchPeriod}">
                                    &fixedSearchPeriod=${param.fixedSearchPeriod}
                                </c:if>
                                <c:if test="${not empty param.search_type}">
                                    &search_type=${param.search_type}
                                </c:if>
                                <c:if test="${not empty param.search_condition}">
                                    &search_condition=${param.search_condition}&search_word=${param.search_word}
                                </c:if>
                                ">
                                <c:choose>
                                    <c:when test="${(param.pageNum eq currentPageNum) or (empty param.pageNum and currentPageNum eq 1 and (empty param.search_type or param.search_type eq 'period'))}">
                                        <b>${currentPageNum}</b>
                                    </c:when>
                                    <c:when test="${(param.pageNum eq currentPageNum) and (not empty param.search_type and param.search_type eq 'detail')}">
                                        <b>${currentPageNum}</b>
                                    </c:when>
                                    <c:otherwise>
                                        ${currentPageNum}
                                    </c:otherwise>
                                </c:choose>
                            </a>
                        </c:if>
                    </c:forEach>

                    <%-- 다음 섹션으로 이동 링크 (전체 상품 개수가 다음 섹션의 시작 페이지보다 많을 경우) --%>
                    <c:if test="${totalGoodsCount > (section * 10)}">
                        <a href="${contextPath}/admin/goods/adminGoodsMain.do?chapter=${section+1}&pageNum=${section*10+1}
                            <c:if test="${not empty param.fixedSearchPeriod}">
                                &fixedSearchPeriod=${param.fixedSearchPeriod}
                            </c:if>
                            <c:if test="${not empty param.search_type}">
                                &search_type=${param.search_type}
                            </c:if>
                            <c:if test="${not empty param.search_condition}">
                                &search_condition=${param.search_condition}&search_word=${param.search_word}
                            </c:if>
                            ">다음 &gt;&gt;</a>
                    </c:if>
                </td>
            </tr>
        </TBODY>
    </TABLE>
    <form action="${contextPath}/admin/goods/addNewGoodsForm.do" style="width:100%; text-align:right;">
        <input type="submit" value="상품 등록하기" >
    </form>
	</div>
</body>
</html>