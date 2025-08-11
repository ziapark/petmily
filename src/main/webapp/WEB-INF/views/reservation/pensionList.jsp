<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>펜션 예약</title>
<link rel="stylesheet" href="css/common.css">
<style>
    .pension-container {
        display: flex;
        flex-wrap: wrap;
        gap: 20px;
        padding: 20px;
        justify-content: center;
    }
    .pension-card {
        width: 350px;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        transition: transform 0.2s;
        text-decoration: none;
        color: inherit;
        display: block; /* a 태그를 블록 요소로 만들어 클릭 영역을 넓힙니다. */
    }
    .pension-card:hover {
        transform: translateY(-5px);
    }
    .pension-card img {
        width: 100%;
        height: 200px;
        object-fit: cover;
    }
    .card-body {
        padding: 15px;
    }
    .card-body h5 {
        margin-top: 0;
        font-size: 1.25rem;
        color: #333;
    }
    .card-body p {
        margin: 5px 0;
        color: #666;
    }
</style>
</head>
<body>

<div class="container text-center mt-3">
    <h2>펜션 목록</h2>
    <div class="pension-container">
        <c:if test="${not empty pensionList}">
            <c:forEach var="pension" items="${pensionList}">
                <%-- ▼▼▼▼▼ [ 이 부분의 href 링크를 수정했습니다! ] ▼▼▼▼▼ --%>
                <a href="${contextPath}/reservation/pensionDetail.do?pensionId=${pension.p_num}" class="pension-card">
                    
                    <%-- 이미지 경로가 맞는지 확인해보세요. 예시로 이미지가 없을 경우를 대비한 경로를 추가했습니다. --%>
                    <img src="${contextPath}/thumbnails.do?goods_id=${pension.p_num}" alt="${pension.p_name} 이미지" 
                         onerror="this.onerror=null; this.src='${contextPath}/resources/image/default_pension.png';">
                    
                    <div class="card-body">
                        <h5>${pension.p_name}</h5>
                        <p><strong>설명:</strong> 
                            <c:set var="desc" value="${pension.description}" />
                            <c:if test="${fn:length(desc) > 50}">
                                ${fn:substring(desc, 0, 50)}...
                            </c:if>
                            <c:if test="${fn:length(desc) <= 50}">
                                ${desc}
                            </c:if>
                        </p>
                        <p><strong>시설:</strong> ${pension.facilities}</p>
                    </div>
                </a>
                <%-- ▲▲▲▲▲ [ 링크 수정 완료! ] ▲▲▲▲▲ --%>
            </c:forEach>
        </c:if>
        
        <c:if test="${empty pensionList}">
            <p>현재 등록된 펜션이 없습니다.</p>
        </c:if>
    </div>
</div>

</body>
</html>