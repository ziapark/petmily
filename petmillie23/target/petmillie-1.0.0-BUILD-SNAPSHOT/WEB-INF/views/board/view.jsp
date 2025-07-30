<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="com.petmillie.board.vo.BoardVO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">

<meta charset="utf-8">
<link rel="stylesheet" href="css/common.css">
<script src="js/validation.js"></script>
<title>펫밀리</title>
</head>
<body>
	<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold">게시글</h2>
			<p></p>	
		</div>
	</div>
	<div class="row row-cols-1">
	    <div class="row">
		    <div style="text-align:right;"><span>글쓴이</span>${vo.member_id}</div>	
		    <div style="text-align:right;"><span>작성일</span>${vo.reg_date}</div>
			<div style="text-align:right;"><span>조회수</span>${vo.views}</div>	    
    	</div>
    	<div class="row">
		    <div class="alert alert-light fw-bold" style="text-align:left;">제목: ${vo.subject}</div>
	    </div>
    	<div class="row">
    		<div class="alert alert-light" style="text-align:left;">내용: ${vo.content}</div>
    	</div>
    	<div style="padding-top:10px;">
	    	<a href="#" class="btn btn-sm btn-secondary">이전</a>
	    	<a href="${contextPath}/board/updateForm.do?num=${vo.comu_id}" class="btn btn-sm btn-primary">수정</a>
	    	<a href="${contextPath}/board/delete.do?num=${vo.comu_id}" class="btn btn-sm btn-danger">삭제</a>
    	</div>
    	
   	</div>
</div>
</body>
</html>