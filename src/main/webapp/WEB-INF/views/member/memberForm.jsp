<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html >
<html>
<head>
<meta charset="utf-8">
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
	function changeEmailDomain() {
		var email2Select = document.getElementById("email2_select");
		var email2Direct = document.getElementById("email2_direct");
		if (email2Select.value == "non") {
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
		if (email2Select.value == "non") {
			email2 = document.getElementById("email2_direct").value;
		} else {
			email2 = email2Select.value;
		}
		document.getElementById("member_email").value = email1 + "@" + email2;
		return true;
	}

	function execDaumPostcode() {
		new daum.Postcode(
				{
					oncomplete : function(data) {
						// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

						// 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
						// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
						var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
						var extraRoadAddr = ''; // 도로명 조합형 주소 변수

						// 법정동명이 있을 경우 추가한다. (법정리는 제외)
						// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
						if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
							extraRoadAddr += data.bname;
						}
						// 건물명이 있고, 공동주택일 경우 추가한다.
						if (data.buildingName !== '' && data.apartment === 'Y') {
							extraRoadAddr += (extraRoadAddr !== '' ? ', '
									+ data.buildingName : data.buildingName);
						}
						// 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
						if (extraRoadAddr !== '') {
							extraRoadAddr = ' (' + extraRoadAddr + ')';
						}
						// 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
						if (fullRoadAddr !== '') {
							fullRoadAddr += extraRoadAddr;
						}

						// 우편번호와 주소 정보를 해당 필드에 넣는다.
						document.getElementById('zipcode').value = data.zonecode; //5자리 새우편번호 사용
						document.getElementById('roadAddress').value = fullRoadAddr;
						document.getElementById('jibunAddress').value = data.jibunAddress;

						// 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
						if (data.autoRoadAddress) {
							//예상되는 도로명 주소에 조합형 주소를 추가한다.
							var expRoadAddr = data.autoRoadAddress
									+ extraRoadAddr;
							document.getElementById('guide').innerHTML = '(예상 도로명 주소 : '
									+ expRoadAddr + ')';

						} else if (data.autoJibunAddress) {
							var expJibunAddr = data.autoJibunAddress;
							document.getElementById('guide').innerHTML = '(예상 지번 주소 : '
									+ expJibunAddr + ')';
						} else {
							document.getElementById('guide').innerHTML = '';
						}

					}
				}).open();
	}

	function fn_overlapped() {
		var _id = $("#member_id").val();
		if (_id == '') {
			alert("ID를 입력하세요");
			return;
		}
		$.ajax({
			type : "post",
			async : false,
			url : "${contextPath}/member/overlapped.do",
			dataType : "text",
			data : {
				id : _id
			},
			success : function(data, textStatus) {
				if (data.trim() == 'false') {
					alert("사용할 수 있는 ID입니다.");
					$('#btnOverlapped').prop("disabled", true);
					$('#member_id').prop("readonly", true);
					$('#member_id').val(_id);
				} else {
					alert("사용할 수 없는 ID입니다.");
				}
			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다.");
			},
			complete : function(data, textStatus) {
				//alert("작업을완료 했습니다");
			}
		}); //end ajax	 
	}
