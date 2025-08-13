<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"	isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
    <c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>객실 수정</title>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
<form action="${contextPath}/business/modifypension.do" method="post">	
	<div id="detail_table">
		<table>
			<tbody>
				<tr class="dot_line">
					<td class="fixed_join">업체 명</td>
					<td>
						<input name="p_name" type="text" size="20" value="${pensionInfo.p_name}"/>
					</td>

				</tr>
					<tr class="dot_line">
					<td class="fixed_join">업체 전화 번호</td>
					<td>
						<input name="tel1" type="text" size="4" value="${pensionInfo.tel1}" /> 
					   -<input name="tel2" type="text" size="4" value="${pensionInfo.tel2}" />
					   -<input name="tel3" type="text" size="4" value="${pensionInfo.tel3}" />
					</td>

				</tr>

					<tr class="dot_line">
					<td class="fixed_join">객실 수</td>
					<td>
						<input name="room_count" type="text" size="20" value="${pensionInfo.room_count}"  />
					</td>

					<tr class="dot_line">
					<td class="fixed_join">시설 정보</td>
					<td>
						<textarea name="facilities" rows="4" cols="50" >${pensionInfo.facilities}</textarea>
					</td>
				</tr>
					<tr class="dot_line">
					<td class="fixed_join">설명</td>
					<td>
						<textarea name="description" rows="4" cols="50" >${pensionInfo.description}</textarea>
					</td>
				</tr>
				<tr>
				<td>
					<input type="submit" value="수정하기">
				</td>
				</tr>
			</tbody>
		</table>
	</div>
</form>
</body>
</html>