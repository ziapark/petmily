<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>펫밀리</title>
	<style>
		form.add_new_goods_form {background: white;padding: 20px;border-radius: 10px;box-shadow: 0 0 10px #ccc;width: 600px;margin: 0 auto;}
		table tr td {padding:10px;}
	</style>
	<script>
		let isGoodsNameVerified = false; // 상품명 확인 여부 전역 변수
	
		function fn_checkGoodsName() {
		    const _name = $("#goods_name").val().trim();
		
		    if (_name === '') {
		        alert("상품명을 입력하세요");
		        return;
		    }
		
		    $.ajax({
		        type: "post",
		        async: false, // 결과를 받고 다음으로 넘어가기 위해 동기 처리
		        url: "${contextPath}/business/checkGoodsName.do",
		        dataType: "text",
		        data: { goods_name: _name },
		        success: function(data, textStatus) {
		            if (data.trim() === 'true') {
		                alert("사용 가능한 상품명입니다.");
		                $('#btnCheckGoodsName').prop("disabled", true); // 버튼 비활성화
		                $('#goods_name').prop("readonly", true);      // 입력창 잠금
		                isGoodsNameVerified = true;                 // 확인 완료 플래그
		            } else {
		                alert("이미 사용 중인 상품명입니다.");
		                isGoodsNameVerified = false;
		            }
		        },
		        error: function(data, textStatus) {
		            alert("에러가 발생했습니다.");
		            isGoodsNameVerified = false;
		        }
		    });
		}
		
		$(document).ready(function() {
		    // 폼 제출 이벤트 가로채기
		    $(".add_new_goods_form").on("submit", function(e) {
		        if (!isGoodsNameVerified) {
		            alert("상품명 중복 확인을 해주세요.");
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
		<div class="row seller_menu">
			<ul>	
				<li><a href="${contextPath}/business/businessDetailInfo.do">내 정보</a></li>
				<li><a href="${contextPath}/business/addNewGoodsForm.do">상품등록</a></li>
				<li><a href="${contextPath}/business/businessGoodsMain.do">상품관리</a></li>
				<li><a href="${contextPath}/business/businessGoodsMain.do">주문/배송관리</a></li>
				<li><a href="${contextPath}/business/addpensionForm.do">펜션등록</a></li>
				<li><a href="${contextPath}/business/mypension.do?business_id=${business_id}">펜션관리</a></li>
				<li><a href="${contextPath}/reservation/reservation_check.do">예약관리</a></li>
				<li><a href="${contextPath}/business/deleteForm.do">회원탈퇴</a></li>
			</ul>
		</div>
		<form class="add_new_goods_form" action="${contextPath}/business/addNewGoods.do" method="post"enctype="multipart/form-data">
			<input type="hidden" name="goods_status" value="승인대기">
			<table>
				<tr>
					<td><label class="form-label">상품명</label></td>
					<td><input type="text" class="form-control" name="goods_name" id="goods_name" required>
					<button type="button" class="btn btn-secondary" id="btnCheckGoodsName" onclick="fn_checkGoodsName()">중복 확인</button>
					</td>
				</tr>
				<tr>
					<td><label class="form-label">판매자 아이디</td>
					<td><input type="text" class="form-control" name="seller_id" id="seller_id" value="${businessInfo.seller_id}" readonly required></td>
				</tr>
				<tr>
					<td><label class="form-label">제조사</td>
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
								<option value="터그놀이">터그놀이</option>
								<option value="낚시대">낚시대</option>
								<option value="먹이퍼즐">먹이퍼즐</option>
							</optgroup>
							<optgroup label="목욕/위생">
								<option value="애견샴푸">샴푸</option>
								<option value="칫솔/치약">칫솔/치약</option>
								<option value="수건">수건</option>
								<option value="미용기">미용기</option>
							</optgroup>
							<optgroup label="산책용품">
								<option value="목줄/하네스">목줄/하네스</option>
								<option value="배변봉투">배변봉투</option>
								<option value="유모차">유모차</option>
							</optgroup>
							<optgroup label="생활용품">
								<option value="식기">식기</option>
								<option value="스크래처">스크래처</option>
								<option value="의류">의류</option>
								<option value="신발">신발</option>
							</optgroup>
					</select></td>
				</tr>
				<tr>
				    <td><label class="form-label">추천 날씨</label></td>
				    <td>
				        <input type="radio" id="weather_sunny" name="goods_recommend" value="맑음" checked>
				        <label for="weather_sunny">맑음</label>
				
				        <input type="radio" id="weather_cloudy" name="goods_recommend" value="흐림">
				        <label for="weather_cloudy">흐림</label>
				
				        <input type="radio" id="weather_rain" name="goods_recommend" value="비">
				        <label for="weather_rain">비</label>
				
				        <input type="radio" id="weather_snow" name="goods_recommend" value="눈">
				        <label for="weather_snow">눈</label>
				    </td>
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
					<td><input type="file" class="form-control" name="main_image" required></td>
				</tr>
					<td><label class="form-label">제품상세이미지</label></td> 
			        <td><input type="file" class="form-control" name="sub_image" required></td>
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