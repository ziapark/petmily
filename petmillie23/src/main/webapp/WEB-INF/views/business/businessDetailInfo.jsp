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
	  document.getElementById("business_email").value = email1 + "@" + email2;
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
    
     var phone1='${businessInfo.phone1 }';
     var selphone1 = document.getElementById('phone1');
     var optionphone1 = selphone1.options;
     var val;
     for(var i=0; i<optionphone1.length;i++){
       val = optionphone1[i].value;
       if(phone1 == val){
    	   optionphone1[i].selected= true;
        break;
       }
     }  
     
   }


    function fn_modify_business_info(attribute) {
        var value;
        var frm_mod_business = document.frm_mod_business;
        if(attribute=='seller_pw'){
            value = frm_mod_business.seller_pw.value;
        } else if(attribute=='phone'){
            var value_phone1 = frm_mod_business.phone1.value;
            var value_phone2 = frm_mod_business.phone2.value;
            var value_phone3 = frm_mod_business.phone3.value;
            value = value_phone1 + "," + value_phone2 + "," + value_phone3;
        } else if(attribute=='email'){
            var value_email1 = frm_mod_business.email1.value;
            var value_email2 = frm_mod_business.email2.value;
            value = value_email1 + "," + value_email2;
        } else if(attribute=='address'){
            var value_zipcode = frm_mod_business.zipcode.value;
            var value_roadAddress = frm_mod_business.roadAddress.value;
            var value_jibunAddress = frm_mod_business.jibunAddress.value;
            var value_namujiAddress = frm_mod_business.namujiAddress.value;
            value = value_zipcode + "," + value_roadAddress + "," + value_jibunAddress + "," + value_namujiAddress;
		}else if(attribute =='bank_name'){
			value = frm_mod_business.bank_name.value;
		}else if(attribute == 'bank_account') {
			value = frm_mod_business.bank_account.value;
		}else if(attribute == 'bank_holder') {
			value = frm_mod_business.bank_holder.value;
		}
        // AJAX 호출
        $.ajax({
            type : "post",
            async : false,
            url : "${contextPath}/business/modifyMyInfo.do",
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
	<h3>내 상세 정보</h3>
<form name="frm_mod_business">	
	<div id="detail_table">
		<table>
			<tbody>
				<tr class="dot_line">
					<td class="fixed_join">아이디</td>
					<td>
						<input name="seller_id" type="text" size="20" value="${businessInfo.seller_id }"  disabled/>
					</td>
					 <td>
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">비밀번호</td>
					<td>
					  <input name="seller_pw" type="password" size="20" value="${businessInfo.seller_pw }" />
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_business_info('seller_pw')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">이름</td>
					<td>
					  <input name="business_name" type="text" size="20" value="${businessInfo.business_name }"  disabled />
					 </td>
					 <td>
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">휴대폰번호</td>
					<td>
					   <select  name="phone1" id="phone1">
							<option value="010" selected>010</option>
							<option value="011">011</option>
							<option value="016">016</option>
							<option value="017">017</option>
							<option value="018">018</option>
							<option value="019">019</option>
					</select> 
					 - <input type="text" name="phone2" size=4 value="${businessInfo.phone2 }"> 
					 - <input type="text"name="phone3"  size=4 value="${businessInfo.phone3 }"><br> <br>

				    </td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_business_info('phone')" />
					</td>	
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">이메일<br>(e-mail)</td>
					<td>
					   <input type="text" name="email1" size=10 value="${businessInfo.email1 }" /> @ <input type="text" size=10  name="email2" id="email2_direct" value="${businessInfo.email2 }" /> 
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
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_business_info('email')" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">주소</td>
					<td>
					   <input type="text" id="zipcode" name="zipcode" size=5 value="${businessInfo.zipcode }" > <a href="javascript:execDaumPostcode()">우편번호검색</a>
					  <br>
					  <p> 
					   지번 주소:<br><input type="text" id="roadAddress"  name="roadAddress" size="50" value="${businessInfo.roadAddress }"><br><br>
					  도로명 주소: <input type="text" id="jibunAddress" name="jibunAddress" size="50" value="${businessInfo.jibunAddress }"><br><br>
					  나머지 주소: <input type="text"  name="namujiAddress" size="50" value="${businessInfo.namujiAddress }" />
					   </p>
					</td>
					<td>
					  <input type="button" value="수정하기" onClick="fn_modify_business_info('address')" />
					</td>
				</tr>
				<tr class="dot_Line">
				<td class="fixed_join">은행명</td>
				<td>
					<input type="text" id="bank_name" name="bank_name" size=5 value="${businessInfo.bank_name}">
					<br>
				</td>
				<td>
				<input type="button" value="수정하기" onClick="fn_modify_business_info('bank_name')" />
				</td>
				</tr>
				<tr class="dot_Line">
				<td class="fixed_join">계좌번호</td>
				<td>
				<input type="text" id="bank_account" name="bank_account" size=5 value="${businessInfo.bank_account}">
				<br>
				</td>
				<td>
				<input type="button" value="수정하기" onClick="fn_modify_business_info('bank_account')" />
				</td>
				</tr>
				<tr class="dot_Line">
				<td class="fixed_join">예금주</td>
				<td>
					<input type="text" id="bank_holder" name="bank_holder" size=5 value="${businessInfo.bank_holder}">
				</td>
				<td>
				<input type="button" value="수정하기" onClick="fn_modify_business_info('bank_holder')" />
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
				<input name="btn_cancel_business" type="button"  value="수정 취소">
			</td>
		</tr>
	</table>
	</div>
	<input  type="hidden" name="h_phone1" value="${businessInfo.phone1}" />
</form>	
</body>
</html>
