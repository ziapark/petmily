<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
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
			<h2 class="fw-bold">게시글 수정</h2>
			<p></p>	
		</div>
	</div>
	<div class="row row-cols-1">

		<div class="col">
	<form name="" action="${contextPath}/board/update.do?num=${vo.comu_id}&board_type=${param.board_type}" method="post" enctype="multipart/form-data">
		<input type="hidden" name="nonce" value="0">
		<input type="hidden" name="originalFileName" value="${vo.file_name}" />
		<input type="hidden" name="comu_id" value="${vo.comu_id}">
		<div class="mb-3 row">
			<label for="name" class="col-sm-2 col-form-label">이름 </label>
			<div class="col-sm-10">
			     <input type="text" name="member_id" class="form-control" value="${vo.member_id}" readonly>
			  </div>
		</div>
		<div class="mb-3 row">
			<label for="title" class="col-sm-2 col-form-label">제목 </label>
			<div class="col-sm-10">
			     <input type="text" name="subject" class="form-control" value="${vo.subject}">
			  </div>
		</div>		
		<div class="mb-3 row">
			<label for="" class="col-sm-2 col-form-label">내용 </label>
			<div class="col-sm-10">
				<textarea class="form-control writearea" name="content">${vo.content}</textarea>  
			</div>
		</div>	
		<div class="mb-3 row">
			<label for="" class="col-sm-2 col-form-label">사진첨부</label>
			<div class="col-sm-10">
				<input type="file" name="uploadFile" class="form-control" value="${vo.file_name}">
			</div>
		</div>
		<div class="mb-3 row">
			<p><input type="submit" value="전송" class="btn btn-primary"></p>
		</div>
		
	</form>
	
	</div>
	</div>
	</div>
	
</body>
</html>