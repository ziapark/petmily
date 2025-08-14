<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

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
	  	if(email2Select.value == "non") {
	    	email2Direct.style.display = "inline";
	    	email2Direct.value = ""; // 직접입력 초기화
	    	email2Direct.focus();
	  	}else {
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

	var isIdChecked = false;
	
	function fn_overlapped(){
    	var _id=$("#seller_id").val();
    	if(_id==''){
   	 		alert("ID를 입력하세요");
   	 		return;
    	}
    	
    	$.ajax({
       		type:"post",
       		async:false,  
       		url:"${contextPath}/business/overlapped.do",
       		dataType:"text",
       		data: {id:_id},
       		success:function (data,textStatus){
          		if(data.trim()=='false'){
	       	    	alert("사용할 수 있는 ID입니다.") ;
	       	    	$('#btnOverlapped').prop("disabled", true);
	       	    	$('#seller_id').prop("readonly", true);
	       	    	$('#seller_id').val(_id);
	       	    	isIdChecked = true;  // 중복검사 통과
          		}else{
        	  		alert("사용할 수 없는 ID입니다.");
          		}
       		},
       		error:function(data,textStatus){
          		alert("에러가 발생했습니다.");
       		}
    	});	 
 	}
	
	$(function() {
	    $("form").on("submit", function(e) {
	        if (!isIdChecked) {
	            alert("아이디 중복체크를 해주세요.");
	            e.preventDefault();
	        }
	    });
	});
</script>
</head>
<body>
	<div class="container text-center mt-3 mb-3">
		<div class="row row-cols-1">
			<h3 class="mt-5 mb-4">회원가입</h3>
			<form action="${contextPath}/business/addSeller.do" method="post">
  				<div class="card p-4">
    				<table class="table table-bordered align-middle">
      					<tbody>
        					<tr>
	          					<th class="bg-light">아이디</th>
	          					<td>
	          						<div class="d-flex align-items-center">
	          							<input type="text" name="seller_id" id="seller_id" class="form-control me-2" required />
	            						<input type="button" class="btn btn-secondary"  id="btnOverlapped" value="중복체크" onclick="fn_overlapped()" />
	          						</div>
	          					</td>
        					</tr>
        					<tr>
         	 					<th class="bg-light">비밀번호</th>
          						<td><input class="form-control" name="seller_pw" type="password" id="seller_pw" required /></td>
        					</tr>
        					<tr>
          						<th class="bg-light">상호명</th>
          						<td><input class="form-control" name="business_name" type="text" required /></td>
        					</tr>
        					<tr>
  								<th class="bg-light">업종</th>
							    <td>
							    	<label><input type="checkbox" name="business_type[]" value="숙박업소" /> 숙박업소</label>
							    	<label><input type="checkbox" name="business_type[]" value="물건판매" /> 물건판매</label>
							    </td>
							</tr>
        					<tr>
          						<th class="bg-light">대표자명</th>
          						<td><input name="owner_name" type="text" class="form-control" required /></td>
        					</tr>
        					<tr>
          						<th class="bg-light">사업자번호</th>
          						<td><input name="business_number" type="text" class="form-control" required /></td>
        					</tr>
        					<tr>
          						<th class="bg-light">대표 전화번호</th>
          						<td>
          							<div class="d-flex align-items-center">
	          							<select name="phone1" class="form-select w-auto me-1">
	          								<option value="없음">없음</option>
											<option value="010" selected>010</option>
											<option value="011">011</option>
											<option value="016">016</option>
											<option value="017">017</option>
											<option value="018">018</option>
											<option value="019">019</option>
										</select> - <input type="text" name="phone2" class="form-control w-auto mx-1" required /> - <input
											type="text" name="phone3" class="form-control w-auto ms-1" required />
									</div>
          						</td>
        					</tr>
        					<tr>
          						<th class="bg-light">이메일</th>
   								<td>
	   								<div class="d-flex align-items-center mb-2">
										<input type="text" name="email1" id="email1" class="form-control w-auto me-1" required /> <span>@</span>
										<input type="text" name="email2" id="email2_direct"	class="form-control w-auto mx-1" required /> <select
											name="email2_select" id="email2_select" class="form-select w-auto" onchange="changeEmailDomain()">
											<option value="non">직접입력</option>
											<option value="hanmail.net">hanmail.net</option>
											<option value="naver.com">naver.com</option>
											<option value="gmail.com">gmail.com</option>
											<option value="korea.com">korea.com</option>
											<!-- 필요하면 더 추가 -->
										</select>
									</div>
								</td>
        					</tr>
        					<tr>
          						<th class="bg-light">사업장 주소</th>
								<td>
									<div class="mb-2 d-flex">
										<input type="text" name="zipcode" id="zipcode"
											class="form-control me-2" size="10" readonly /> <a
											href="javascript:execDaumPostcode()"
											class="btn btn-secondary">우편번호 검색</a>
									</div>
									<input type="text" name="roadAddress" id="roadAddress" class="form-control mb-2" placeholder="도로명 주소" readonly />
									<input type="text" name="jibunAddress" id="jibunAddress" class="form-control mb-2" placeholder="지번 주소" readonly />
									<input type="text" name="namujiAddress" class="form-control" placeholder="상세 주소" /> <span id="guide" class="text-muted"></span>
								</td>
        					</tr>
        					<tr>
          						<th class="bg-light">업체 설명</th>
          						<td><textarea name="description" class="form-control" rows="2" cols="45"></textarea></td>
        					</tr>
        					<tr>
          						<th class="bg-light">정산 은행</th>
          						<td><input name="bank_name" type="text" class="form-control"/></td>
        					</tr>
        					<tr>
          						<th class="bg-light">정산 계좌번호</th>
          						<td><input name="bank_account" type="text" class="form-control" /></td>
        					</tr>
        					<tr>
          						<th class="bg-light">예금주</th>
          						<td><input name="bank_holder" type="text" class="form-control" /></td>
        					</tr>
      					</tbody>
    				</table>
    				<div class="text-center mt-4">
					<div class="text-center mt-4">
						<button type="submit" class="btn btn-primary">회원 가입</button>
						<button type="reset" class="btn btn-outline-secondary ms-2">다시입력</button>
					</div>
  				</div>
  			</div>
			</form>
		</div>
	</div>
</body>
</html>