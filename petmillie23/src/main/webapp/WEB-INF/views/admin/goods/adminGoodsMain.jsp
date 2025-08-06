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
function search_goods_list(fixedSearchPeriod) {
	var formObj = document.createElement("form");
	var i_fixedSearch_period = document.createElement("input");
	i_fixedSearch_period.name = "fixedSearchPeriod";
	i_fixedSearch_period.value = fixedSearchPeriod;
	formObj.appendChild(i_fixedSearch_period);
	document.body.appendChild(formObj);
	formObj.method = "get";
	formObj.action = "${contextPath}/admin/goods/adminGoodsMain.do";
	formObj.submit();
}

function calcPeriod(search_period) {
	var dt = new Date();
	var beginYear, endYear;
	var beginMonth, endMonth;
	var beginDay, endDay;
	var beginDate, endDate;

	endYear = dt.getFullYear();
	endMonth = dt.getMonth() + 1;
	endDay = dt.getDate();
	if (search_period == 'today') {
		beginYear = endYear;
		beginMonth = endMonth;
		beginDay = endDay;
	} else if (search_period == 'one_week') {
		beginYear = dt.getFullYear();
		beginMonth = dt.getMonth() + 1;
		dt.setDate(endDay - 7);
		beginDay = dt.getDate();
	} else if (search_period == 'two_week') {
		beginYear = dt.getFullYear();
		beginMonth = dt.getMonth() + 1;
		dt.setDate(endDay - 14);
		beginDay = dt.getDate();
	} else if (search_period == 'one_month') {
		beginYear = dt.getFullYear();
		dt.setMonth(endMonth - 1);
		beginMonth = dt.getMonth();
		beginDay = dt.getDate();
	} else if (search_period == 'two_month') {
		beginYear = dt.getFullYear();
		dt.setMonth(endMonth - 2);
		beginMonth = dt.getMonth();
		beginDay = dt.getDate();
	} else if (search_period == 'three_month') {
		beginYear = dt.getFullYear();
		dt.setMonth(endMonth - 3);
		beginMonth = dt.getMonth();
		beginDay = dt.getDate();
	} else if (search_period == 'four_month') {
		beginYear = dt.getFullYear();
		dt.setMonth(endMonth - 4);
		beginMonth = dt.getMonth();
		beginDay = dt.getDate();
	}

	if (beginMonth < 10) {
		beginMonth = '0' + beginMonth;
		if (beginDay < 10) {
			beginDay = '0' + beginDay;
		}
	}
	if (endMonth < 10) {
		endMonth = '0' + endMonth;
		if (endDay < 10) {
			endDay = '0' + endDay;
		}
	}
	endDate = endYear + '-' + endMonth + '-' + endDay;
	beginDate = beginYear + '-' + beginMonth + '-' + beginDay;
	//alert(beginDate+","+endDate);
	return beginDate + "," + endDate;
}
</script>
</head>
<body>
<div class="container text-center mt-3 mb-3">
   <H3>상품 조회</H3>
	<form method="post">
		<TABLE cellpadding="10" cellspacing="10">
			<TBODY>
				<TR>
					<TD>
						<input type="radio" name="r_search" checked /> 등록일로조회 &nbsp;&nbsp;&nbsp;
						<input type="radio" name="r_search" />상세조회 &nbsp;&nbsp;&nbsp;
					</TD>
				</TR>
				<TR>
					<TD>
						<select name="curYear">
							<c:forEach var="i" begin="0" end="5">
								<c:choose>
									<c:when test="${endYear == endYear - i}">
										<option value="${endYear}" selected>${endYear}</option>
									</c:when>
									<c:otherwise>
										<option value="${endYear - i}">${endYear - i}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>년
						<select name="curMonth">
							<c:forEach var="i" begin="1" end="12">
								<c:choose>
									<c:when test="${endMonth == i}">
										<option value="${i}" selected>${i}</option>
									</c:when>
									<c:otherwise>
										<option value="${i}">${i}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>월
				
						<select name="curDay">
							<c:forEach var="i" begin="1" end="31">
								<c:choose>
									<c:when test="${endDay == i}">
										<option value="${i}" selected>${i}</option>
									</c:when>
									<c:otherwise>
										<option value="${i}">${i}</option>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</select>일 &nbsp;이전&nbsp;&nbsp;&nbsp;&nbsp;
						<a href="javascript:search_goods_list('today')">
							<img src="${contextPath}/resources/image/btn_search_one_day.jpg">
						</a>
						<a href="javascript:search_goods_list('one_week')">
							<img src="${contextPath}/resources/image/btn_search_1_week.jpg">
						</a>
						<a href="javascript:search_goods_list('two_week')">
							<img src="${contextPath}/resources/image/btn_search_2_week.jpg">
						</a>
						<a href="javascript:search_goods_list('one_month')">
							<img src="${pageContext.request.contextPath}/resources/image/btn_search_1_month.jpg">
						</a>
						<a href="javascript:search_goods_list('two_month')">
							<img src="${contextPath}/resources/image/btn_search_2_month.jpg">
						</a>
						<a href="javascript:search_goods_list('three_month')">
							<img src="${contextPath}/resources/image/btn_search_3_month.jpg">
						</a>
						<a href="javascript:search_goods_list('four_month')">
							<img src="${contextPath}/resources/image/btn_search_4_month.jpg">
						</a>
						&nbsp;까지 조회
					</TD>
				</TR>
				<tr>
					<td>
						<select name="search_condition" >
							<option value="전체" checked>전체</option>
							<option value="제품번호">상품번호</option>
							<option value="제품이름">상품이름</option>
							<option value="제조사">제조사</option>
						</select>
						<input type="text" size="30"  />
						<input type="button" value="조회"  />
					</td>
				</tr>
				<tr>
					<td>
						조회한 기간:
						<input type="text" size="4" value="${beginYear}" />년
						<input type="text" size="4" value="${beginMonth}" />월
						<input type="text" size="4" value="${beginDay}" />일
						&nbsp; ~
						<input type="text" size="4" value="${endYear}" />년
						<input type="text" size="4" value="${endMonth}" />월
						<input type="text" size="4" value="${endDay}" />일
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