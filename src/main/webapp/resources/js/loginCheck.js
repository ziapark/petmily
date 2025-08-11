function check(regExp, e, msg){
		if(regExp.test(e.value)){
			return true;
		}
		alert(msg);
		e.focus();
		return false;
	}

function Checklogin(){
	
	var userid = document.getElementById("member_id");
	var password = document.getElementById("member_pw");
	
	if(userid.value.length == 0) {
		alert("아이디을 입력해주세요");
		return false;
	}
	
	if(!check(/^[a-zA-Z0-9]*$/, userid, "아이디는 영어와 숫자만 입력해 주세요")){
	userid.focus();
	return false;
	}
	
	if(password.value.length == 0 ){
		alert("비밀번호를 입력해주세요");
		password.focus();
		return false;
	}
	
	if(!check(/^[a-zA-Z0-9]*$/, password, "비밀번호는 영어와 숫자만 입력해주세요")){
		password.focus();
		return false;
	}
	
//	document.forms["login"].submit()
	return true;
}