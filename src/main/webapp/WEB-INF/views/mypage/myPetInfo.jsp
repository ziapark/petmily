<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>	 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>나의 반려동물 정보</title>
<style>
.pet-card {
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 20px;
    box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    background-color: #fff;
}
.pet-card h4 {
    color: #333;
    font-size: 1.5em;
    margin-bottom: 15px;
}
.pet-card p {
    margin: 5px 0;
}
.btn-container {
    margin-top: 15px;
}
.btn-container .btn {
    margin-right: 10px;
}
</style>
</head>
<body>

<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold">마이페이지 </h2>
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
		<h3 style="text-align:left;">나의 반려동물 정보</h3>
        <div class="pet-info-container">
            <c:choose>
                <c:when test="${empty petList}">
                    <div class="text-center p-5">
                        <p>현재 등록된 반려동물 정보가 없습니다. 😭</p>
                        <c:if test="${fn:length(petList) < 3}">
                            <a href="${contextPath}/mypage/addPetForm.do" class="btn btn-primary mt-3">반려동물 등록하기</a>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="pet" items="${petList}" varStatus="status">
                        <div class="pet-card">
                            <h4>${pet.pet_name}</h4>
                            <p><strong>생년월일:</strong> ${pet.pet_birth_date}</p>
                            <p><strong>종:</strong> ${pet.pet_species}</p>
                            <p><strong>품종:</strong> ${pet.pet_breed}</p>
                            <p><strong>성별:</strong> ${pet.pet_gender}</p>
                            <%-- 나이 계산 로직은 Controller나 JSP EL에서 처리해야 합니다. 여기서는 예시로 생략합니다. --%>
                            <p><strong>좋아하는 장난감:</strong> ${pet.pet_favorite_toy}</p>
                            <p><strong>좋아하는 간식:</strong> ${pet.pet_favorite_snack}</p>
                            <div class="btn-container">
                                <a href="${contextPath}/mypage/modifyPetForm.do?petId=${pet.pet_id}" class="btn btn-warning">수정</a>
                                <a href="javascript:void(0)" onclick="fn_delete_pet('${pet.pet_id}')" class="btn btn-danger">삭제</a>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${fn:length(petList) < 3}">
                        <a href="${contextPath}/mypage/addPetForm.do" class="btn btn-primary">반려동물 등록하기</a>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div>
	</div>
</div>
</div>
</body>
</html>
