<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
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
			<h2 class="fw-bold">게시글 수정</h2>
			<p></p>	
		</div>
	</div>
	<div class="row row-cols-1">

		<div class="col">
	<form name="" action="${pageContext.request.contextPath}/BoardUpdateAction.do?num=${vo.num}" method="post">
		<input type="hidden" name="nonce" value="0">
	
		<div class="mb-3 row">
			<label for="name" class="col-sm-2 col-form-label">이름 </label>
			<div class="col-sm-10">
			     <input type="text" name="uname" class="form-control" value="${vo.uname}">
			  </div>
		</div>
		<div class="mb-3 row">
			<label for="title" class="col-sm-2 col-form-label">제목 </label>
			<div class="col-sm-10">
			     <input type="text" name="title" class="form-control" value="${vo.title}">
			  </div>
		</div>		
		<div class="mb-3 row">
			<label for="" class="col-sm-2 col-form-label">내용 </label>
			<div class="col-sm-10">
				<textarea class="form-control writearea" name="content">${vo.content}</textarea>  
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