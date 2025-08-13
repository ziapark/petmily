<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
			<h2 class="fw-bold">리뷰 수정</h2>
			<p></p>	
		</div>
	</div>
	<div class="row row-cols-1">

	<div class="col">
	<form name="writeForm" action="${contextPath}/mypage/updateReview.do" method="post" enctype="multipart/form-data">
		<input type="hidden" name="nonce" value="0">
	    <input type="hidden" name="order_num" value="${review.order_num}" />
	    <input type="hidden" name="originalFileName" value="${review.file_name}" />
	    <input type="hidden" name="review_id" value="${review.review_id}" />
		<div class="mb-3 row">
			<label for="name" class="col-sm-2 col-form-label">작성자 </label>
			<div class="col-sm-10">
			     <input type="text" name="member_id" class="form-control" value="${review.member_id}" readonly>
			  </div>
		</div>
		<div class="mb-3 row">
			<label for="name" class="col-sm-2 col-form-label">주문 상품 </label>
			<div class="col-sm-10">
			     <input type="text" name="goods_name" class="form-control" value="${review.goods_name}" readonly>
			  </div>
		</div>		
		<div class="mb-3 row">
			<label for="" class="col-sm-2 col-form-label">내용 </label>
			<div class="col-sm-10">
				<textarea class="form-control writearea" name="content">${review.content}</textarea>
			</div>
		</div>	
		<div class="mb-3 row">
		  <label class="col-sm-2 col-form-label">평가</label>
		  <div class="col-sm-10 d-flex">
		    <div class="form-check me-3">
		        <input class="form-check-input" type="radio" name="rating" id="rating1" value="1"
			    <c:if test="${review.rating == 1}">checked</c:if> >
				<label class="form-check-label" for="rating1">★</label>
		    </div>
		    <div class="form-check me-3">
				<input class="form-check-input" type="radio" name="rating" id="rating2" value="2"
			    <c:if test="${review.rating == 2}">checked</c:if> >
				<label class="form-check-label" for="rating2">★★</label>
		    </div>
		    <div class="form-check me-3">
		      	<input class="form-check-input" type="radio" name="rating" id="rating3" value="3"
				<c:if test="${review.rating == 3}">checked</c:if> >
				<label class="form-check-label" for="rating3">★★★</label>
		    </div>
		    <div class="form-check me-3">
		        <input class="form-check-input" type="radio" name="rating" id="rating4" value="4"
			    <c:if test="${review.rating == 4}">checked</c:if> >
			    <label class="form-check-label" for="rating4">★★★★</label>
		    </div>
		    <div class="form-check">
		        <input class="form-check-input" type="radio" name="rating" id="rating5" value="5"
			    <c:if test="${review.rating == 5}">checked</c:if> >
			    <label class="form-check-label" for="rating5">★★★★★</label>
		    </div>
		  </div>
		</div>
		<div class="mb-3 row">
			<label for="" class="col-sm-2 col-form-label">사진첨부</label>
			<div class="col-sm-10">
				<input type="file" name="uploadFile" class="form-control" value="${review.file_name}">
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

		    var content = document.writeForm.content.value.trim();
		
		    if(content === "") {
		        alert("내용을 입력하세요.");
		        return false;
		    }
		
		    document.writeForm.submit();
		}
</script>
	
</body>
</html>