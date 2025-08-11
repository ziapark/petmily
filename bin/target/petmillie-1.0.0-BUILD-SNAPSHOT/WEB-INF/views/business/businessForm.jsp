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
          }else{
        	  alert("사용할 수 없는 ID입니다.");
          }
       },
       error:function(data,textStatus){
          alert("에러가 발생했습니다.");
       },
       complete:function(data,textStatus){
          //alert("작업을완료 했습니다");
       }
    });  //end ajax	 
 }	
</script>
</head>
<body>
	<h3>필수입력사항</h3>
	<form action="${contextPath}/business/addSeller.do" method="post" onsubmit="return setEmail();">
  <div id="detail_table">
    <table>
      <tbody>
        <tr class="dot_line">
          <td class="fixed_join">아이디(셀러ID)</td>
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