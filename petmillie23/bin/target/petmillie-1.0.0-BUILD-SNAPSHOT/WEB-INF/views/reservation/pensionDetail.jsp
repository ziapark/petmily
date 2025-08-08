<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${pension.p_name} 상세 정보</title>
<style>
    .pension-detail { width: 80%; margin: 20px auto; border: 1px solid #ddd; padding: 20px; border-radius: 8px; }
    .pension-detail h2 { border-bottom: 2px solid #007bff; padding-bottom: 10px; }
    .pension-detail p { font-size: 1.1em; line-height: 1.6; }
    .pension-detail .label { font-weight: bold; color: #555; display: inline-block; width: 120px;}
</style>
</head>
<body>
    <div class="pension-detail">
        <h2>${pension.p_name}</h2>
        
        <p><span class="label">연락처:</span> ${pension.tel1}-${pension.tel2}-${pension.tel3}</p>
        <p><span class="label">체크인:</span> ${pension.checkin_time}</p>
        <p><span class="label">체크아웃:</span> ${pension.checkout_time}</p>
        <p><span class="label">주요 시설:</span></p>
        <div>${pension.facilities}</div>
        <hr>
        <p><span class="label">상세 설명:</span></p>
        <div>${pension.description}</div>
        
        <br>
        <a href="${contextPath}/reservation/pensionList.do">목록으로 돌아가기</a>
    </div>
</body>
</html>