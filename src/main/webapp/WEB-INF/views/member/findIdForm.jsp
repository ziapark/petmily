<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
    <style>
        .find_id_wrap {
            width: 400px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .find_id_wrap h3 {
            text-align: center;
            margin-bottom: 20px;
        }
        .find_id_wrap input[type="text"], .find_id_wrap input[type="email"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            box-sizing: border-box;
        }
        .find_id_wrap .btn-submit {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
             margin-bottom: 10px;
        }
        
          /* 버튼들을 담을 div 스타일 추가 */
        .find_id_wrap .other_btns {
            display: flex;
            justify-content: space-between; /* 버튼들을 양쪽으로 정렬 */
        }
        /* 추가된 버튼들 공통 스타일 */
        .find_id_wrap .btn-secondary {
            width: 49%; /* 버튼 너비 조정 */
            padding: 10px;
            background-color: #6c757d;
            color: white;
            border: none;
            cursor: pointer;
            text-align: center;
            text-decoration: none; /* a 태그의 밑줄 제거 */
            display: inline-block;
            border-radius: 3px;
        }
        
    </style>
</head>
<body>
    <div class="find_id_wrap">
        <h3>아이디 찾기</h3>
        <form action="${contextPath}/member/findId.do" method="post">
            <input type="text" name="member_name" placeholder="이름을 입력하세요" required>
            <div>
                <input type="text" name="email1" placeholder="이메일 아이디" style="width: 48%; display: inline-block;" required> @
                <input type="text" name="email2" placeholder="이메일 주소" style="width: 48%; display: inline-block;" required>
            </div>
            <input type="submit" value="아이디 찾기" class="btn-submit">
        </form>
 <%-- [추가] 뒤로가기, 아이디 찾기 버튼 --%>
        <div class="other_btns">
        <button type="button" onclick="history.back()"  class="btn-secondary">로그인하기</button>
           
            <a href="${contextPath}/member/findPwForm.do" class="btn-secondary">비밀번호 찾기</a>
        </div>
<%--         <c:if test="${not empty message}"> --%>
<!--             <script> -->
<%-- //                 alert("${message}"); --%>
<!--             </script> -->
<%--         </c:if> --%>
    </div>
</body>
</html>