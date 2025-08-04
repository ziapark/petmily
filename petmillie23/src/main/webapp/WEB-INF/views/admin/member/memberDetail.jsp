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
 <script>
 function changeEmailDomain() {
	  var email2Select = document.getElementById("email2_select");
	  var email2Direct = document.getElementById("email2_direct");
	  if(email2Select.value == "non") {
	    email2Direct.style.display = "inline";
	    email2Direct.value = ""; // 직접입력 초기화
	    email2Direct.focus();
	  } else {
	    email2Direct.style.display = "none";
	    email2Direct.value = email2Select.value;
	  }
	}

	// form submit 전에 호출해서 실제 email 합치기
	function setEmail() {
	  var email1 = document.getElementById("email1").value;
	  var email2;
	  var email2Select = document.getElementById("email2_select");
	  if(email2Select.value == "non") {
	    email2 = document.getElementById("email2_direct").value;
	  } else {
	    email2 = email2Select.value;
	  }
	  document.getElementById("member_email").value = email1 + "@" + email2;
	  return true;
	}

    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 도로명 조합형 주소 변수

                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraRoadAddr !== ''){
                    extraRoadAddr = ' (' + extraRoadAddr + ')';
                }
                // 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
                if(fullRoadAddr !== ''){
                    fullRoadAddr += extraRoadAddr;
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('zipcode').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('roadAddress').value = fullRoadAddr;
                document.getElementById('jibunAddress').value = data.jibunAddress;

                // 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
                if(data.autoRoadAddress) {
                    //예상되는 도로명 주소에 조합형 주소를 추가한다.
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

   
   window.onload=function()
    {
      selectBoxInit();
    }

    function selectBoxInit(){
    
     var tel1='${member_info.tel1 }';
     var selTel1 = document.getElementById('tel1');
     var optionTel1 = selTel1.options;
     var val;
     for(var i=0; i<optionTel1.length;i++){
       val = optionTel1[i].value;
       if(tel1 == val){
    	   optionTel1[i].selected= true;
        break;
       }
     }  
     
   }


    function fn_modify_member_info(attribute) {
        var value;
        var frm_mod_member = document.frm_mod_member;
        if(attribute=='member_pw'){
            value = frm_mod_member.member_pw.value;
        } else if(attribute=='member_gender'){
            var member_gender = frm_mod_member.member_gender;
            for(var i=0; i<member_gender.length; i++){
                if(member_gender[i].checked){
                    value = member_gender[i].value;
                    break;
                }
            }
        } else if(attribute=='member_birth'){
            var value_y = frm_mod_member.member_birth_y.value;
            var value_m = frm_mod_member.member_birth_m.value;
            var value_d = frm_mod_member.member_birth_d.value;
            var value_gn;
            var member_birth_gn = frm_mod_member.member_birth_gn;
            for(var i=0; i<member_birth_gn.length; i++){
                if(member_birth_gn[i].checked){
                    value_gn = member_birth_gn[i].nextSibling.textContent.trim();
                    break;
                }
            }
            value = value_y + "," + value_m + "," + value_d + "," + value_gn;
        } else if(attribute=='tel'){
            var value_tel1 = frm_mod_member.tel1.value;
            var value_tel2 = frm_mod_member.tel2.value;
            var value_tel3 = frm_mod_member.tel3.value;
            var smssts_yn = frm_mod_member.smssts_yn.checked ? 'Y' : 'N';
            value = value_tel1 + "," + value_tel2 + "," + value_tel3 + "," + smssts_yn;
        } else if(attribute=='email'){
            var value_email1 = frm_mod_member.email1.value;
            var value_email2 = frm_mod_member.email2.value;
            var emailsts_yn = frm_mod_member.emailsts_yn.checked ? 'Y' : 'N';
            value = value_email1 + "," + value_email2 + "," + emailsts_yn;
        } else if(attribute=='address'){
            var value_zipcode = frm_mod_member.zipcode.value;
            var value_roadAddress = frm_mod_member.roadAddress.value;
            var value_jibunAddress = frm_mod_member.jibunAddress.value;
            var value_namujiAddress = frm_mod_member.namujiAddress.value;
            value = value_zipcode + "," + value_roadAddress + "," + value_jibunAddress + "," + value_namujiAddress;
        }
        // AJAX 호출
        $.ajax({
            type : "post",
            async : false,
            url : "${contextPath}/mypage/modifyMyInfo.do",
            data : {
                attribute: attribute,
                value: value,
            },
            success : function(data, textStatus) {
                if(data.trim()=='mod_success'){
                    alert("회원 정보를 수정했습니다.");
                }else if(data.trim()=='failed'){
                    alert("다시 시도해 주세요.");    
                }
            },
            error : function(data, textStatus) {
                alert("에러가 발생했습니다."+ data);
            }
        });
    }

//     // 회원 탈퇴/복구 기능을 위한 JavaScript 함수
//     function fn_delete_member(member_id, del_yn) {
//         if (confirm("정말 " + (del_yn === 'Y' ? "탈퇴" : "복구") + "하시겠습니까?")) {
//             // AJAX를 사용하여 서버에 회원 탈퇴/복구 요청
//             $.ajax({
//                 type: "post",
//                 url: "${contextPath}/admin/member/deleteMember.do",
//                 data: {
//                     member_id: member_id,
//                     del_yn: del_yn
//                 },
//                 success: function(data, textStatus) {
//                     alert("처리가 완료되었습니다.");
//                     // 성공 시 페이지 새로고침
//                     location.reload();
//                 },
//                 error: function(data, textStatus) {
//                     alert("에러가 발생했습니다. 다시 시도해 주세요.");
//                 }
//             });
//         }
//     }





function fn_delete_member(member_id, del_yn) {
    if (confirm("정말 " + (del_yn === 'Y' ? "탈퇴" : "복구") + "하시겠습니까?")) {
        $.ajax({
            type: "post",
            url: "${contextPath}/admin/member/deleteMember.do",
            data: {
                member_id: member_id,
                del_yn: del_yn
            },
            success: function(data, textStatus) {
                if (data.trim() === 'success') {
                    alert("처리가 완료되었습니다.");
                    // --- 이 부분을 아래와 같이 수정 ---
                    location.reload(true); // true 인자를 추가하여 강제 새로고침
                    // 또는
                    // location.href = window.location.href; // 현재 URL로 다시 이동
                    // 또는
                    // window.location.replace(window.location.href); // 현재 페이지를 히스토리에서 지우고 이동
                    // -----------------------------
                } else {
                    alert("처리 중 오류가 발생했습니다. 다시 시도해 주세요.");
                }
            },
            error: function(data, textStatus) {
                alert("에러가 발생했습니다. 다시 시도해 주세요.");
            }
        });
    }
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
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">비밀번호</td>
					<td>
					  <input name="member_pw" type="password" size="20" value="${member_info.member_pw }" />
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('member_pw')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">이름</td>
					<td>
					  <input name="member_name" type="text" size="20" value="${member_info.member_name }"  disabled />
					 </td>
					 <td>
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">성별</td>
					<td>
					  <c:choose >
					    <c:when test="${member_info.member_gender =='101' }">
					      <input type="radio" name="member_gender" value="102" />
						  여성 <span style="padding-left:30px"></span>
					   <input type="radio" name="member_gender" value="101" checked />남성
					    </c:when>
					    <c:otherwise>
					      <input type="radio" name="member_gender" value="102"  checked />
						   여성 <span style="padding-left:30px"></span>
					      <input type="radio" name="member_gender" value="101"  />남성
					   </c:otherwise>
					   </c:choose>
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('member_gender')" />
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
					</select>일 <span style="padding-left:50px"></span>
					   <c:choose>
					    <c:when test="${member_info.member_birth_gn=='2' }"> 
					  <input type="radio" name="member_birth_gn" value="2" checked />양력
						<span style="padding-left:20px"></span> 
						<input type="radio"  name="member_birth_gn" value="1" />음력
						</c:when>
						<c:otherwise>
						  <input type="radio" name="member_birth_gn" value="2" />양력
						  <input type="radio"  name="member_birth_gn" value="1" checked  />음력
						</c:otherwise>
						</c:choose>
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('member_birth')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">휴대폰번호</td>
					<td>
					   <select  name="tel1" id="tel1">
							<option value="010" selected>010</option>
							<option value="011">011</option>
							<option value="016">016</option>
							<option value="017">017</option>
							<option value="018">018</option>
							<option value="019">019</option>
					</select> 
					 - <input type="text" name="tel2" size=4 value="${member_info.tel2 }"> 
					 - <input type="text"name="tel3"  size=4 value="${member_info.tel3 }"><br> <br>
					 <c:choose> 
					   <c:when test="${member_info.smssts_yn=='true' }">
					     <input type="checkbox"  name="smssts_yn" value="Y" checked /> 쇼핑몰에서 발송하는 SMS 소식을 수신합니다.
						</c:when>
						<c:otherwise>
						  <input type="checkbox"  name="smssts_yn" value="N"  /> 쇼핑몰에서 발송하는 SMS 소식을 수신합니다.
						</c:otherwise>
					 </c:choose>	
				    </td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('tel')" />
					</td>	
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">이메일<br>(e-mail)</td>
					<td>
					   <input type="text" name="email1" size=10 value="${member_info.email1 }" /> @ <input type="text" size=10  name="email2" id="email2_direct" value="${member_info.email2 }" /> 
					   <select name="email2_select" id="email2_select" onChange="changeEmailDomain()"  title="직접입력">
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
					   <c:when test="${member_info.emailsts_yn=='true' }">
					     <input type="checkbox" name="emailsts_yn"  value="Y" checked /> 쇼핑몰에서 발송하는 e-mail을 수신합니다.
						</c:when>
						<c:otherwise>
						  <input type="checkbox" name="emailsts_yn"  value="N"  /> 쇼핑몰에서 발송하는 e-mail을 수신합니다.
						</c:otherwise>
					 </c:choose>
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('email')" />
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
					   </p>
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_member_info('address')" />
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
					<c:when test="${member_info.del_yn eq 'Y' }">
						<input type="button" value="회원복원" onClick="fn_delete_member('${member_info.member_id }','N')">   
					</c:when>
					<c:when test="${member_info.del_yn eq 'N' }">
						<input type="button" value="회원탈퇴" onClick="fn_delete_member('${member_info.member_id }','Y')">
					</c:when>
				</c:choose>
			</td>
		</tr>
	</table>
	</div>
	<input  type="hidden" name="h_tel1" value="${member_info.tel1}" />
</form>	
</body>
</html>