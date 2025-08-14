<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />

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

    	function execDaumPostcode() {
        	new daum.Postcode({
            	oncomplete: function(data) {
                	var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
                	var extraRoadAddr = ''; // 도로명 조합형 주소 변수
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
                	document.getElementById('zipcode').value = data.zonecode; //5자리 새우편번호 사용
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
   
   		window.onload=function(){
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

		function fn_sendAuthCode() {
	    	const email1 = $("#email1").val();
	    	let email2;
	    	const email2Select = $("#email2_select").val();

	    	if(email2Select === "non") {
	    	    email2 = $("#email2_direct").val();
	    	} else {
	     	    email2 = email2Select;
	    	}	

		    if(!email1 || !email2){
		        alert("이메일 주소를 입력해주세요.");
		        return;
		    }
		
			$.ajax({
				type:"POST",
				url:"${contextPath}/member/sendAuthCode.do",
				data:{"email1":email1, "email2":email2},
				success:function(data){
					if(data !== 'true'){
						alert("입력하신 이메일로 인증번호가 발송되었습니다.");
						$("#authCodeInput").prop("disabled", false);
						$("#mailCheckResult").text("인증번호가 발송되었습니다.").css("color", "green");
						serverAuthCode = data;
						isEmailVerified = false;
					}else{
						alert("이미 가입된 이메일입니다. 로그인 페이지로 이동합니다.");
						window.location.href = "${contextPath}/member/loginForm.do";
						return ;
					}
				},
				error : function(){
					alert("메일 발송에 실패했습니다. 이메일 주소를 확인해주세요.");
				}
			});
		}
		
		let isEmailVerified = true;
		let serverAuthCode = null;

		$("#verifyAuthCodeBtn").click(function() {
		    const enteredCode = $("#authCodeInput").val();
		    if (!enteredCode) {
		        alert("인증번호를 입력해주세요.");
		        return;
		    }

		    if (enteredCode === serverAuthCode) {
		        $("#mailCheckResult").text("이메일 인증이 완료되었습니다!").css("color", "blue");
		        isEmailVerified = true;
		    } else {
		        $("#mailCheckResult").text("인증번호가 일치하지 않습니다.").css("color", "red");
		        isEmailVerified = false;
		    }
		});
		
		$("form").on("submit", function(e) {
		    const originalEmail1 = $("#original_email1").val();
		    const originalEmail2 = $("#original_email2").val();
		    const currentEmail1 = $("#email1").val();
		    let currentEmail2 = $("#email2_select").val();
		    if (currentEmail2 === "non") {
		        currentEmail2 = $("#email2_direct").val();
		    }

		    // 이메일이 변경되었는데 인증이 안 된 경우
		    if ((originalEmail1 !== currentEmail1 || originalEmail2 !== currentEmail2) && !isEmailVerified) {
		        alert("이메일이 변경되었습니다. 이메일 인증을 완료해주세요.");
		        e.preventDefault();
		    }
		});
</script>
</head>
<body>
	<div class="container text-center mt-3 mb-3">
		<div class="row row-cols-1">
			<h3 class="mt-5 mb-4">내 정보</h3>
			<form action="${contextPath}/mypage/updateMember.do" method="post">
				<div class="card p-4">
					<table class="table table-bordered align-middle">
						<tbody>
							<tr>
								<th class="bg-light">아이디</th>
								<td>
									<input name="member_id" type="text" class="form-control" value="${memberInfo.member_id}" readonly />
								</td>
							</tr>
							<tr>
								<th class="bg-light">비밀번호</th>
								<td><input name="member_pw" type="password" class="form-control" value="${memberInfo.member_pw}" required/></td>
							</tr>
							<tr>
								<th class="bg-light">이름</th>
								<td><input name="member_name" type="text" class="form-control" value="${memberInfo.member_name}" readonly /></td>
							</tr>
							<tr>
								<th class="bg-light">성별</th>
								<td>
									<div class="form-check form-check-inline">
										<input type="radio" class="form-check-input" name="member_gender" id="genderFemale" value="여성" <c:if test="${memberInfo.member_gender != '남성'}">checked</c:if> />
										<label class="form-check-label" for="genderFemale">여성</label>
									</div>
									<div class="form-check form-check-inline">
										<input type="radio" class="form-check-input" name="member_gender" id="genderMale" value="남성" <c:if test="${memberInfo.member_gender == '남성'}">checked</c:if> />
										<label class="form-check-label" for="genderMale">남성</label>
									</div>
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
												<input type="radio" class="form-check-input" name="member_birth_gn" id="solar" value="양력" <c:if test="${memberInfo.member_birth_gn=='양력'}">checked</c:if> />
												<label class="form-check-label" for="solar">양력</label>
											</div>
											<div class="form-check form-check-inline">
												<input type="radio" class="form-check-input" name="member_birth_gn" id="lunar" value="음력" <c:if test="${memberInfo.member_birth_gn=='음력'}">checked</c:if> />
												<label class="form-check-label" for="lunar">음력</label>
											</div>
										</div>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bg-light">휴대폰번호</th>
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
										<input type="text" name="tel2" class="form-control w-auto mx-1" value="${memberInfo.tel2}" required /> -
										<input type="text" name="tel3" class="form-control w-auto" value="${memberInfo.tel3}" required />
									</div>
									<div class="form-check mt-2">
										<input type="checkbox" class="form-check-input" name="smssts_yn" id="smssts_yn" value="Y" <c:if test="${memberInfo.smssts_yn=='Y'}">checked</c:if> />
										<label class="form-check-label" for="smssts_yn">SMS 수신 동의</label>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bg-light">이메일</th>
								<td>
									<div class="d-flex align-items-center">
										<input type="hidden" id="original_email1" value="${memberInfo.email1}" />
										<input type="hidden" id="original_email2" value="${memberInfo.email2}" />
										<input type="text" name="email1" id="email1" class="form-control w-auto me-1" value="${memberInfo.email1}" required /> @
										<input type="text" name="email2" id="email2_direct" class="form-control w-auto mx-1" value="${memberInfo.email2}" required/>
										<select name="email2" id="email2_select" class="form-select w-auto" onchange="changeEmailDomain()">
											<option value="non">직접입력</option>
											<option value="naver.com">naver.com</option>
											<option value="gmail.com">gmail.com</option>
										<!-- 필요한 도메인 추가 -->
										</select>
										<button type="button" class="btn btn-secondary" id="sendAuthCodeBtn" onclick="fn_sendAuthCode()">인증번호 발송</button>
									</div>
									<div class="form-group">
	                            		<div style="display: flex; align-items: center; margin-top: 5px;">
	                                		<input type="text" id="authCodeInput" class="form-control" placeholder="인증번호를 입력하세요" disabled>
	                                		<button type="button" id="verifyAuthCodeBtn" class="btn btn-primary" style="margin-left: 10px; white-space: nowrap;">인증번호 확인</button>
	                            		</div>
                            			<p id="mailCheckResult" style="margin-top: 5px;"></p>
                        			</div>
									<div class="form-check">
										<input type="checkbox" class="form-check-input" name="emailsts_yn" id="emailsts_yn" value="Y" <c:if test="${memberInfo.emailsts_yn=='Y'}">checked</c:if> />
										<label class="form-check-label" for="emailsts_yn">이메일 수신 동의</label>
									</div>
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
							</tr>
						</tbody>
					</table>

					<div class="text-center mt-4">
						<button type="submit" class="btn btn-primary">수정하기</button>
						<a href="${contextPath}/mypage/myPageMain.do" class="btn btn-outline-secondary ms-2">뒤로가기</a>
					</div>
				</div>
			</form>
		</div>
	</div>
</body>
</html>
