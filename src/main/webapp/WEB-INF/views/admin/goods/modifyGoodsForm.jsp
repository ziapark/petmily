<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<title>상품 수정</title>
	<script type="text/javascript" src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<style>
		form.add_new_goods_form {background: white;padding: 20px;border-radius: 10px;box-shadow: 0 0 10px #ccc;width: 600px;margin: 0 auto;}
		table tr td {padding:10px;}
    	.image-section-header { text-align:left; font-size: 1.2em; font-weight: bold; padding-top: 20px; border-top: 2px solid #eee; }
	</style>
	<script type="text/javascript">
	    let originalGoodsName = '';
	    let isNewGoodsNameVerified = false; 
	
	    // 페이지가 모두 로딩되면 실행
	    $(document).ready(function() {
	        // 원본 상품명을 변수에 저장
	        originalGoodsName = $("#goods_name").val().trim();
	
	        $("#goods_name").on("input", function() {
	            const currentName = $(this).val().trim();
	            // 현재 이름이 원본과 달라졌다면,
	            if (currentName !== originalGoodsName) {
	                // 중복 확인이 필요하다는 신호로 '확인' 버튼을 다시 활성화
	                $('#btnCheckGoodsName').prop("disabled", false);
	                // 새로운 이름에 대한 확인 상태를 '미확인'으로 초기화
	                isNewGoodsNameVerified = false;
	            } else {
	                // 원본 이름으로 다시 돌아왔다면, 중복 확인이 필요 없으므로 버튼 비활성화
	                $('#btnCheckGoodsName').prop("disabled", true);
	            }
	        });

	        $(".add_new_goods_form").on("submit", function(e) {
	            const currentName = $("#goods_name").val().trim();

	            if (currentName !== originalGoodsName && !isNewGoodsNameVerified) {
	                alert("변경된 상품명에 대한 중복 확인을 해주세요.");
	                e.preventDefault(); // 폼 제출 중단
	            }
	        });
	    });
	
	    // 중복 확인 함수 (기존과 거의 동일, 변수명만 변경)
	    function fn_checkGoodsName() {
	        const _name = $("#goods_name").val().trim();
	    
	        if (_name === '') {
	            alert("상품명을 입력하세요");
	            return;
	        }
	    
	        $.ajax({
	            type: "post",
	            async: false,
	            url: "${contextPath}/business/checkGoodsName.do",
	            dataType: "text",
	            data: { goods_name: _name },
	            success: function(data, textStatus) {
	                if (data.trim() === 'true') {
	                    alert("사용 가능한 상품명입니다.");
	                    $('#btnCheckGoodsName').prop("disabled", true); // 버튼 비활성화
	                    isNewGoodsNameVerified = true; // '새로운 이름'이 확인되었다고 표시
	                } else {
	                    alert("이미 사용 중인 상품명입니다.");
	                    isNewGoodsNameVerified = false;
	                }
	            },
	            error: function(data, textStatus) {
	                alert("에러가 발생했습니다.");
	                isNewGoodsNameVerified = false;
	            }
	        });
	    }

		// 이미지 파일을 선택했을 때 화면에 미리보기를 보여주는 함수
		function readURL(input, previewId) {
	    	if (input.files && input.files[0]) {
	        	var reader = new FileReader();
	        	reader.onload = function(e) {
	            	$('#' + previewId).attr('src', e.target.result);
	        	}
	        	reader.readAsDataURL(input.files[0]);
	    	}
		}

		// 상품을 논리적으로 삭제(del_yn='Y')하는 함수
		function fn_remove_goods(goods_num) {
		    if (confirm("정말로 이 상품을 삭제하시겠습니까?")) {
		        var form = document.createElement("form");
		        form.setAttribute("method", "post");
		        form.setAttribute("action", "${contextPath}/admin/goods/removeGoods.do");
	
		        var goodsNumInput = document.createElement("input");
		        goodsNumInput.setAttribute("type", "hidden");
		        goodsNumInput.setAttribute("name", "goods_num");
		        goodsNumInput.setAttribute("value", goods_num);
	
		        form.appendChild(goodsNumInput);
		        document.body.appendChild(form);
		        form.submit();
		    }
		}
	
		// 삭제된 상품을 복원(del_yn='N')하는 함수
		function fn_restore_goods(goods_num) {
		    if (confirm("정말로 이 상품을 복원하시겠습니까?")) {
		        var form = document.createElement("form");
		        form.setAttribute("method", "post");
		        form.setAttribute("action", "${contextPath}/admin/goods/restoreGoods.do");
	
		        var goodsNumInput = document.createElement("input");
		        goodsNumInput.setAttribute("type", "hidden");
		        goodsNumInput.setAttribute("name", "goods_num");
		        goodsNumInput.setAttribute("value", goods_num);
	
		        form.appendChild(goodsNumInput);
		        document.body.appendChild(form);
		        form.submit();
		    }
		}
	</script>

</head>
<body>
	<div class="container mt-3 mb-3">
	 	<form name="frm_mod_goods" class="add_new_goods_form" method="post" action="${contextPath}/admin/goods/modifyGoods.do" enctype="multipart/form-data">
        	<input type="hidden" name="goods_num" value="${goodsVO.goods_num}">    
       	 	<table>	
	            <tr>
	                <td colspan="2" class="image-section-header">상품 정보 관리</td>
	            </tr>
	            <tr><td><label class="form-label">상품이름</label></td><td><input name="goods_name" id="goods_name" type="text" class="form-control" value="${goodsVO.goods_name }" />
				<button type="button" class="btn btn-secondary" id="btnCheckGoodsName" onclick="fn_checkGoodsName()">중복 확인</button></td></tr>
	            <tr>
		    		<td><label class="form-label">상품분류</label></td>
		    		<td>
		        	<select name="goods_category" class="form-control">
			            <optgroup label="식품">
			                <option value="사료" ${goodsVO.goods_category == '사료' ? 'selected' : ''}>사료</option>
			                <option value="간식" ${goodsVO.goods_category == '간식' ? 'selected' : ''}>간식</option>
			                <option value="영양제" ${goodsVO.goods_category == '영양제' ? 'selected' : ''}>영양제</option>
			            </optgroup>
			            <optgroup label="장난감">
			                <option value="봉제장난감" ${goodsVO.goods_category == '봉제장난감' ? 'selected' : ''}>봉제장난감</option>
			                <option value="공/원반" ${goodsVO.goods_category == '공/원반' ? 'selected' : ''}>공/원반</option>
			                <option value="라텍스장난감" ${goodsVO.goods_category == '라텍스장난감' ? 'selected' : ''}>라텍스장난감</option>
			                <option value="치실/로프" ${goodsVO.goods_category == '치실/로프' ? 'selected' : ''}>치실/로프</option>
			                <option value="터그놀이" ${goodsVO.goods_category == '터그놀이' ? 'selected' : ''}>터그놀이</option>
			                <option value="노즈워크" ${goodsVO.goods_category == '노즈워크' ? 'selected' : ''}>노즈워크</option>
			            </optgroup>
			            <optgroup label="목욕/위생">
			                <option value="목욕용품" ${goodsVO.goods_category == '목욕용품' ? 'selected' : ''}>목욕용품</option>
			            </optgroup>
			            <optgroup label="산책용품">
			                <option value="칼라" ${goodsVO.goods_category == '칼라' ? 'selected' : ''}>칼라</option>
			                <option value="배변봉투" ${goodsVO.goods_category == '배변봉투' ? 'selected' : ''}>배변봉투</option>
			                <option value="하네스" ${goodsVO.goods_category == '하네스' ? 'selected' : ''}>하네스</option>
			                <option value="목줄" ${goodsVO.goods_category == '목줄' ? 'selected' : ''}>목줄</option>
			                <option value="유모차" ${goodsVO.goods_category == '유모차' ? 'selected' : ''}>유모차</option>
			            </optgroup>
			            <optgroup label="생활용품">
			                <option value="생활용품" ${goodsVO.goods_category == '생활용품' ? 'selected' : ''}>생활용품</option>
			            </optgroup>
			        </select>
				    </td>
				</tr>
				<tr>
				    <td><label class="form-label">추천 날씨</label></td>
				    <td>
				        <input type="radio" id="weather_sunny" name="goods_recommend" value="맑음" ${goodsVO.goods_recommend == '맑음' ? 'checked' : ''}>
				        <label for="weather_sunny">맑음</label>
				
				        <input type="radio" id="weather_cloudy" name="goods_recommend" value="흐림" ${goodsVO.goods_recommend == '흐림' ? 'checked' : ''}>
				        <label for="weather_cloudy">흐림</label>
				
				        <input type="radio" id="weather_rain" name="goods_recommend" value="비" ${goodsVO.goods_recommend == '비' ? 'checked' : ''}>
				        <label for="weather_rain">비</label>
				
				        <input type="radio" id="weather_snow" name="goods_recommend" value="눈" ${goodsVO.goods_recommend == '눈' ? 'checked' : ''}>
				        <label for="weather_snow">눈</label>
				    </td>
				</tr>
            	<tr><td><label class="form-label">제조사</label></td><td><input name="goods_maker" type="text" class="form-control" value="${goodsVO.goods_maker }" /></td></tr>
            	<tr><td><label class="form-label">상품판매가격</label></td><td><input name="goods_sales_price" type="text" class="form-control" value="${goodsVO.goods_sales_price }" /></td></tr>
            	<tr><td><label class="form-label">상품 구매 포인트(%)</label></td><td><input name="goods_point" type="text" class="form-control" value="${goodsVO.goods_point }" /></td></tr>
            	<tr><td><label class="form-label">상품 배송비</label></td><td><input name="goods_delivery_price" type="text" class="form-control" value="${goodsVO.goods_delivery_price }" /></td></tr>
            	<tr><td><label class="form-label">상품 재고 수량</label></td><td><input name="goods_stock" type="text" class="form-control" value="${goodsVO.goods_stock}" /></td></tr>
            	<tr><td><label class="form-label">판매상태</label></td><td><select name="goods_status" class="form-control"><c:if test="${memberInfo.member_id == 'admin'}"><option value="승인대기" ${goodsVO.goods_status == '승인대기' ? 'selected' : ''}>승인대기</option></c:if><option value="판매중" ${goodsVO.goods_status == '판매중' ? 'selected' : ''}>판매중</option><option value="품절" ${goodsVO.goods_status == '품절' ? 'selected' : ''}>품절</option><option value="삭제" ${goodsVO.goods_status == '삭제' ? 'selected' : ''}>삭제</option></select></td></tr>

            	<tr>
                	<td colspan="2" class="image-section-header">상품 이미지 관리</td>
            	</tr>
				<tr>
				    <td><label class="form-label">대표이미지</label></td>
				    <td>
				        <%-- 전체 이미지 리스트에서 fileType이 'main'인 항목만 찾아서 출력 --%>
				        <c:forEach var="image" items="${goodsImageList}">
				            <c:if test="${image.fileType == 'main'}">
				                <input type="file" name="main_image" id="main_image_file" onchange="readURL(this, 'mainImagePreview');" />
				                <br>
				                <img id="mainImagePreview" width="150" height="150" src="${contextPath}/download.do?goods_num=${image.goods_num}&fileName=${image.fileName}" />
				                <input type="hidden" name="original_main_image_fileName" value="${image.fileName}" />
				                <input type="hidden" name="image_id_main" value="${image.image_id}" />
				            </c:if>
				        </c:forEach>
				    </td>
				</tr>
				<tr>
				    <td><label class="form-label">제품상세이미지</label></td>
				    <td>
				        <%-- 전체 이미지 리스트에서 fileType이 'sub'인 항목들만 찾아서 반복 출력 --%>
				        <c:forEach var="image" items="${goodsImageList}" varStatus="loop">
				            <c:if test="${image.fileType == 'sub'}">
				                <div id="imageTr${image.image_id}" style="margin-bottom: 15px;">
				                    <input type="file" name="detail_image${loop.index}" id="detail_image_${image.image_id}" onchange="readURL(this,'preview${image.image_id}');" />
				                    <br>
				                    <img id="preview${image.image_id}" width="150" height="150" src="${contextPath}/download.do?goods_num=${image.goods_num}&fileName=${image.fileName}">
				                    <input type="hidden" name="original_detail_image_id" value="${image.image_id}" />
				                </div>
				            </c:if>
				        </c:forEach>
				    </td>
				</tr>
            	<tr>
                	<td colspan="2" style="text-align:center; padding-top: 20px;">
                    	<input type="submit" class="btn btn-primary" value="상품 정보 수정하기">
                     	<c:choose>
		                	<c:when test="${goods.del_yn eq 'Y'}">
		                    	<input type="button" class="btn btn-success" value="상품 복원" onClick="fn_restore_goods('${goodsVO.goods_num}')">
		                	</c:when>
		                	<c:otherwise>
		                    	<input type="button" class="btn btn-danger" value="상품 삭제" onClick="fn_remove_goods('${goodsVO.goods_num}')">
		                	</c:otherwise>
		            	</c:choose>
                    	<c:choose>
				        	<c:when test="${memberInfo.member_id == 'admin'}">
				            	<input type="button" class="btn btn-secondary" value="목록으로" onClick="location.href='${contextPath}/admin/goods/adminGoodsMain.do'">
				        	</c:when>
				        	<c:otherwise>
				        	    <input type="button" class="btn btn-secondary" value="목록으로" onClick="location.href='${contextPath}/business/businessGoodsMain.do'">
				        	</c:otherwise>
				    	</c:choose>
                	</td>
            	</tr>
        	</table>
		</form>	
	</div>
</body>
</html>