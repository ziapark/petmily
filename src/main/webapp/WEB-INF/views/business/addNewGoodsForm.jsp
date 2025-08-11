<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<style>
	form.add_new_goods_form {background: white;padding: 20px;border-radius: 10px;box-shadow: 0 0 10px #ccc;width: 600px;margin: 0 auto;}
	table tr td {padding:10px;}
</style>
<script>
	let isBusinessIdVerified = false; // 아이디 확인 여부 전역 변수
	
	function fn_checkBusinessId() {
	    const _id = $("#seller_id").val().trim();
	
	    if (_id === '') {
	        alert("아이디를 입력하세요");
	        return;
	    }
	
	    $.ajax({
	        type: "post",
	        async: false,
	        url: "${contextPath}/business/overlapped.do",
	        dataType: "text",
	        data: { id: _id },
	        success: function(data, textStatus) {
	            if (data.trim() === 'true') {
	                alert("아이디가 확인되었습니다.");
	                $('#btnCheckBusinessId').prop("disabled", true);
	                $('#seller_id').prop("readonly", true);
	                isBusinessIdVerified = true;
	            } else {
	                alert("존재하지 않는 아이디입니다.");
	                isBusinessIdVerified = false;
	            }
	        },
	        error: function(data, textStatus) {
	            alert("에러가 발생했습니다.");
	            isBusinessIdVerified = false;
	        }
	    });
	}
	
	$(document).ready(function() {
	    // 폼 제출 이벤트 가로채기
	    $(".add_new_goods_form").on("submit", function(e) {
	        if (!isBusinessIdVerified) {
	            alert("아이디를 확인해주세요.");
	            e.preventDefault(); // 제출 중단
	        }
	    });
	});
</script>
</head>
<body>
<div class="container mt-3 mb-3">
	
	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold h2h2">상품 등록</h2>
			<p class="h2p"></p>
		</div>
	</div>	


	<form class="add_new_goods_form" action="${contextPath}/business/addNewGoods.do" method="post"enctype="multipart/form-data">
		<input type="hidden" name="goods_status" value="승인대기">
		<table>
			<tr>
				<td><label class="form-label">상품명</label></td>
				<td><input type="text" class="form-control" name="goods_name" required></td>
			</tr>
			<tr>
				<td><label class="form-label">판매자 아이디</td>
				<td><input type="text" class="form-control" name="seller_id" id="seller_id" required>
				<button type="button" class="btn btn-secondary" id="btnCheckBusinessId" onclick="fn_checkBusinessId()">아이디 확인</button>
				</td>
			</tr>
			<tr>
				<td><label class="form-label">판매자</td>
				<td><input type="text" class="form-control" name="goods_maker" required></td>
			</tr>
			<tr>
				<td><label class="form-label">카테고리</td>
				<td><select name="goods_category" class="form-control">
						<optgroup label="식품">
							<option value="사료" selected>사료</option>
							<option value="간식">간식</option>
							<option value="영양제">영양제</option>
						</optgroup>
						<optgroup label="장난감">
							<option value="봉제장난감">봉제장난감</option>
							<option value="공/원반">공/원반</option>
							<option value="라텍스장난감">라텍스장난감</option>
							<option value="치실/로프">치실/로프</option>
							<option value="터그놀이">터그놀이</option>
							<option value="노즈워크">노즈워크</option>
						</optgroup>
						<optgroup label="목욕/위생">
							<option value="목욕용품">목욕용품</option>
						</optgroup>
						<optgroup label="산책용품">
							<option value="칼라">칼라</option>
							<option value="배변봉투">배변봉투</option>
							<option value="하네스">하네스</option>
							<option value="목줄">목줄</option>
							<option value="유모차">유모차</option>
						</optgroup>
						<optgroup label="생활용품">
							<option value="생활용품">생활용품</option>
						</optgroup>
				</select></td>
			</tr>
			<tr>
				<td><label class="form-label">판매 가격</td>
				<td><input type="text" class="form-control" name="goods_sales_price" required></td>
			</tr>
			<tr>
				<td><label class="form-label">포인트(%)</td>
				<td><input type="text" class="form-control" name="goods_point" required></td>
			</tr>
			<tr>
				<td><label class="form-label">재고</td>
				<td><input type="text" class="form-control" name="goods_stock" required></td>
			</tr>
			<tr>
				<td><label class="form-label">배송비</td>
				<td><input type="text" class="form-control" name="goods_delivery_price" readonly value="무료배송"></td>
			</tr>
			<tr>
				<td><label class="form-label">대표이미지</td>
				<td><input type="file" class="form-control" name="goods_fileName" required></td>
			</tr>
				<td><label class="form-label">제품상세이미지</label></td> 
		        <td><input type="file" class="form-control" name="goods_fileName" required></td>
			</tr>  
           <tr>
               <td colspan="2" style="text-align:center;">
                   <button type="submit" class="btn btn-primary">상품 등록</button>
               </td>
           </tr>
       </table>
   </form>
</div>
</body>
</html>