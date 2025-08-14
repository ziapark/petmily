<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>	 
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
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
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
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
        .form-group input[type="text"],
        .form-group input[type="date"],
        .form-group select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
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
    </style>
</head>
<body>

<div class="container text-center mt-3 mb-3">
    <div class="row row-cols-1 mb-3">
        <div class="col bg-light p-5 text-start">
            <h2 class="fw-bold">마이페이지</h2>
        </div>
    </div>
    <div class="mypage_wrap">
        <div class="side_menu">
            <ul>
                <li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문내역/배송 조회</a></li>
                <li><a href="${contextPath}/mypage/myPetInfo.do" style="font-weight: bold; color: #007bff;">내 반려동물 정보</a></li>
                <li><a href="${contextPath}/mypage/myReview.do">마이리뷰</a></li>
                <li><a href="${contextPath}/mypage/likeGoods.do">나의 관심상품</a></li>
                <li><a href="${contextPath}/mypage/myDetailInfo.do">회원정보관리</a></li>
                <li><a href="${contextPath}/mypage/deleteForm.do">회원탈퇴</a></li>
            </ul>
        </div>
        <div class="mypage_content">
            <h3 style="text-align:left;">반려동물 정보 수정</h3>
            <div class="form-section">
                <form action="${contextPath}/mypage/modifyPet.do" method="post">
                    <!-- 수정할 반려동물의 ID를 hidden 필드로 전달 -->
                    <input type="hidden" name="pet_id" value="${petVO.pet_id}">
                    
                    <div class="form-group">
                        <label for="pet_name">이름</label>
                        <input type="text" id="pet_name" name="pet_name" value="${petVO.pet_name}" required>
                    </div>
                    <div class="form-group">
                        <label for="pet_birth_date">생년월일</label>
                        <input type="date" id="pet_birth_date" name="pet_birth_date" value="${petVO.pet_birth_date}" required>
                    </div>
                    <div class="form-group">
                        <label for="pet_species">종</label>
                        <input type="text" id="pet_species" name="pet_species" value="${petVO.pet_species}" required>
                    </div>
                    <div class="form-group">
                        <label for="pet_breed">품종</label>
                        <input type="text" id="pet_breed" name="pet_breed" value="${petVO.pet_breed}">
                    </div>
                    <div class="form-group">
                        <label for="pet_gender">성별</label>
                        <div class="gender-options">
                            <label>
                                <input type="radio" name="pet_gender" value="수컷" <c:if test="${petVO.pet_gender == '수컷'}">checked</c:if> required> 수컷
                            </label>
                            <label>
                                <input type="radio" name="pet_gender" value="암컷" <c:if test="${petVO.pet_gender == '암컷'}">checked</c:if> required> 암컷
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="pet_favorite_toy">좋아하는 장난감</label>
                        <input type="text" id="pet_favorite_toy" name="pet_favorite_toy" value="${petVO.pet_favorite_toy}">
                    </div>
                    <div class="form-group">
                        <label for="pet_favorite_snack">좋아하는 간식</label>
                        <input type="text" id="pet_favorite_snack" name="pet_favorite_snack" value="${petVO.pet_favorite_snack}">
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
