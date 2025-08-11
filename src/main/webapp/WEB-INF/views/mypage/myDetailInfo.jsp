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
    
     var tel1='${memberInfo.tel1 }';
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
                    value_gn = member_birth_gn[i].value;
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

</script>
</head>

<body>
<div class="container my-5">
	<h3 class="mb-4">내 상세 정보</h3>
	<div class="card">
		<div class="card-body">
			<form name="frm_mod_member">
				<table class="table table-bordered">
					<tbody>
						<tr>
							<th class="bg-light align-middle">아이디</th>
							<td>
								<input name="member_id" type="text" class="form-control" value="${memberInfo.member_id}" disabled />
							</td>
							<td></td>
						</tr>
						<tr>
							<th class="bg-light align-middle">비밀번호</th>
							<td>
								<input name="member_pw" type="password" class="form-control" value="${memberInfo.member_pw}" />
							</td>
							<td>
								<input type="button" class="btn btn-primary" value="수정하기" onclick="fn_modify_member_info('member_pw')" />
							</td>
						</tr>
						<tr>
							<th class="bg-light align-middle">이름</th>
							<td>
								<input name="member_name" type="text" class="form-control" value="${memberInfo.member_name}" disabled />
							</td>
							<td></td>
						</tr>
						<tr>
							<th class="bg-light align-middle">성별</th>
							<td>
								<div class="form-check form-check-inline">
									<input type="radio" class="form-check-input" name="member_gender" id="genderFemale" value="여" <c:if test="${memberInfo.member_gender != '101'}">checked</c:if> />
									<label class="form-check-label" for="genderFemale">여성</label>
								</div>
								<div class="form-check form-check-inline">
									<input type="radio" class="form-check-input" name="member_gender" id="genderMale" value="남" <c:if test="${memberInfo.member_gender == '101'}">checked</c:if> />
									<label class="form-check-label" for="genderMale">남성</label>
								</div>
							</td>
							<td>
								<input type="button" class="btn btn-primary" value="수정하기" onclick="fn_modify_member_info('member_gender')" />
							</td>
						</tr>
						<tr>
							<th class="bg-light align-middle">생년월일</th>
							<td>
								<div class="d-flex align-items-center flex-wrap">
									<select name="member_birth_y" class="form-select w-auto me-1">
										<c:forEach var="i" begin="1" end="100">
											<option value="${1920+i}" <c:if test="${memberInfo.member_birth_y==1920+i}">selected</c:if>>${1920+i}</option>
										</c:forEach>
									</select>년
									<select name="member_birth_m" class="form-select w-auto me-1">
										<c:forEach var="i" begin="1" end="12">
											<option value="${i}" <c:if test="${memberInfo.member_birth_m==i}">selected</c:if>>${i}</option>
										</c:forEach>
									</select>월
									<select name="member_birth_d" class="form-select w-auto me-1">
										<c:forEach var="i" begin="1" end="31">
											<option value="${i}" <c:if test="${memberInfo.member_birth_d==i}">selected</c:if>>${i}</option>
										</c:forEach>
									</select>일
									<div class="ms-3">
										<div class="form-check form-check-inline">
											<input type="radio" class="form-check-input" name="member_birth_gn" id="solar" value="양력" <c:if test="${memberInfo.member_birth_gn=='2'}">checked</c:if> />
											<label class="form-check-label" for="solar">양력</label>
										</div>
										<div class="form-check form-check-inline">
											<input type="radio" class="form-check-input" name="member_birth_gn" id="lunar" value="음력" <c:if test="${memberInfo.member_birth_gn=='1'}">checked</c:if> />
											<label class="form-check-label" for="lunar">음력</label>
										</div>
									</div>
								</div>
							</td>
							<td>
								<input type="button" class="btn btn-primary" value="수정하기" onclick="fn_modify_member_info('member_birth')" />
							</td>
						</tr>
						<tr>
							<th class="bg-light align-middle">휴대폰번호</th>
							<td>
								<div class="d-flex align-items-center">
									<select name="tel1" class="form-select w-auto me-1">
										<option value="010">010</option>
										<option value="011">011</option>
										<option value="016">016</option>
										<option value="017">017</option>
										<option value="018">018</option>
										<option value="019">019</option>
									</select> -
									<input type="text" name="tel2" class="form-control w-auto mx-1" value="${memberInfo.tel2}" /> -
									<input type="text" name="tel3" class="form-control w-auto" value="${memberInfo.tel3}" />
								</div>
								<div class="form-check mt-2">
									<input type="checkbox" class="form-check-input" name="smssts_yn" id="smssts_yn" value="Y" <c:if test="${memberInfo.smssts_yn=='true'}">checked</c:if> />
									<label class="form-check-label" for="smssts_yn">SMS 수신 동의</label>
								</div>
							</td>
							<td>
								<input type="button" class="btn btn-primary" value="수정하기" onclick="fn_modify_member_info('tel')" />
							</td>
						</tr>
						<tr>
							<th class="bg-light align-middle">이메일</th>
							<td>
								<div class="d-flex align-items-center">
									<input type="text" name="email1" class="form-control w-auto me-1" value="${memberInfo.email1}" /> @
									<input type="text" name="email2" id="email2_direct" class="form-control w-auto mx-1" value="${memberInfo.email2}" />
									<select name="email2_select" id="email2_select" class="form-select w-auto" onchange="changeEmailDomain()">
										<option value="non">직접입력</option>
										<option value="naver.com">naver.com</option>
										<option value="gmail.com">gmail.com</option>
										<!-- 필요한 도메인 추가 -->
									</select>
								</div>
								<div class="form-check mt-2">
									<input type="checkbox" class="form-check-input" name="emailsts_yn" id="emailsts_yn" value="Y" <c:if test="${memberInfo.emailsts_yn=='true'}">checked</c:if> />
									<label class="form-check-label" for="emailsts_yn">이메일 수신 동의</label>
								</div>
							</td>
							<td>
								<input type="button" class="btn btn-primary" value="수정하기" onclick="fn_modify_member_info('email')" />
							</td>
						</tr>
						<tr>
							<th class="bg-light align-middle">주소</th>
							<td>
								<div class="mb-2 d-flex">
									<input type="text" name="zipcode" id="zipcode" class="form-control me-2" value="${memberInfo.zipcode}" readonly />
									<a href="javascript:execDaumPostcode()" class="btn btn-secondary">우편번호 검색</a>
								</div>
								<input type="text" name="roadAddress" class="form-control mb-2" value="${memberInfo.roadAddress}" readonly placeholder="도로명 주소" />
								<input type="text" name="jibunAddress" class="form-control mb-2" value="${memberInfo.jibunAddress}" readonly placeholder="지번 주소" />
								<input type="text" name="namujiAddress" class="form-control" value="${memberInfo.namujiAddress}" placeholder="상세 주소" />
							</td>
							<td>
								<input type="button" class="btn btn-primary" value="수정하기" onclick="fn_modify_member_info('address')" />
							</td>
						</tr>
					</tbody>
				</table>

				<div class="text-center mt-4">
					<input type="hidden" name="command" value="modify_my_info" />
					<input type="hidden" name="h_tel1" value="${memberInfo.tel1}" />
				</div>
			</form>
		</div>
	</div>
</div>

</body>
</html>
