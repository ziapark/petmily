<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"	isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>펫밀리</title>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold">객실수정</h2>
		</div>
	</div>
<form action="${contextPath}/business/modifypension.do" method="post">	
	
		<table class="table table-bordered">
    <tbody>
        <tr>
            <th scope="row">업체 명</th>
            <td>
                <input name="p_name" type="text" class="form-control" value="${pensionInfo.p_name}" />
            </td>
        </tr>

        <tr>
            <th scope="row">업체 전화 번호</th>
            <td>
                <div class="input-group">
                    <input name="tel1" type="text" class="form-control" size="4" value="${pensionInfo.tel1}" />
                    <span class="input-group-text">-</span>
                    <input name="tel2" type="text" class="form-control" size="4" value="${pensionInfo.tel2}" />
                    <span class="input-group-text">-</span>
                    <input name="tel3" type="text" class="form-control" size="4" value="${pensionInfo.tel3}" />
                </div>
            </td>
        </tr>

        <tr>
            <th scope="row">객실 수</th>
            <td>
                <input name="room_count" type="number" class="form-control" value="${pensionInfo.room_count}" />
            </td>
        </tr>

        <tr>
            <th scope="row">시설 정보</th>
            <td>
                <textarea name="facilities" class="form-control" rows="4">${pensionInfo.facilities}</textarea>
            </td>
        </tr>

        <tr>
            <th scope="row">설명</th>
            <td>
                <textarea name="description" class="form-control" rows="4">${pensionInfo.description}</textarea>
            </td>
        </tr>

        <tr>
            <td colspan="2" class="text-center">
                <button type="submit" class="btn btn-primary">수정하기</button>
            </td>
        </tr>
    </tbody>
</table>

	
</form>
</div>
</body>
</html>