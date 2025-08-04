<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>

<c:choose>
<c:when test='${modified_personal_info==true }'>
<script>
window.onload=function()
{
  test();
}

function test(){
	alert("회원 정보가 수정되었습니다.");
}
</script>
</c:when>
<c:otherwise>
<script>
window.onload=function()
{
  test();
}

function test(){
}
</script>
</c:otherwise>
</c:choose>
 <script>
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var fullRoadAddr = data.roadAddress;
                var extraRoadAddr = '';
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                if(fullRoadAddr !== ''){
                    fullRoadAddr += extraRoadAddr;
                }

                document.getElementById('zipcode').value = data.zonecode;
                document.getElementById('roadAddress').value = fullRoadAddr;
                document.getElementById('jibunAddress').value = data.jibunAddress;
                if(data.autoRoadAddress) {
                    var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
                    document.getElementById('guide').innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
                } else if(data.autoJibunAddress) {
                    var expJibunAddr = data.autoJibunAddress;
                    document.getElementById('guide').innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
                } else {
                    document.getElementById('guide').innerHTML = '';
                }
            }
        }).open();
    }
</script>
<script>
function fn_modify_member_info(member_id,mod_type){
	var value;
	var frm_mod_member=document.frm_mod_member;
	if(mod_type=='member_pw'){
		value=frm_mod_member.member_pw.value;
	}else if(mod_type=='member_gender'){
		var member_gender=frm_mod_member.member_gender;
		for(var i=0; i < member_gender.length; i++){
		 	if(member_gender[i].checked){
					value=member_gender[i].value;
					break;
				} 
		}
	}else if(mod_type=='member_birth'){
		var member_birth_y=frm_mod_member.member_birth_y;
		var member_birth_m=frm_mod_member.member_birth_m;
		var member_birth_d=frm_mod_member.member_birth_d;
		var member_birth_gn=frm_mod_member.member_birth_gn;
		
		for(var i=0; i < member_birth_y.length; i++){
		 	if(member_birth_y[i].selected){
					value_y=member_birth_y[i].value;
					break;
				} 
		}
		for(var i=0; i < member_birth_m.length; i++){
		 	if(member_birth_m[i].selected){
					value_m=member_birth_m[i].value;
					break;
				} 
		}
		
		for(var i=0; i < member_birth_d.length; i++){
		 	if(member_birth_d[i].selected){
					value_d=member_birth_d[i].value;
					break;
				} 
		}
		
		for(var i=0; i < member_birth_gn.length; i++){
		 	if(member_birth_gn[i].checked){
					value_gn=member_birth_gn[i].value;
					break;
				} 
		}
		// 불필요한 + 기호를 제거하고 값을 제대로 조합
		value=value_y+","+value_m+","+value_d+","+value_gn;
	}else if(mod_type=='tel'){
		var tel1=frm_mod_member.tel1;
		var tel2=frm_mod_member.tel2;
		var tel3=frm_mod_member.tel3;
		
		var value_tel1=tel1.value;
		value_tel2=tel2.value;
		value_tel3=tel3.value;
		
		value=value_tel1+","+value_tel2+","+value_tel3;
	}else if(mod_type=='smssts_yn'){
		var smssts_yn=frm_mod_member.smssts_yn;
		value=smssts_yn.checked ? "Y" : "N";
	}else if(mod_type=='email'){
		var email1=frm_mod_member.email1;
		var email2=frm_mod_member.email2;
		var emailsts_yn=frm_mod_member.emailsts_yn;
		
		value_email1=email1.value;
		value_email2=email2.value;
		value_emailsts_yn=emailsts_yn.checked ? "Y" : "N";
		
		// email1, email2, emailsts_yn 값을 모두 value에 담아 전달
		value=value_email1+","+value_email2+","+value_emailsts_yn;
	}else if(mod_type=='address'){
		var zipcode=frm_mod_member.zipcode;
		var roadAddress=frm_mod_member.roadAddress;
		var jibunAddress=frm_mod_member.jibunAddress;
		var namujiAddress=frm_mod_member.namujiAddress;
		
		value_zipcode=zipcode.value;
		value_roadAddress=roadAddress.value;
		value_jibunAddress=jibunAddress.value;
		value_namujiAddress=namujiAddress.value;
		
		value=value_zipcode+","+value_roadAddress+","+value_jibunAddress+","+value_namujiAddress;
	}
 
	$.ajax({
		type : "post",
		async : false,
		url : "${contextPath}/admin/member/modifyMemberInfo.do",
		data : {
			member_id:member_id,
			mod_type:mod_type,
			value:value
		},
		success : function(data, textStatus) {
			if(data.trim()=='mod_success'){
				alert("회원 정보를 수정했습니다.");
			}else if(data.trim()=='failed'){
				alert("다시 시도해 주세요.");	
			}
		},
		error : function(data, textStatus) {
			alert("에러가 발생했습니다."+data);
		},
		complete : function(data, textStatus) {
			
		}
	}); //end ajax
}

