<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<meta charset="utf-8">
<link rel="stylesheet" href="css/common.css">
<script src="js/validation.js"></script>
<title>펫밀리</title>
</head>
<body>

	<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold">게시글 등록</h2>
			<p></p>	
		</div>
	</div>
	<div class="row row-cols-1">

		<div class="col">
	<form name="" action="${contextPath}/board/write.do" method="post">
		<input type="hidden" name="nonce" value="0">
	    <input type="hidden" name="id" value="${param.id}" />
		<div class="mb-3 row">
			<label for="name" class="col-sm-2 col-form-label">이름 </label>
			<div class="col-sm-10">
			     <input type="text" name="member_id" class="form-control" placeholder="이름을 입력하세요">
			  </div>
		</div>
		<div class="mb-3 row">
			<label for="subject" class="col-sm-2 col-form-label">제목 </label>
			<div class="col-sm-10">
			     <input type="text" name="subject" class="form-control" placeholder="제목을 입력하세요">
			  </div>
		</div>		
		<div class="mb-3 row">
			<label for="" class="col-sm-2 col-form-label">내용 </label>
			<div class="col-sm-10">
				<textarea class="form-control writearea" name="content"></textarea>  
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