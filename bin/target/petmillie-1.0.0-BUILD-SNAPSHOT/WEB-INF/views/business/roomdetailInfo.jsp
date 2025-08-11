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
<script>
function fn_modify_business_info(attribute){
	var value;
	var room = document.frm_mod_room;
	if(attribute == 'room_name'){
		value = room.room_name.value;
	}else if(attribute =='price'){
		value = room.price.value;
	}else if(attribute == 'room_type'){
		value = room.room_type.value;
	}else if(attribute == 'bed_type'){
		value = room.bed_type.value;
	}else if(attribute == 'max_capacity'){
		value = room.max_capacity.value;
	}else if(attribute == 'room_size'){
		value = room.room_size.value;
	}else if(attribute == 'room_description'){
		value = room.room_description.value;
	}else if(attribute == 'amenities'){
		value = room.amenities.value;
	}
	$.ajax({
		type : "post",
		async : false,
		url : "${contextPath}/business/modifyroom.do",
		data : {
			attribute : attribute,
			value : value,
		},
		success : function(data, textStatus){
			if(data.trim() == 'mod_success'){
				alert("객실 정보를 수정했습니다.");
			}else if(data.trim()=='failed'){
                alert("다시 시도해 주세요.");    
            }
		},
		error: function(xhr, status, error){
		    console.log("XHR:", xhr);              // 전체 응답 객체
		    console.log("Status:", status);        // 예: "error"
		    console.log("Error:", error);          // 예: "Internal Server Error"
		    console.log("Response Text:", xhr.responseText);  // 예: 서버의 에러 메시지

		    alert("에러가 발생했습니다.\n" +
		          "상태: " + status + "\n" +
		          "에러: " + error + "\n" +
		          "응답내용: " + xhr.responseText);
		}
	});
}
</script>
</head>
<body>
<form name="frm_mod_room">	
	<div id="detail_table">
		<table>
			<tbody>
				<tr class="dot_line">
					<td class="fixed_join">객실 이름</td>
					<td>
						<input name="room_name" type="text" size="20" value="${roomInfo.room_name}"/>
					</td>
					 <td>
					 	<input type="button" value="수정하기" onClick="fn_modify_business_info('room_name')" />
					</td>
				</tr>
					<tr class="dot_line">
					<td class="fixed_join">가격</td>
					<td>
						<input name="price" type="number" min="10000" max="500000" step="1000" size="20" value="${roomInfo.price}" />
					</td>
					 <td>
					 	<input type="button" value="수정하기" onClick="fn_modify_business_info('price')" />
					</td>
				</tr>
					<tr class="dot_line">
					<td class="fixed_join">객실 타입</td>
					<td>
							<select name="room_type">
								<option value="스탠다드">스탠다드</option>
								<option value="디럭스">디럭스</option>
								<option value="스위트">스위트</option>
							</select>
					</td>
					 <td>
					 	<input type="button" value="수정하기" onClick="fn_modify_business_info('room_type')" />
					</td>
				</tr>
					<tr class="dot_line">
					<td class="fixed_join">침대 타입</td>
					<td>
							<select name="bed_type">
								<option value="더블">더블</option>
								<option value="트윈">트윈</option>
								<option value="온돌">온돌</option>
							</select>
					</td>
					 <td>
					 	<input type="button" value="수정하기" onClick="fn_modify_business_info('bed_type')" />
					</td>
				</tr>
					<tr class="dot_line">
					<td class="fixed_join">최대 인원</td>
					<td>
						<input name="max_capacity" type="text" size="20" value="${roomInfo.max_capacity}"  />
					</td>
					 <td>
					 	<input type="button" value="수정하기" onClick="fn_modify_business_info('max_capacity')" />
					</td>
				</tr>
					<tr class="dot_line">
					<td class="fixed_join">면적</td>
					<td>
						<input name="room_size" type="text" size="20" value="${roomInfo.room_size}"  />
					</td>
					 <td>
					 	<input type="button" value="수정하기" onClick="fn_modify_business_info('room_size')" />
					</td>
				</tr>
					<tr class="dot_line">
					<td class="fixed_join">설명</td>
					<td>
						<input name="room_description" type="text" size="20" value="${roomInfo.room_description}"  />
					</td>
					 <td>
					 	<input type="button" value="수정하기" onClick="fn_modify_business_info('room_description')" />
					</td>
				</tr>
					<tr class="dot_line">
					<td class="fixed_join">편의 시설</td>
					<td>
						<input name="amenities" type="text" size="20" value="${roomInfo.amenities}"  />
					</td>
					 <td>
					 	<input type="button" value="수정하기" onClick="fn_modify_business_info('amenities')" />
					</td>
				</tr>
				<tr>
					<td>
						<a href="${contextPath}/business/mypension.do?business_id=${businessInfo.business_id}"><input type="button" value="사업자 페이지 돌아가기"></a>
			</tbody>
		</table>
	</div>
</form>
</body>
</html>