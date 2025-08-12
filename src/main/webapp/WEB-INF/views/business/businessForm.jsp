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
	<h3>필수입력사항</h3>
	<form action="${contextPath}/business/addSeller.do" method="post">
  		<div id="detail_table">
    		<table>
      			<tbody>
        			<tr class="dot_line">
	          			<td class="fixed_join">판매자아이디</td>
	          			<td>
	            			<input type="text" name="seller_id" id="seller_id" size="20" required />
	            			<input type="button" id="btnOverlapped" value="중복체크" onclick="fn_overlapped()" />
	          			</td>
        			</tr>
        			<tr class="dot_line">
         	 			<td class="fixed_join">비밀번호</td>
          				<td>
            				<input name="seller_pw" type="password" id="seller_pw" size="20" required />
          				</td>
        			</tr>
        			<tr class="dot_line">
          				<td class="fixed_join">사업자명</td>
          				<td>
            				<input name="business_name" type="text" size="30" required />
          				</td>
        			</tr>
        			<tr class="dot_line">
          				<td class="fixed_join">업체 유형</td>
          				<td>
            				<input name="business_type" type="text" size="20" placeholder="예: 펜션, 병원 등" required />
          				</td>
        			</tr>
        			<tr class="dot_line">
          				<td class="fixed_join">대표자명</td>
          				<td>
            				<input name="owner_name" type="text" size="20" required />
          				</td>
        			</tr>
        			<tr class="dot_line">
          				<td class="fixed_join">사업자등록번호</td>
          				<td>
            				<input name="business_number" type="text" size="20" required />
          				</td>
        			</tr>
        			<tr class="dot_line">
          				<td class="fixed_join">대표 전화번호</td>
          				<td>
            				<input name="phone1" type="text" size="4" required/> -
            				<input name="phone2" type="text" size="4" required/> -
            				<input name="phone3" type="text" size="4" required/>
          				</td>
        			</tr>
        			<tr class="dot_line">
          				<td class="fixed_join">이메일</td>
   						<td><input size="10px"   type="text" name="email1" required/> @ <input  size="10px"  type="text" name="email2" id="email2_direct" required/> 
						<select name="email2_select" id="email2_select" onChange="changeEmailDomain()"	title="직접입력">
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
        			</tr>
        			<tr class="dot_line">
          				<td class="fixed_join">주소</td>
						<td>
					   		<input type="text" id="zipcode" name="zipcode" size="10" > <a href="javascript:execDaumPostcode()">우편번호검색</a>
					  		<br>
					  		<p> 
					   			지번 주소:<br><input type="text" id="roadAddress"  name="roadAddress" size="50"><br><br>
					  			도로명 주소: <input type="text" id="jibunAddress" name="jibunAddress" size="50"><br><br>
					  			나머지 주소: <input type="text"  name="namujiAddress" size="50" />
					   			<span id="guide" style="color:#999"></span>
					   		</p>
						</td>
        			</tr>
        			<tr class="dot_line">
          				<td class="fixed_join">업체 설명</td>
          				<td>
            				<textarea name="description" rows="2" cols="45"></textarea>
          				</td>
        			</tr>
        			<tr class="dot_line">
          				<td class="fixed_join">정산 은행명</td>
          				<td>
            				<input name="bank_name" type="text" size="15" />
          				</td>
        			</tr>
        			<tr class="dot_line">
          				<td class="fixed_join">정산 계좌번호</td>
          				<td>
            				<input name="bank_account" type="text" size="25" />
          				</td>
        			</tr>
        			<tr class="dot_line">
          				<td class="fixed_join">예금주</td>
          				<td>
            				<input name="bank_holder" type="text" size="15" />
          				</td>
        			</tr>
      			</tbody>
    		</table>
    		<div style="margin-top:20px;">
      			<input type="hidden" name="role" value="seller" />
      			<input type="submit" value="사업자 회원가입" />
      			<input type="reset" value="다시입력" />
    		</div>
  		</div>
	</form>	
</body>
</html>