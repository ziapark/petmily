<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
	<script>
	$(document).ready(function() {
	    $('form').on('submit', function(e) {
	        console.log("폼 제출됨");  // 콘솔에서 이거 보이면 form 태그 문제는 아님
	    });
	});
	</script>
</head>
<body>
<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold">객실등록</h2>
		</div>
	</div>
	<form action="${contextPath}/business/addroom.do" method="post" enctype="multipart/form-data">	
		<input type="hidden" name="p_num" id="p_num" value="${pensionInfo.p_num}" />

	<table class="table table-bordered">
	    <tbody>
	        <tr>
	            <th scope="row">객실 이름</th>
	            <td><input type="text" class="form-control" name="room_name" required /></td>
	        </tr>
	
	        <tr>
	            <th scope="row">객실 유형</th>
	            <td>
	                <select name="room_type" class="form-select">
	                    <option value="스탠다드">스탠다드</option>
	                    <option value="디럭스">디럭스</option>
	                    <option value="스위트">스위트</option>
	                </select>
	            </td>
	        </tr>
	
	        <tr>
	            <th scope="row">1박 가격</th>
	            <td>
	                <div class="input-group">
	                    <input type="number" class="form-control" name="price" min="10000" step="1000" max="500000" required>
	                    <span class="input-group-text">원</span>
	                </div>
	            </td>
	        </tr>
	
	        <tr>
	            <th scope="row">최대 수용 인원</th>
	            <td><input type="number" class="form-control" name="max_capacity" min="1" required /></td>
	        </tr>
	
	        <tr>
	            <th scope="row">침대 종류</th>
	            <td>
	                <select name="bed_type" class="form-select">
	                    <option value="더블">더블</option>
	                    <option value="트윈">트윈</option>
	                    <option value="온돌">온돌</option>
	                </select>
	            </td>
	        </tr>
	
	        <tr>
	            <th scope="row">객실 크기</th>
	            <td><input type="text" class="form-control" name="room_size" placeholder="예: 20㎡ 또는 15평" /></td>
	        </tr>
	
	        <tr>
	            <th scope="row">객실 설명</th>
	            <td><textarea class="form-control" name="room_description" rows="4" placeholder="객실에 대한 설명을 입력하세요."></textarea></td>
	        </tr>
	
	        <tr>
	            <th scope="row">비품(편의시설)</th>
	            <td><textarea class="form-control" name="amenities" rows="4" placeholder="예: TV, 에어컨, 냉장고 등"></textarea></td>
	        </tr>
	
	        <tr>
	            <th scope="row">객실 이미지</th>
	            <td><input type="file" class="form-control" name="files" multiple required></td>
	        </tr>
	    </tbody>
	</table>


		<div class="clear">
			<br><br>
			<table align="center">
				<tr>
					<td>
						<input type="submit" value="등록하기" class="btn btn-primary" />
						<input type="reset" value="다시 입력" class="btn btn-secondary" />
					</td>
				</tr>
			</table>
		</div>
	</form>	
	</div>
</body>
</html>
