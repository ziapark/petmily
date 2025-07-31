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
	<form name="writeForm" action="${contextPath}/board/write.do" method="post" enctype="multipart/form-data">
		<input type="hidden" name="nonce" value="0">
	    <input type="hidden" name="id" value="${param.id}" />
	    <input type="hidden" name="board_type" value="${param.board_type}">
		<div class="mb-3 row">
			<label for="name" class="col-sm-2 col-form-label">작성자 </label>
			<div class="col-sm-10">
			     <input type="text" name="member_id" class="form-control" value="${param.id}" readonly>
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
			<label for="" class="col-sm-2 col-form-label">사진첨부</label>
			<div class="col-sm-10">
				<input type="file" name="uploadFile" class="form-control">
			</div>
		</div>
		<div class="mb-3 row">
			<p><input type="button" onclick="write_check();" value="전송" class="btn btn-primary"></p>
		</div>
		
	</form>
	
	</div>
	</div>
	</div>
	<script>
		//게시글 등록 유효성검사
		function write_check(){
		    var subject = document.writeForm.subject.value.trim();
		    var content = document.writeForm.content.value.trim();
		
		    if(subject === "") {
		        alert("제목을 입력하세요.");
		        return false;
		    }
		    if(content === "") {
		        alert("내용을 입력하세요.");
		        return false;
		    }
		
		    document.writeForm.submit();
		}
</script>
	
</body>
</html>