</script>
</head>
<body>
	<div class="container text-center mt-3 mb-3">
		<div class="row row-cols-1 mb-3">
			<div class="col bg-light p-5 text-start">
				<h2 class="fw-bold h2h2">회원가입</h2>
				<p class="h2p"></p>
			</div>
		</div>
		<div class="row row-cols-1">
			<h3 class="mt-5 mb-4">필수입력사항</h3>
			<form action="${contextPath}/member/addMember.do" method="post"
				onsubmit="return setEmail();">
				<div class="card p-4">
					<table class="table table-bordered align-middle">
						<tbody>
							<tr>
								<th class="bg-light">아이디</th>
								<td>
									<div class="d-flex align-items-center">
										<input type="text" name="member_id" id="member_id"
											class="form-control me-2" required />
										<button type="button" class="btn btn-secondary"
											id="btnOverlapped" onclick="fn_overlapped()">중복체크</button>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bg-light">비밀번호</th>
								<td><input type="password" name="member_pw"
									class="form-control" required /></td>
							</tr>
							<tr>
								<th class="bg-light">이름</th>
								<td><input type="text" name="member_name"
									class="form-control" required /></td>
							</tr>
							<tr>
								<th class="bg-light">성별</th>
								<td>
									<div class="form-check form-check-inline">
										<input class="form-check-input" type="radio"
											name="member_gender" value="102" id="female" /> <label
											class="form-check-label" for="female">여성</label>
									</div>
									<div class="form-check form-check-inline ms-4">
										<input class="form-check-input" type="radio"
											name="member_gender" value="101" id="male" checked /> <label
											class="form-check-label" for="male">남성</label>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bg-light">생년월일</th>
								<td>
									<div class="d-flex flex-wrap align-items-center">
										<select name="member_birth_y" class="form-select w-auto me-1">
											<c:forEach var="year" begin="1" end="100">
												<option value="${1920+year}"
													<c:if test="${year==80}">selected</c:if>>${1920+year}</option>
											</c:forEach>
										</select>년 <select name="member_birth_m"
											class="form-select w-auto mx-1">
											<c:forEach var="month" begin="1" end="12">
												<option value="${month}"
													<c:if test="${month==5}">selected</c:if>>${month}</option>
											</c:forEach>
										</select>월 <select name="member_birth_d"
											class="form-select w-auto mx-1">
											<c:forEach var="day" begin="1" end="31">
												<option value="${day}"
													<c:if test="${day==10}">selected</c:if>>${day}</option>
											</c:forEach>
										</select>일

										<div class="form-check form-check-inline ms-3">
											<input type="radio" class="form-check-input"
												name="member_birth_gn" value="2" id="solar" checked /> <label
												class="form-check-label" for="solar">양력</label>
										</div>
										<div class="form-check form-check-inline">
											<input type="radio" class="form-check-input"
												name="member_birth_gn" value="1" id="lunar" /> <label
												class="form-check-label" for="lunar">음력</label>
										</div>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bg-light">휴대폰번호</th>
								<td>
									<div class="d-flex align-items-center">
										<select name="tel1" class="form-select w-auto me-1">
											<option value="없음">없음</option>
											<option value="010" selected>010</option>
											<option value="011">011</option>
											<option value="016">016</option>
											<option value="017">017</option>
											<option value="018">018</option>
											<option value="019">019</option>
										</select> - <input type="text" name="tel2"
											class="form-control w-auto mx-1" required /> - <input
											type="text" name="tel3" class="form-control w-auto ms-1"
											required />
									</div>
									<div class="form-check mt-2">
										<input type="checkbox" name="smssts_yn"
											class="form-check-input" value="Y" id="smsCheck" checked />
										<label class="form-check-label" for="smsCheck">SMS 수신
											동의</label>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bg-light">이메일</th>
								<td>
									<div class="d-flex align-items-center mb-2">
										<input type="text" name="email1"
											class="form-control w-auto me-1" required /> <span>@</span>
										<input type="text" name="email2" id="email2_direct"
											class="form-control w-auto mx-1" required /> <select
											name="email2_select" id="email2_select"
											class="form-select w-auto" onchange="changeEmailDomain()">
											<option value="non">직접입력</option>
											<option value="hanmail.net">hanmail.net</option>
											<option value="naver.com">naver.com</option>
											<option value="gmail.com">gmail.com</option>
											<option value="korea.com">korea.com</option>
											<!-- 필요하면 더 추가 -->
										</select>
									</div> <input type="hidden" name="member_email" id="member_email" />
									<div class="form-check">
										<input type="checkbox" name="emailsts_yn"
											class="form-check-input" value="Y" id="emailCheck" checked />
										<label class="form-check-label" for="emailCheck">이메일
											수신 동의</label>
									</div>
								</td>
							</tr>
							<tr>
								<th class="bg-light">주소</th>
								<td>
									<div class="mb-2 d-flex">
										<input type="text" name="zipcode" id="zipcode"
											class="form-control me-2" size="10" readonly /> <a
											href="javascript:execDaumPostcode()"
											class="btn btn-secondary">우편번호 검색</a>
									</div> <input type="text" name="roadAddress" id="roadAddress"
									class="form-control mb-2" placeholder="도로명 주소" readonly /> <input
									type="text" name="jibunAddress" id="jibunAddress"
									class="form-control mb-2" placeholder="지번 주소" readonly /> <input
									type="text" name="namujiAddress" class="form-control"
									placeholder="상세 주소" /> <span id="guide" class="text-muted"></span>
								</td>
							</tr>
						</tbody>
					</table>

					<div class="text-center mt-4">
						<button type="submit" class="btn btn-primary">회원 가입</button>
						<button type="reset" class="btn btn-outline-secondary ms-2">다시입력</button>
					</div>
				</div>
			</form>
		</div>
		</div>
</body>
</html>