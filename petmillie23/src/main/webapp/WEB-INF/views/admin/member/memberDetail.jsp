<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html >
<html>
<head>
<meta charset="utf-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
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
                var fullRoadAddr = data.roadAddress;
                var extraRoadAddr = '';

                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraRoadAddr += data.bname;
                }
                if(data.buildingName !== '' && data.apartment === 'Y'){
                   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                if(extraRoadAddr !== ''){
                    fullRoadAddr += ' (' + extraRoadAddr + ')';
                }

                document.getElementById('zipcode').value = data.zonecode;
                document.getElementById('roadAddress').value = fullRoadAddr;
                document.getElementById('jibunAddress').value = data.jibunAddress;
                document.getElementById('guide').innerHTML = '';
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
                    value_gn = member_birth_gn[i].value; // 수정: nextSibling.textContent 대신 value 사용
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
                    location.reload(true);
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
<div class="container my-5">
	<h3 class="mb-4">회원의 상세 정보</h3>
	<div class="card">
		<div class="card-body">
			<form name="frm_mod_member">	
				<table class="table table-bordered">
					<tbody>
						<tr>
							<th class="align-middle bg-light">아이디</th>
							<td>
								<input name="member_id" type="text" class="form-control" value="${member_info.member_id }" disabled/>
							</td>
							<td>
								</td>
						</tr>
						<tr>
							<th class="align-middle bg-light">비밀번호</th>
							<td>
							  <input name="member_pw" type="password" class="form-control" value="${member_info.member_pw }" />
							</td>
							<td>
							  <input type="button" class="btn btn-primary" value="수정하기" onClick="fn_modify_member_info('member_pw')" />
							</td>
						</tr>
						<tr>
							<th class="align-middle bg-light">이름</th>
							<td>
							  <input name="member_name" type="text" class="form-control" value="${member_info.member_name }" disabled />
							</td>
							<td>
							</td>
						</tr>
						<tr>
							<th class="align-middle bg-light">성별</th>
							<td>
							  <c:choose >
							    <c:when test="${member_info.member_gender =='101' }">
							      <div class="form-check form-check-inline">
							      	<input type="radio" class="form-check-input" name="member_gender" id="genderFemale" value="102" />
							      	<label class="form-check-label" for="genderFemale">여성</label>
							      </div>
							      <div class="form-check form-check-inline">
							   		<input type="radio" class="form-check-input" name="member_gender" id="genderMale" value="101" checked />
							   		<label class="form-check-label" for="genderMale">남성</label>
							      </div>
							    </c:when>
							    <c:otherwise>
							      <div class="form-check form-check-inline">
							      	<input type="radio" class="form-check-input" name="member_gender" id="genderFemale" value="102" checked />
							      	<label class="form-check-label" for="genderFemale">여성</label>
							      </div>
							      <div class="form-check form-check-inline">
							      	<input type="radio" class="form-check-input" name="member_gender" id="genderMale" value="101" />
							      	<label class="form-check-label" for="genderMale">남성</label>
							      </div>
							   </c:otherwise>
							   </c:choose>
							</td>
							<td>
							  <input type="button" class="btn btn-primary" value="수정하기" onClick="fn_modify_member_info('member_gender')" />
							</td>
						</tr>
						<tr>
							<th class="align-middle bg-light">법정생년월일</th>
							<td>
							   <div class="d-flex align-items-center flex-wrap">
								   <select name="member_birth_y" class="form-select d-inline-block w-auto me-1">
								     <c:forEach var="i" begin="1" end="100">
								       <option value="${1920+i}" <c:if test="${member_info.member_birth_y==1920+i}">selected</c:if>>${1920+i} </option>
								   	</c:forEach>
								   </select>년 
								   <select name="member_birth_m" class="form-select d-inline-block w-auto me-1">
									   <c:forEach var="i" begin="1" end="12">
								       <option value="${i}" <c:if test="${member_info.member_birth_m==i}">selected</c:if>>${i}</option>
								   	</c:forEach>
								   </select>월 
								
								   <select name="member_birth_d" class="form-select d-inline-block w-auto me-1">
										<c:forEach var="i" begin="1" end="31">
								       <option value="${i}" <c:if test="${member_info.member_birth_d==i}">selected</c:if>>${i}</option>
								   	</c:forEach>
								   </select>일
								
								   <div class="d-flex align-items-center ms-3">
									<c:choose>
								    	<c:when test="${member_info.member_birth_gn=='2' }">
											<div class="form-check form-check-inline">
												<input type="radio" class="form-check-input" name="member_birth_gn" id="solar" value="2" checked />
												<label class="form-check-label" for="solar">양력</label>
											</div>
											<div class="form-check form-check-inline">
												<input type="radio" class="form-check-input" name="member_birth_gn" id="lunar" value="1" />
												<label class="form-check-label" for="lunar">음력</label>
											</div>
										</c:when>
										<c:otherwise>
											<div class="form-check form-check-inline">
												<input type="radio" class="form-check-input" name="member_birth_gn" id="solar" value="2" />
												<label class="form-check-label" for="solar">양력</label>
											</div>
											<div class="form-check form-check-inline">
												<input type="radio" class="form-check-input" name="member_birth_gn" id="lunar" value="1" checked />
												<label class="form-check-label" for="lunar">음력</label>
											</div>
										</c:otherwise>
									</c:choose>
								   </div>
							   </div>
							</td>
							<td>
							  <input type="button" class="btn btn-primary" value="수정하기" onClick="fn_modify_member_info('member_birth')" />
							</td>
						</tr>
						<tr>
							<th class="align-middle bg-light">휴대폰번호</th>
							<td>
							   <div class="d-flex align-items-center">
								   <select  name="tel1" id="tel1" class="form-select w-auto me-1">
										<option value="010" selected>010</option>
										<option value="011">011</option>
										<option value="016">016</option>
										<option value="017">017</option>
										<option value="018">018</option>
										<option value="019">019</option>
								   </select>
								   - <input type="text" name="tel2" class="form-control mx-1 w-auto" value="${member_info.tel2 }"> 
								   - <input type="text"name="tel3" class="form-control mx-1 w-auto" value="${member_info.tel3 }">
							   </div>
							   <div class="form-check mt-2">
								 <c:choose> 
								   <c:when test="${member_info.smssts_yn=='true' }">
								     <input type="checkbox" class="form-check-input" name="smssts_yn" id="smssts_yn" value="Y" checked />
								     <label class="form-check-label" for="smssts_yn">쇼핑몰에서 발송하는 SMS 소식을 수신합니다.</label>
									</c:when>
									<c:otherwise>
									  <input type="checkbox" class="form-check-input" name="smssts_yn" id="smssts_yn" value="N"  />
									  <label class="form-check-label" for="smssts_yn">쇼핑몰에서 발송하는 SMS 소식을 수신합니다.</label>
									</c:otherwise>
								 </c:choose>	
							   </div>
						    </td>
							<td>
							  <input type="button" class="btn btn-primary" value="수정하기" onClick="fn_modify_member_info('tel')" />
							</td>	
						</tr>
						<tr>
							<th class="align-middle bg-light">이메일<br>(e-mail)</th>
							<td>
								<div class="d-flex align-items-center">
								   <input type="text" name="email1" class="form-control w-auto" value="${member_info.email1 }" />
								   <span class="mx-1">@</span>
								   <input type="text" name="email2" id="email2_direct" class="form-control w-auto me-1" value="${member_info.email2 }" />
								   <select name="email2_select" id="email2_select" onChange="changeEmailDomain()" class="form-select w-auto" title="직접입력">
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
								   </select>
								</div>
								<div class="form-check mt-2">
								<c:choose> 
								   <c:when test="${member_info.emailsts_yn=='true' }">
								     <input type="checkbox" class="form-check-input" name="emailsts_yn" id="emailsts_yn" value="Y" checked />
								     <label class="form-check-label" for="emailsts_yn">쇼핑몰에서 발송하는 e-mail을 수신합니다.</label>
									</c:when>
									<c:otherwise>
									  <input type="checkbox" class="form-check-input" name="emailsts_yn" id="emailsts_yn" value="N"  />
									  <label class="form-check-label" for="emailsts_yn">쇼핑몰에서 발송하는 e-mail을 수신합니다.</label>
									</c:otherwise>
								 </c:choose>
								</div>
							</td>
							<td>
							  <input type="button" class="btn btn-primary" value="수정하기" onClick="fn_modify_member_info('email')" />
							</td>
						</tr>
						<tr>
							<th class="align-middle bg-light">주소</th>
							<td>
							   <div class="d-flex align-items-center mb-2">
							   		<input type="text" id="zipcode" name="zipcode" class="form-control me-2" value="${member_info.zipcode }" readonly>
							   		<a href="javascript:execDaumPostcode()" class="btn btn-secondary">우편번호검색</a>
							   </div>
							  	<div class="mb-2">
								  <label for="roadAddress" class="form-label">도로명 주소:</label>
								  <input type="text" id="roadAddress"  name="roadAddress" class="form-control" value="${member_info.roadAddress }" readonly>
								</div>
								<div class="mb-2">
								  <label for="jibunAddress" class="form-label">지번 주소:</label>
								  <input type="text" id="jibunAddress" name="jibunAddress" class="form-control" value="${member_info.jibunAddress }" readonly>
								</div>
								<div>
								  <label for="namujiAddress" class="form-label">나머지 주소:</label>
								  <input type="text"  name="namujiAddress" id="namujiAddress" class="form-control" value="${member_info.namujiAddress }" />
								</div>
							</td>
							<td>
							  <input type="button" class="btn btn-primary" value="수정하기" onClick="fn_modify_member_info('address')" />
							</td>
						</tr>
					</tbody>
				</table>
				
				<div class="text-center mt-4">
					<input  type="hidden" name="command"  value="modify_my_info" /> 
					<c:choose>
						<c:when test="${member_info.del_yn eq 'Y' }">
							<input type="button" class="btn btn-success" value="회원복원" onClick="fn_delete_member('${member_info.member_id }','N')">
						</c:when>
						<c:when test="${member_info.del_yn eq 'N' }">
							<input type="button" class="btn btn-danger" value="회원탈퇴" onClick="fn_delete_member('${member_info.member_id }','Y')">
						</c:when>
					</c:choose>
				</div>
				<input  type="hidden" name="h_tel1" value="${member_info.tel1}" />
			</form>	
		</div>
	</div>
</div>
</body>
</html>