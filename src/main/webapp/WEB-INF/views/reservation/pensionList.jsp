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
<title>펫밀리</title>

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
        display: block;
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
<div class="container text-center mt-3 mb-3">
    <div class="row row-cols-1 mb-3">
        <div class="col bg-light p-5 text-start">
            <h2 class="fw-bold">펜션</h2>
        </div>
    </div>

    <div class="pension-container">
        <c:if test="${not empty pensionList}">
            <c:forEach var="pension" items="${pensionList}">
                <a href="${contextPath}/reservation/pensionDetail.do?p_num=${pension.p_num}" class="pension-card">
                    
                    <%-- ▼▼▼▼▼ [수정] 이 부분만 수정했습니다. ▼▼▼▼▼ --%>
                    <img src="${contextPath}/pension/image.do?fileName=${pension.fileName}&business_id=${pension.business_id}" alt="${pension.p_name} 이미지" 
                         onerror="this.onerror=null; this.src='${contextPath}/resources/image/default_pension.png';">
                    
                    <div class="card-body pension_card_body">
                        <h5>${pension.p_name}</h5>
                        <p>
                            <c:set var="desc" value="${pension.description}" />
                            <c:if test="${fn:length(desc) > 50}">
                                ${fn:substring(desc, 0, 50)}...
                            </c:if>
                            <c:if test="${fn:length(desc) <= 50}">
                                ${desc}
                            </c:if>
                        </p>
                        <p><strong>시설:</strong> ${pension.facilities}</p>
                        <p><strong>전화번호:</strong> ${pension.tel1} - ${pension.tel2} - ${pension.tel3}</p>
                        <p><strong>체크인:</strong> ${pension.checkin_time}</p>
                        <p><strong>체크아웃:</strong> ${pension.checkout_time}</p>
                    </div>
                </a>
            </c:forEach>
        </c:if>
        
        <c:if test="${empty pensionList}">
            <p>현재 등록된 펜션이 없습니다.</p>
        </c:if>
    </div>
</div>

</body>
</html>