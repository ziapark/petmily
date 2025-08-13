<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<c:set var="goods" value="${goodsMap.goods}" />
<c:set var="imageFileList" value="${goodsMap.imageFileList}" />

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
		function modifyImageFile(fileId, goods_num, image_id, fileType) {
			var formData = new FormData(); // 빈 FormData 객체 생성
			var fileInput = $('#' + fileId)[0];
			if (fileInput.files.length === 0) {
				alert("수정할 이미지를 선택해 주세요.");
				return;
			}
			// 필요한 데이터만 직접 추가
			formData.append("uploadFile", fileInput.files[0]);
			formData.append("goods_num", goods_num);
			formData.append("image_id", image_id);
			formData.append("fileType", fileType);

			$.ajax({
				url : '${contextPath}/admin/goods/modifyGoodsImageInfo.do',
				processData : false,
				contentType : false,
				data : formData,
				type : 'POST',
				success : function(result) {
					alert("이미지를 수정했습니다!");
					location.reload();
				}
			});
		}
	
		function addNewImageFile(fileId, goods_num) {
			var formData = new FormData(); // 빈 FormData 객체 생성
			var fileInput = $('#' + fileId)[0];
			if (fileInput.files.length === 0) {
				alert("추가할 이미지를 선택해 주세요.");
				return;
			}
			formData.append("uploadFile", fileInput.files[0]);
			formData.append("goods_num", goods_num);

			$.ajax({
				url : '${contextPath}/admin/goods/addNewGoodsImage.do',
				processData : false,
				contentType : false,
				data : formData,
				type : 'post',
				success : function(result) {
					alert("새 이미지를 추가했습니다!");
					location.reload();
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

		// 새 이미지 파일 추가를 위한 전역 카운터
		var cnt = 1;

		// '새 상세이미지 추가' 버튼 클릭 시 파일 입력창을 동적으로 생성하는 함수
		function fn_addFile() {
	    	$("#d_file").append(
	        	"<br>" + "<input type='file' name='detail_image" + cnt + "' id='detail_image" + cnt + "' onchange=readURL(this,'previewNewImage" + cnt + "') />"
	    	);
	    	$("#d_file").append(
	        	"<img id='previewNewImage" + cnt + "' width=200 height=200 />"
	    	);
	    	$("#d_file").append(
	        	"<input type='button' value='새 이미지 추가' onClick=\"addNewImageFile('detail_image" + cnt + "','${goods.goods_num}')\"  />"
	    	);
	   		cnt++;
		}

		// 기존 상세 이미지를 서버에서 삭제하는 함수
		function deleteImageFile(goods_num, image_id, imageFileName, trId) {
	    	if (!confirm("정말로 이미지를 삭제하시겠습니까?")) {
	        	return;
	    	}
	    	var tr = document.getElementById(trId);
	    	$.ajax({
		        type: "post",
		        url: "${contextPath}/admin/goods/removeGoodsImage.do",
		        data: {
		            goods_num: goods_num,
		            image_id: image_id,
		            imageFileName: imageFileName
		        },
		        success: function(data, textStatus) {
		            alert("이미지를 삭제했습니다.");
		            tr.style.display = 'none';
		        }
	    	});
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
    	<div class="row row-cols-1 mb-3">
			<div class="col bg-light p-5 text-start">
				<h2 class="fw-bold h2h2">상품 정보 수정</h2>
				<p class="h2p"></p>
			</div>
		</div>	

 <form name="frm_mod_goods" class="add_new_goods_form" method="post" action="${contextPath}/admin/goods/modifyGoods.do" enctype="multipart/form-data">
        	<input type="hidden" name="goods_num" value="${goods.goods_num}">
        
       	 	<table>	
	            <tr>
	                <td colspan="2" class="image-section-header">상품 정보 관리</td>
	            </tr>
	            <tr>
	    		<td><label class="form-label">상품분류</label></td>
	    		<td>
	        	<select name="goods_category" class="form-control">
		            <optgroup label="식품">
		                <option value="사료" ${goods.goods_category == '사료' ? 'selected' : ''}>사료</option>
		                <option value="간식" ${goods.goods_category == '간식' ? 'selected' : ''}>간식</option>
		                <option value="영양제" ${goods.goods_category == '영양제' ? 'selected' : ''}>영양제</option>
		            </optgroup>
		            <optgroup label="장난감">
		                <option value="봉제장난감" ${goods.goods_category == '봉제장난감' ? 'selected' : ''}>봉제장난감</option>
		                <option value="공/원반" ${goods.goods_category == '공/원반' ? 'selected' : ''}>공/원반</option>
		                <option value="라텍스장난감" ${goods.goods_category == '라텍스장난감' ? 'selected' : ''}>라텍스장난감</option>
		                <option value="치실/로프" ${goods.goods_category == '치실/로프' ? 'selected' : ''}>치실/로프</option>
		                <option value="터그놀이" ${goods.goods_category == '터그놀이' ? 'selected' : ''}>터그놀이</option>
		                <option value="노즈워크" ${goods.goods_category == '노즈워크' ? 'selected' : ''}>노즈워크</option>
		            </optgroup>
		            <optgroup label="목욕/위생">
		                <option value="목욕용품" ${goods.goods_category == '목욕용품' ? 'selected' : ''}>목욕용품</option>
		            </optgroup>
		            <optgroup label="산책용품">
		                <option value="칼라" ${goods.goods_category == '칼라' ? 'selected' : ''}>칼라</option>
		                <option value="배변봉투" ${goods.goods_category == '배변봉투' ? 'selected' : ''}>배변봉투</option>
		                <option value="하네스" ${goods.goods_category == '하네스' ? 'selected' : ''}>하네스</option>
		                <option value="목줄" ${goods.goods_category == '목줄' ? 'selected' : ''}>목줄</option>
		                <option value="유모차" ${goods.goods_category == '유모차' ? 'selected' : ''}>유모차</option>
		            </optgroup>
		            <optgroup label="생활용품">
		                <option value="생활용품" ${goods.goods_category == '생활용품' ? 'selected' : ''}>생활용품</option>
		            </optgroup>
		        </select>
			    </td>
				</tr>
				<tr><td><label class="form-label">상품이름</label></td><td><input name="goods_name" type="text" class="form-control" value="${goods.goods_name }" /></td></tr>
            	<tr><td><label class="form-label">제조사</label></td><td><input name="goods_maker" type="text" class="form-control" value="${goods.goods_maker }" /></td></tr>
            	<tr><td><label class="form-label">상품판매가격</label></td><td><input name="goods_sales_price" type="text" class="form-control" value="${goods.goods_sales_price }" /></td></tr>
            	<tr><td><label class="form-label">상품 구매 포인트(%)</label></td><td><input name="goods_point" type="text" class="form-control" value="${goods.goods_point }" /></td></tr>
            	<tr><td><label class="form-label">상품 배송비</label></td><td><input name="goods_delivery_price" type="text" class="form-control" value="${goods.goods_delivery_price }" /></td></tr>
            	<tr><td><label class="form-label">상품 재고 수량</label></td><td><input name="goods_stock" type="text" class="form-control" value="${goods.goods_stock}" /></td></tr>
            	<tr><td><label class="form-label">판매상태</label></td><td><select name="goods_status" class="form-control"><c:if test="${memberInfo.member_id == 'admin'}"><option value="승인대기" ${goods.goods_status == '승인대기' ? 'selected' : ''}>승인대기</option></c:if><option value="판매중" ${goods.goods_status == '판매중' ? 'selected' : ''}>판매중</option><option value="품절" ${goods.goods_status == '품절' ? 'selected' : ''}>품절</option><option value="삭제" ${goods.goods_status == '삭제' ? 'selected' : ''}>삭제</option></select></td></tr>

            	<tr>
                	<td colspan="2" class="image-section-header">상품 이미지 관리</td>
            	</tr>
            	<c:forEach var="item" items="${imageFileList}" varStatus="itemNum">
                	<c:choose>
                    	<c:when test="${item.fileType=='main_image'}">
                        	<tr>
                            	<td>메인 이미지</td>
                            	<td>
                                	<input type="file" id="main_image" name="main_image" class="form-control" onchange="readURL(this,'preview${itemNum.count}');" />
                                	<img id="preview${itemNum.count}" width=150 height=150 src="${contextPath}/download.do?goods_num=${item.goods_num}&fileName=${item.fileName}" />
                                	<input type="hidden" name="original_main_image_fileName" value="${item.fileName}" />
                            	</td>
                        	</tr>
                    	</c:when>
                    	<c:otherwise>
                        	<tr id="imageTr${item.image_id}">
                            	<td>상세 이미지${itemNum.count-1}</td>
                            	<td>
                                	<input type="file" name="detail_image${itemNum.count-1}" class="form-control" id="detail_image_${item.image_id}" onchange="readURL(this,'preview${itemNum.count}');" />
                                	<img id="preview${itemNum.count}" width=150 height=150 src="${contextPath}/download.do?goods_num=${item.goods_num}&fileName=${item.fileName}">
                                	<input type="button" class="btn btn-sm btn-outline-danger" value="삭제" onClick="deleteImageFile('${item.goods_num}','${item.image_id}','${item.fileName}','imageTr${item.image_id}')" />
                                	<input type="hidden" name="original_detail_image_fileName" value="${item.fileName}" />
                                	<input type="hidden" name="original_detail_image_id" value="${item.image_id}" />
                            	</td>
                        	</tr>
                    	</c:otherwise>
                	</c:choose>
            	</c:forEach>
            	<tr align="center">
                	<td colspan="2">
                    	<div id="d_file"></div>
                    	<input type="button" class="btn btn-info" value="새 상세이미지 추가" onClick="fn_addFile()" />
                	</td>
            	</tr>
            
            	<tr>
                	<td colspan="2" style="text-align:center; padding-top: 20px;">
                    	<input type="submit" class="btn btn-primary" value="상품 정보 수정하기">
                     	<c:choose>
		                	<c:when test="${goods.del_yn eq 'Y'}">
		                    	<input type="button" class="btn btn-success" value="상품 복원" onClick="fn_restore_goods('${goods.goods_num}')">
		                	</c:when>
		                	<c:otherwise>
		                    	<input type="button" class="btn btn-danger" value="상품 삭제" onClick="fn_remove_goods('${goods.goods_num}')">
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