<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>	 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>나의 반려동물 정보</title>
	<style>
	/* 전체 카드 레이아웃을 flex로 변경하여 좌우로 나눔 */
	.pet-card {
		display: flex;
		align-items: flex-start; /* 세로 정렬 */
		gap: 20px; /* 이미지와 정보 사이 간격 */
		border: 1px solid #ddd;
		border-radius: 8px;
		padding: 20px;
		margin-bottom: 20px;
		box-shadow: 0 4px 8px rgba(0,0,0,0.1);
		background-color: #fff;
	}
	
	/* 반려동물 이미지를 감싸는 컨테이너 */
	.pet-image-container {
		flex-shrink: 0; /* 컨테이너 크기가 줄어들지 않도록 설정 */
	}

	/* 반려동물 이미지 스타일 */
	.pet-image-container img {
		width: 150px;
		height: 150px;
		object-fit: cover; /* 이미지가 잘리더라도 비율을 유지하며 꽉 채움 */
		border-radius: 8px; /* 이미지 모서리를 둥글게 */
		border: 1px solid #eee;
	}

	/* 반려동물 텍스트 정보를 감싸는 컨테이너 */
	.pet-info {
		flex-grow: 1; /* 남은 공간을 모두 차지하도록 설정 */
	}

	.pet-card h4 {color: #333;font-size: 1.5em;margin-top:0; margin-bottom: 15px;}
	.pet-card p {margin: 5px 0;}
	.btn-container {margin-top: 15px;}
	.btn-container .btn {margin-right: 10px;}
	</style>
	<script>
// 반려동물 삭제 함수
function fn_delete_pet(pet_id){
	var answer=confirm("정말로 이 반려동물 정보를 삭제하시겠습니까?");
	if(answer==true){
		var formObj=document.createElement("form");
		var i_pet_id = document.createElement("input"); 
	    
	    i_pet_id.name="pet_id";
	    i_pet_id.value=pet_id;
		
	    formObj.appendChild(i_pet_id);
	    document.body.appendChild(formObj); 
	    formObj.method="get";
	    formObj.action="${contextPath}/mypage/removePet.do";
	    formObj.submit();	
	}
}

</script>
</head>
<body>
	<div class="container text-center mt-3 mb-3">
		<div class="row row-cols-1 mb-3">
			<div class="col bg-light p-5 text-start">
				<h2 class="fw-bold h2h2">회원정보관리</h2>
				<p class="h2p"></p>
			</div>
		</div>	
	    <div class="row seller_menu">
			<ul>	
				<li><a href="${contextPath}/mypage/myDetailInfo.do">내 정보</a></li>
				<li><a href="${contextPath}/mypage/myPetInfo.do">나의 반려동물</a></li>
				<li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문/배송 조회</a></li>
				<li><a href="${contextPath}/reservation/myReservations.do">예약확인</a></li>				
				<li><a href="${contextPath}/mypage/myReview.do">나의 리뷰</a></li>
				<li><a href="${contextPath}/mypage/likeGoods.do">나의 관심상품</a></li>				
				<li><a href="${contextPath}/mypage/deleteForm.do">회원탈퇴</a></li>
			</ul>
		</div>
			<div class="">
				<h3 style="text-align:left;">나의 반려동물 정보</h3>
				<p style="text-align:left; color: #666; margin-bottom: 20px;">
    				※ 반려동물은 최대 <strong style="color: #007bff;">3마리</strong>까지 등록 가능합니다.
				</p>
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
                    		
	                		<div class="container mt-4">
							  <div class="row g-4">
							    <c:forEach var="pet" items="${petList}" varStatus="status">
							      <div class="col-md-4">
							        <div class="card shadow-sm h-100" style="border-color:#3cdeff;">
							          <div class="pet-image-container text-center mt-3">
							            <c:choose>
							              <c:when test="${not empty pet.pet_image}">
							                <img src="${contextPath}/mypet/image.do?pet_image=${pet.pet_image}" 
							                     alt="${pet.pet_name} 프로필 사진" 
							                     class="rounded-circle img-fluid" 
							                     style="width: 120px; height: 120px; object-fit: cover;">
							              </c:when>
							              <c:otherwise>
							                <img src="${contextPath}/resources/image/default_pet_profile.png" 
							                     alt="기본 프로필 사진" 
							                     class="rounded-circle img-fluid" 
							                     style="width: 120px; height: 120px; object-fit: cover;">
							              </c:otherwise>
							            </c:choose>
							          </div>
							          <div class="card-body text-center">
							            <h5 class="card-title mb-3">${pet.pet_name}</h5>
							            <p class="card-text mb-0"><strong>출생일:</strong> ${pet.pet_birth_date}</p>
							            <p class="card-text mb-0"><strong>종류:</strong> ${pet.pet_species}</p>
							            <p class="card-text mb-0"><strong>품종:</strong> ${pet.pet_breed}</p>
							            <p class="card-text mb-0"><strong>성별:</strong> ${pet.pet_gender}</p>
							            <p class="card-text mb-0"><strong>장난감:</strong> ${pet.pet_favorite_toy}</p>
							            <p class="card-text mb-0"><strong>간식:</strong> ${pet.pet_favorite_snack}</p>
							          </div>
							          <div class="card-footer bg-white d-flex justify-content-between" style="border-color:#3cdeff;">
							            <a href="${contextPath}/mypage/modifyPetForm.do?pet_id=${pet.pet_id}" 
							               class="btn btn-sm btn-outline-dark">수정</a>
							            <a href="javascript:void(0)" 
							               onclick="fn_delete_pet('${pet.pet_id}')" 
							               class="btn btn-sm btn-outline-danger">삭제</a>
							          </div>
							        </div>
							      </div>
							    </c:forEach>
							  </div>
							</div>
	
							
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