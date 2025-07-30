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
</head>
<body>
<c:if test="${not empty message}">
  <script>alert("${message}");</script>
</c:if>
	<h3>객실 등록</h3>
	<form name="frm_add_room" action="${contextPath}/business/addroom.do" method="post">	
		<input type="hidden" name="p_num" id="p_num" value="${pensionInfo.p_num}" />
		<h4>펜션번호: ${pensionInfo.p_num}</h4>

		<div id="detail_table">
			<table>
				<tbody>
					<tr class="dot_line">
						<td class="fixed_join">객실 이름</td>
						<td><input type="text" name="room_name" size="20" required /></td>
					</tr>
					
					<tr class="dot_line">
						<td class="fixed_join">객실 유형</td>
						<td>
							<select name="room_type">
								<option value="스탠다드">스탠다드</option>
								<option value="디럭스">디럭스</option>
								<option value="스위트">스위트</option>
							</select>
						</td>
					</tr>

					<tr class="dot_line">
						<td class="fixed_join">1박 가격</td>
						<td><input type="number" name="price" min="10000" step="1000" max="500000" required /> 원</td>
					</tr>

					<tr class="dot_line">
						<td class="fixed_join">최대 수용 인원</td>
						<td><input type="number" name="max_capacity" min="1" required /></td>
					</tr>

					<tr class="dot_line">
						<td class="fixed_join">침대 종류</td>
						<td>
							<select name="bed_type">
								<option value="더블">더블</option>
								<option value="트윈">트윈</option>
								<option value="온돌">온돌</option>
							</select>
						</td>
					</tr>

					<tr class="dot_line">
						<td class="fixed_join">객실 크기</td>
						<td><input type="text" name="room_size" placeholder="예: 20㎡ 또는 15평" /></td>
					</tr>

					<tr class="dot_line">
						<td class="fixed_join">객실 설명</td>
						<td><textarea name="room_description" rows="4" cols="50" placeholder="객실에 대한 설명을 입력하세요."></textarea></td>
					</tr>

					<tr class="dot_line">
						<td class="fixed_join">비품(편의시설)</td>
						<td><textarea name="amenities" rows="4" cols="50" placeholder="예: TV, 에어컨, 냉장고 등"></textarea></td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="clear">
			<br><br>
			<table align="center">
				<tr>
					<td>
						<input type="submit" value="등록하기" />
						<input type="reset" value="다시 입력" />
					</td>
				</tr>
			</table>
		</div>
	</form>	
</body>
</html>
