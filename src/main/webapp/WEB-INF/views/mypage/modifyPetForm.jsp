<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>반려동물 정보 수정</title>
<style>
.form-section {
	background-color: #fff;
	padding: 30px;
	border-radius: 8px;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
	max-width: 600px;
	margin: 0 auto;
}

.form-group {
	margin-bottom: 20px;
}

.form-group label {
	display: block;
	margin-bottom: 8px;
	font-weight: bold;
}

.form-group input[type="text"], .form-group input[type="date"],
	.form-group input[type="file"], .form-group select {
	width: 100%;
	padding: 10px;
	border: 1px solid #ddd;
	border-radius: 4px;
	box-sizing: border-box;
}

.gender-options {
	display: flex;
	gap: 20px;
}

.gender-options input {
	margin-right: 5px;
}

.btn-submit {
	background-color: #007bff;
	color: white;
	padding: 12px 20px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	width: 100%;
	font-size: 16px;
}

.btn-cancel {
	background-color: #f44336;
	color: white;
	padding: 12px 20px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	width: 100%;
	font-size: 16px;
	margin-top: 10px;
}

.current-pet-image {
	width: 120px;
	height: 120px;
	object-fit: cover;
	border-radius: 8px;
	border: 1px solid #eee;
	margin-bottom: 10px;
}
</style>
</head>
<body>
	<div class="container text-center mt-3 mb-3">
		<div class="mypage_wrap">
			<div class="side_menu">
				<ul>
					<li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문내역/배송
							조회</a></li>
					<li><a href="${contextPath}/mypage/myDetailInfo.do">내 정보</a></li>
					<li><a href="${contextPath}/mypage/myPetInfo.do"
						style="font-weight: bold; color: #007bff;">내 반려동물 정보</a></li>
					<li><a href="${contextPath}/mypage/myReview.do">마이리뷰</a></li>
					<li><a href="${contextPath}/mypage/likeGoods.do">나의 관심상품</a></li>
					<li><a href="${contextPath}/mypage/deleteForm.do">회원탈퇴</a></li>
				</ul>
			</div>
			<div class="mypage_content">
				<h3 style="text-align: left;">반려동물 정보 수정</h3>
				<div class="form-section">
					<form action="${contextPath}/mypage/modifyPet.do" method="post"
						enctype="multipart/form-data">
						<input type="hidden" name="pet_id" value="${petVO.pet_id}" /> <input
							type="hidden" name="originalFileName" value="${petVO.pet_image}" />

						<%-- 프로필 사진 섹션 --%>
						<div class="form-group">
							<label for="uploadFile">프로필 사진</label>
							<div>
								<c:choose>
									<c:when test="${not empty petVO.pet_image}">
										<img
											src="${contextPath}/mypet/image.do?pet_image=${petVO.pet_image}"
											class="current-pet-image" alt="현재 프로필 사진" />
									</c:when>
									<c:otherwise>
										<img
											src="${contextPath}/resources/image/default_pet_profile.png"
											class="current-pet-image" alt="기본 프로필 사진" />
									</c:otherwise>
								</c:choose>
							</div>
							<input type="file" id="uploadFile" name="uploadFile"
								accept="image/*" style="margin-top: 10px;">
							<p style="font-size: 12px; color: #888; margin-top: 5px;">※
								사진을 변경하려면 파일을 선택하세요.</p>
						</div>

						<div class="form-group">
							<label for="pet_name">반려동물 이름</label> <input type="text"
								id="pet_name" name="pet_name" value="${petVO.pet_name}" required>
						</div>
						<div class="form-group">
							<label for="pet_birth_date">출생일</label> <input type="date"
								id="pet_birth_date" name="pet_birth_date"
								value="${petVO.pet_birth_date}" required>
						</div>
						<div class="form-group">
							<label for="pet_species">반려동물 종류</label> <input type="text"
								id="pet_species" name="pet_species" value="${petVO.pet_species}"
								placeholder="강아지, 고양이 등" required>
						</div>
						<div class="form-group">
							<label for="pet_breed">품종</label> <input type="text"
								id="pet_breed" name="pet_breed" value="${petVO.pet_breed}"
								placeholder="말티즈, 코숏 등">
						</div>
						<div class="form-group">
							<label for="pet_gender">성별</label>
							<div class="gender-options">
								<label><input type="radio" name="pet_gender" value="남아"
									<c:if test="${petVO.pet_gender == '남아'}">checked</c:if>
									required> 남아</label> <label><input type="radio"
									name="pet_gender" value="여아"
									<c:if test="${petVO.pet_gender == '여아'}">checked</c:if>
									required> 여아</label>
							</div>
						</div>
						<div class="form-group">
							<label for="pet_favorite_toy">좋아하는 장난감</label> <input type="text"
								id="pet_favorite_toy" name="pet_favorite_toy"
								value="${petVO.pet_favorite_toy}" placeholder="예: 삑삑이 인형">
						</div>
						<div class="form-group">
							<label for="pet_favorite_snack">좋아하는 간식</label> <input
								type="text" id="pet_favorite_snack" name="pet_favorite_snack"
								value="${petVO.pet_favorite_snack}" placeholder="예: 닭가슴살 간식">
						</div>

						<button type="submit" class="btn-submit">수정하기</button>
						<button type="button" class="btn-cancel" onclick="history.back()">취소</button>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
</html>