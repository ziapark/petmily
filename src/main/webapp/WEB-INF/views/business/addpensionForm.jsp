<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html >
<html>
<head>
<meta charset="utf-8">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>

</head>
<body>
	<h3>업체 등록</h3>
<form name="frm_mod_business" action="${contextPath}/business/addpension.do" method="post">
	<input type="hidden" name="business_id" id="business_id" value="${sessionScope.businessInfo.business_id}"/>
	<div id="detail_table">
		<table>
			<tbody>
			
				<tr class="dot_line">
					<td class="fixed_join">업체명</td>
					<td>
					  <input name=p_name type="text" size="20"/>
					 </td>
					 <td>
					</td>
				</tr>
				
				<tr class="dot_line">
					<td class="fixed_join">업체 전화번호</td>
					<td>
					   <input type="text" name="tel1" id="tel1" size=4/>
					 - <input type="text" name="tel2" id="tel2" size=4/> 
					 - <input type="text" name="tel3" id="tel3" size=4/><br> <br>

				    </td>
					<td>
					</td>	
				</tr>
						
					
				<tr class="dot_line">
					<td class="fixed_join">체크인 시간</td>
					<td>
					   <input type="time" name="checkin_time" id="checkin_time" />
				    </td>
					<td>
					</td>	
				</tr>
				
				<tr class="dot_line">
					<td class="fixed_join">체크아웃 시간</td>
					<td>
					   <input type="time" name="checkout_time" id="checkout_time" />
				    </td>
					<td>
					</td>	
				</tr>
			
									
				<tr class="dot_Line">
				<td class="fixed_join">보유 객실 수</td>
				<td>
					<input type="text" id="room_count" name="room_count" size=5/>
					<br>
				</td>
				</tr>
				
				<tr class="dot_Line">
				<td class="fixed_join">시설 정보</td>
				<td>
					<input type="text" id="facilities" name="facilities" size=5/>
				</td>
				</tr>
				
				<tr class="dot_Line">
				<td class="fixed_join">펜션 설명</td>
				<td>
					<input type="text" id="description" name="description" size=5/>
				</td>
				</tr>
				
				
				
			</tbody>
		</table>
		</div>
		<div class="clear">
		<br><br>
		<table align=center>
		<tr>
			<td >
				<input name="btn_cancel_business" type="submit"  value="등록하기">
				<input name="btn_cancel_business" type="reset" value="다시 입력">
			</td>
		</tr>
	</table>
	</div>
</form>	
</body>
</html>
