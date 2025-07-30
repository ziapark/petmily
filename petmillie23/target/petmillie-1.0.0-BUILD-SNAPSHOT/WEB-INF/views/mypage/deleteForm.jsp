<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>회원탈퇴</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>
<body>
    <h2>회원탈퇴</h2>
    <form id="deleteForm" onsubmit="event.preventDefault(); submitdelete();">
    	<input type="hidden" id="member_id" name="member_id" value="${memberInfo.member_id}">
        <p>정말로 회원을 탈퇴하시겠습니까?</p>
        <p>회원 탈퇴 시 모든 정보가 삭제되며 복구가 불가능합니다.</p>
        <input type="submit" value="탈퇴하기">
        <button type="button" onclick="window.history.back();">취소</button>
    </form>
    <script>
function submitdelete() {
	var _id = $("#member_id").val()
	console.log("탈퇴요청 member_id:", _id);
    console.log("submitDeleteForm 호출됨"); // 디버깅용
    if (confirm("정말로 회원탈퇴 하시겠습니까?\n(탈퇴 후 복구가 불가능합니다.)")) {
        console.log("탈퇴 요청 전송 시도"); // 디버깅용
        $.ajax({
            type: "POST",
            url: "${contextPath}/mypage/removeMember.do",
            data: {id:_id},
            dataType: "text",
            beforeSend: function(xhr) {
                console.log("AJAX beforeSend 실행");
            },
            success: function(response) {
                console.log("AJAX success, 응답:", response);
                if (typeof response === "object") {
                    // 혹시 JSON 객체로 응답될 경우 문자열 변환
                    response = JSON.stringify(response);
                }
                if ($.trim(response) === "true") {
                    alert("회원탈퇴가 완료되었습니다.");
                    window.location.href = "${contextPath}/main/main.do";
                } else {
                    alert("회원탈퇴에 실패했습니다. 다시 시도해 주세요.");
                }
            },
            error: function(xhr, status, error) {
                console.error("AJAX error 발생!", xhr, status, error);
                alert(
                    "서버와 통신 중 오류가 발생했습니다.\n" +
                    "status: " + status + "\n" +
                    "HTTP 상태코드: " + xhr.status + "\n" +
                    "오류 메시지: " + error + "\n" +
                    "응답 내용: " + xhr.responseText
                );
            },
            complete: function(xhr, status) {
                console.log("AJAX complete - status:", status);
            }
        });
    } else {
        console.log("사용자가 탈퇴 취소");
    }
}
</script>
</body>
</html>