function fn_delete_member(member_id ,del_yn){
	var frm_mod_member=document.frm_mod_member;
	var i_member_id = document.createElement("input");
	var i_del_yn = document.createElement("input");
    
    i_member_id.name="member_id";
    i_del_yn.name="del_yn";
    i_member_id.value=member_id;
    i_del_yn.value=del_yn;
    
    frm_mod_member.appendChild(i_member_id);
    frm_mod_member.appendChild(i_del_yn);
    frm_mod_member.method="post";
    frm_mod_member.action="${contextPath}/admin/member/deleteMember.do";
    frm_mod_member.submit();
}
</script>
</head>

<body>
	<h3>내 상세 정보</h3>
<form name="frm_mod_member">	
	<div id="detail_table">
		<table>
			<tbody>
				<tr class="dot_line">
					<td class="fixed_join">아이디</td>
					<td>
						<input name="member_id" type="text" size="20" value="${member_info.member_id }"  disabled/>
					</td>
					 <td>
					  <input type="button" value="수정하기" disabled onClick="fn_modify_member_info('${member_info.member_id }','member_name')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">비밀번호</td>
					<td>
					  <input name="member_pw" type="password" size="20" value="${member_info.member_pw }" />
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('${member_info.member_id }','member_pw')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">이름</td>
					<td>
					  <input name="member_name" type="text" size="20" value="${member_info.member_name }"  disabled />
					 </td>
					 <td>
					  <input type="button" value="수정하기" disabled onClick="fn_modify_member_info('${member_info.member_id }','member_name')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">성별</td>
					<td>
					  <c:choose >
					    <c:when test="${member_info.member_gender =='101' }">
					      <input type="radio" name="member_gender" value="102" />
						  여성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					   <input type="radio" name="member_gender" value="101" checked />남성
					    </c:when>
					    <c:otherwise>
					      <input type="radio" name="member_gender" value="102"  checked />
						   여성&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					      <input type="radio" name="member_gender" value="101"  />남성
					   </c:otherwise>
					   </c:choose>
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('${member_info.member_id }','member_gender')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">법정생년월일</td>
					<td>
					   <select name="member_birth_y">
					     <c:forEach var="i" begin="1" end="100">
					       <c:choose>
					         <c:when test="${member_info.member_birth_y==1920+i }">
							   <option value="${ 1920+i}" selected>${ 1920+i} </option>
							</c:when>
							<c:otherwise>
							  <option value="${ 1920+i}" >${ 1920+i} </option>
							</c:otherwise>
							</c:choose>
					   	</c:forEach>
					</select>년 
					<select name="member_birth_m" >
						<c:forEach var="i" begin="1" end="12">
					       <c:choose>
					         <c:when test="${member_info.member_birth_m==i }">
							   <option value="${i }" selected>${i }</option>
							</c:when>
							<c:otherwise>
							  <option value="${i }">${i }</option>
							</c:otherwise>
							</c:choose>
					   	</c:forEach>
					</select>월 
					
					<select name="member_birth_d">
							<c:forEach var="i" begin="1" end="31">
					       <c:choose>
					         <c:when test="${member_info.member_birth_d==i }">
							   <option value="${i }" selected>${i }</option>
							</c:when>
							<c:otherwise>
							  <option value="${i }">${i }</option>
							</c:otherwise>
							</c:choose>
					   	</c:forEach>
					</select>일 
					
					   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					   <c:choose>
					   <c:when test="${member_info.member_birth_gn=='2' }"> 
					  <input type="radio" name="member_birth_gn" value="2" checked />양력
						&nbsp;&nbsp;&nbsp; 
						<input type="radio"  name="member_birth_gn" value="1" />음력
						</c:when>
						<c:otherwise>
						  <input type="radio" name="member_birth_gn" value="2" />양력
						   &nbsp;&nbsp;&nbsp; 
						<input type="radio"  name="member_birth_gn" value="1" checked  />음력
						</c:otherwise>
						</c:choose>
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('${member_info.member_id }','member_birth')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">전화번호</td>
					<td>
						<input type="text" size=4 name="tel1" value="${member_info.tel1 }">
					    - <input type="text" size=4  name="tel2" value="${member_info.tel2 }"> 
					    - <input type="text" size=4  name="tel3" value="${member_info.tel3 }">
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('${member_info.member_id }','tel')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">SMS 수신 여부</td>
					<td>
					 <c:choose> 
					   <c:when test="${member_info.smssts_yn=='Y' }">
					     <input type="checkbox"  name="smssts_yn" value="Y" checked /> 쇼핑몰에서 발송하는 SMS 소식을 수신합니다.
						</c:when>
						<c:otherwise>
						  <input type="checkbox"  name="smssts_yn" value="N"  /> 쇼핑몰에서 발송하는 SMS 소식을 수신합니다.
						</c:otherwise>
					 </c:choose>	
				    </td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('${member_info.member_id }','smssts_yn')" />
					</td>	
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">이메일(e-mail)</td>
					<td>
					   <input type="text" name="email1" size=10 value="${member_info.email1 }" /> @ <input type="text" size=10  name="email2" value="${member_info.email2 }" /> 
					   <select name="select_email2" onChange=""  title="직접입력">
							<option value="non">직접입력</option>
							<option value="hanmail.net">hanmail.net</option>
							<option value="naver.com">naver.com</option>
							<option value="yahoo.co.kr">yahoo.co.kr</option>
							<option value="hotmail.com">hotmail.com</option>
							<option value="paran.com">paran.com</option>
							<option value="nate.com">nate.com</option>
							<option value="google.com">google.com</option>
							<option value="gmail.com">gmail.com</option>
							<option value="empal.com">empal.com</option>
							<option value="korea.com">korea.com</option>
							<option value="freechal.com">freechal.com</option>
					</select><Br><br> 
					<c:choose> 
					   <c:when test="${member_info.emailsts_yn=='Y' }">
					     <input type="checkbox" name="emailsts_yn"  value="Y" checked /> 쇼핑몰에서 발송하는 e-mail을 수신합니다.
						</c:when>
						<c:otherwise>
						  <input type="checkbox" name="emailsts_yn"  value="N"  /> 쇼핑몰에서 발송하는 e-mail을 수신합니다.
						</c:otherwise>
					 </c:choose>
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('${member_info.member_id }','email')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">주소</td>
					<td>
					   <input type="text" id="zipcode" name="zipcode" size=5 value="${member_info.zipcode }" > <a href="javascript:execDaumPostcode()">우편번호검색</a>
					  <br>
					  <p> 
					   지번 주소:<br><input type="text" id="roadAddress"  name="roadAddress" size="50" value="${member_info.roadAddress }"><br><br>
					  도로명 주소: <input type="text" id="jibunAddress" name="jibunAddress" size="50" value="${member_info.jibunAddress }"><br><br>
					  나머지 주소: <input type="text"  name="namujiAddress" size="50" value="${member_info.namujiAddress }" />
					   <span id="guide" style="color:#999"></span>
					   </p>
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('${member_info.member_id }','address')" />
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
				<input type="hidden" name="command"  value="modify_my_info" /> 
				<c:choose>
				  <c:when test="${member_info.del_yn=='Y' }">
				    <input  type="button"  value="회원복원" onClick="fn_delete_member('${member_info.member_id }','N')">   
				  </c:when>
				  <c:when  test="${member_info.del_yn=='N' }">
				    <input  type="button"  value="회원탈퇴" onClick="fn_delete_member('${member_info.member_id }','Y')">
				  </c:when>
				</c:choose>
			</td>
		</tr>
	</table>
	</div>
</form>	
</body>
</html>