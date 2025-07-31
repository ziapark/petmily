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
<script type="text/javascript"
	src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<c:choose>
	<c:when test='${not empty goods.goods_status}'>
		<script>
			window.onload = function() {
				init();
			}

			function init() {
				var frm_mod_goods = document.frm_mod_goods;
				// goods_status 선택 값 초기화 (hidden 필드를 통해)
				var h_goods_status = frm_mod_goods.h_goods_status;
				var goods_status_val = h_goods_status.value; // 변수명 충돌 방지
				var select_goods_status = frm_mod_goods.goods_status;
				select_goods_status.value = goods_status_val;

				// goods_category 선택 값 초기화
				var h_goods_category = frm_mod_goods.h_goods_category;
				var goods_category_val = h_goods_category.value;
				var select_goods_category = frm_mod_goods.goods_category;
				select_goods_category.value = goods_category_val;

			}
		</script>
	</c:when>
</c:choose>

<script type="text/javascript">
	function fn_modify_goods(goods_num, attribute) {
		var frm_mod_goods = document.frm_mod_goods;
		var value = "";

		// 변경된 필드명에 맞게 수정
		if (attribute == 'goods_category') {
			value = frm_mod_goods.goods_category.value;
		} else if (attribute == 'goods_name') {
			value = frm_mod_goods.goods_name.value;
		} else if (attribute == 'goods_maker') {
			value = frm_mod_goods.goods_maker.value;
		} else if (attribute == 'goods_publisher') {
			value = frm_mod_goods.goods_publisher.value;
	
		} else if (attribute == 'goods_sales_price') {
			value = frm_mod_goods.goods_sales_price.value;
		} else if (attribute == 'goods_point') {
			value = frm_mod_goods.goods_point.value;
			// 	}else if(attribute=='goods_published_date'){
			// 		value=frm_mod_goods.goods_published_date.value;
			// 	}else if(attribute=='goods_total_page'){
			// 		value=frm_mod_goods.goods_total_page.value;
			// 	}else if(attribute=='goods_isbn'){
			// 		value=frm_mod_goods.goods_isbn.value;
		} else if (attribute == 'goods_delivery_price') {
			value = frm_mod_goods.goods_delivery_price.value;
		} else if (attribute == 'goods_delivery_date') {
			value = frm_mod_goods.goods_delivery_date.value;
		} else if (attribute == 'goods_stock') {
			value = frm_mod_goods.goods_stock.value;
		} else if (attribute == 'goods_status') {
			value = frm_mod_goods.goods_status.value;
		} else if (attribute == 'goods_contents_order') {
			value = frm_mod_goods.goods_contents_order.value;
		} else if (attribute == 'goods_goods_writer_intro') {
			value = frm_mod_goods.goods_goods_writer_intro.value;
		} else if (attribute == 'goods_intro') {
			value = frm_mod_goods.goods_intro.value;
			// 	}else if(attribute=='goods_publisher_comment'){
			// 		value=frm_mod_goods.goods_publisher_comment.value;
			// 	}else if(attribute=='goods_recommendation'){
			// 		value=frm_mod_goods.goods_recommendation.value;
		}

		// 유효성 검사 (필요에 따라 추가)
		if ( attribute === 'goods_sales_price'
				|| attribute === 'goods_point'
				|| attribute === 'goods_delivery_price'
				|| attribute === 'goods_stock') {
			if (isNaN(value) || value < 0) {
				alert("숫자만 입력해 주세요.");
				return;
			}
		}

		$.ajax({
			type : "post",
			async : false, //false인 경우 동기식으로 처리한다.
			url : "${contextPath}/admin/goods/modifyGoodsInfo.do",
			data : {
				goods_num : goods_num,
				attribute : attribute,
				value : value
			},
			success : function(data, textStatus) {
				if (data.trim() == 'mod_success') {
					alert("상품 정보를 수정했습니다.");
				} else if (data.trim() == 'failed') {
					alert("다시 시도해 주세요.");
				}

			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다." + data.responseText);
			},
			complete : function(data, textStatus) {
				//alert("작업을완료 했습니다");

			}
		}); //end ajax
	}

	function readURL(input, preview) {
		//  alert(preview);
		if (input.files && input.files[0]) {
			var reader = new FileReader();
			reader.onload = function(e) {
				$('#' + preview).attr('src', e.target.result);
			}
			reader.readAsDataURL(input.files[0]);
		}
	}

	var cnt = 1;
	function fn_addFile() {
		$("#d_file").append(
				"<br>" + "<input  type='file' name='detail_image" + cnt
						+ "' id='detail_image" + cnt
						+ "'  onchange=readURL(this,'previewNewImage" + cnt
						+ "') />");
		$("#d_file").append(
				"<img  id='previewNewImage"+cnt+"'   width=200 height=200  />");
		$("#d_file")
				.append(
						"<input  type='button' value='새 이미지 추가'  onClick=\"addNewImageFile('detail_image"
								+ cnt
								+ "','${goods.goods_num}','detail_image')\"  />");
		cnt++;
	}

	function modifyImageFile(fileId, goods_num, image_id, fileType) {
		// alert(fileId);
		var form = $('#FILE_FORM')[0];
		var formData = new FormData(form);
		var fileInput = $('#' + fileId)[0];
		if (fileInput.files.length === 0) {
			alert("수정할 이미지를 선택해 주세요.");
			return;
		}
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
				if (result.trim() == 'mod_success') {
					alert("이미지를 수정했습니다!");
				} else {
					alert("이미지 수정 실패: " + result);
				}
			},
			error : function(data, textStatus) {
				alert("이미지 수정 중 에러가 발생했습니다." + data.responseText);
			}
		});
	}

	function addNewImageFile(fileId, goods_num, fileType) {
		//  alert(fileId);
		var form = $('#FILE_FORM')[0];
		var formData = new FormData(form);

		var fileInput = $('#' + fileId)[0];
		if (fileInput.files.length === 0) {
			alert("추가할 이미지를 선택해 주세요.");
			return;
		}
		formData.append("uploadFile", fileInput.files[0]);
		formData.append("goods_num", goods_num);
		formData.append("fileType", fileType);

		$.ajax({
			url : '${contextPath}/admin/goods/addNewGoodsImage.do',
			processData : false,
			contentType : false,
			data : formData,
			type : 'post',
			success : function(result) {
				if (result.trim() == 'add_success') {
					alert("새 이미지를 추가했습니다!");
					location.reload();
				} else {
					alert("새 이미지 추가 실패: " + result);
				}
			},
			error : function(data, textStatus) {
				alert("새 이미지 추가 중 에러가 발생했습니다." + data.responseText);
			}
		});
	}

	function deleteImageFile(goods_num, image_id, imageFileName, trId) {
		var tr = document.getElementById(trId);

		$.ajax({
			type : "post",
			async : true, //false인 경우 동기식으로 처리한다.
			url : "${contextPath}/admin/goods/removeGoodsImage.do",
			data : {
				goods_num : goods_num,
				image_id : image_id,
				imageFileName : imageFileName
			},
			success : function(data, textStatus) {
				if (data.trim() == 'del_success') {
					alert("이미지를 삭제했습니다!!");
					tr.style.display = 'none';
				} else {
					alert("이미지 삭제 실패: " + data);
				}
			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다." + data.responseText);
			},
			complete : function(data, textStatus) {
				//alert("작업을완료 했습니다");

			}
		}); //end ajax
	}

	// 상품 삭제 함수 (del_yn을 'Y'로 변경)
	function fn_remove_goods(goods_num) {
		if (confirm("정말로 이 상품을 삭제하시겠습니까? (실제 DB에서 삭제되지 않고 '삭제됨'으로 표시됩니다.)")) {
			$.ajax({
				type : "post",
				async : false,
				url : "${contextPath}/admin/goods/removeGoods.do", // 삭제를 처리할 URL
				data : {
					goods_num : goods_num
				},
				success : function(data, textStatus) {
					if (data.trim() == 'remove_success') {
						alert("상품이 성공적으로 삭제되었습니다.");
						location.reload(); // 삭제 후 페이지 새로고침하여 UI 업데이트
					} else if (data.trim() == 'failed') {
						alert("상품 삭제에 실패했습니다. 다시 시도해 주세요.");
					}
				},
				error : function(data, textStatus) {
					alert("상품 삭제 중 에러가 발생했습니다: " + data.responseText);
                    console.error("AJAX Error (remove_goods):", data, textStatus);
				},
				complete : function(data, textStatus) {
					// 완료 후 추가 작업 (선택 사항)
				}
			});
		}
	}

    // 상품 복원 함수 (del_yn을 'N'으로 변경)
    function fn_restore_goods(goods_num) {
        if (confirm("정말 상품을 복원하시겠습니까?")) {
            $.ajax({
                type : "post",
                async : false,
                url : "${contextPath}/admin/goods/restoreGoods.do", // 복원 요청 URL
                data : {
                    goods_num : goods_num
                },
                success: function(data) {
                    if (data.trim() == "restore_success") {
                        alert("상품이 성공적으로 복원되었습니다.");
                        location.reload(); // 성공 시 페이지 새로고침하여 바뀐 상태를 반영
                    } else if (data.trim() == "failed") {
                        alert("상품 복원에 실패했습니다. 다시 시도해주세요.");
                    }
                },
                error: function(request, status, error) {
                    alert("상품 복원 중 에러가 발생했습니다." + request.responseText);
                    console.error("AJAX Error (restore_goods):", request, status, error); // 콘솔에 자세한 에러 출력
                }
            });
        }
    }


	$(document).ready(function() {
		$('.tabs a').click(function(e) {
			e.preventDefault();
			$('.tab_content').hide();
			$('.tabs a').removeClass('active');
			$(this).addClass('active');
			var currentTab = $(this).attr('href');
			$(currentTab).show();
		});
		$('.tabs a:first').click();
	});
</script>

<style>
.tab_container {
	width: 100%;
	margin: 20px 0;
}

.tabs {
	list-style: none;
	padding: 0;
	margin: 0;
	display: flex;
	border-bottom: 1px solid #ccc;
}

.tabs li {
	margin-right: 1px;
}

.tabs a {
	display: block;
	padding: 10px 15px;
	background-color: #f1f1f1;
	color: #555;
	text-decoration: none;
	border: 1px solid #ccc;
	border-bottom: none;
	border-top-left-radius: 5px;
	border-top-right-radius: 5px;
}

.tabs a.active {
	background-color: #fff;
	color: #000;
	border-color: #ccc;
	border-bottom: 1px solid #fff;
}

.tab_content {
	border: 1px solid #ccc;
	border-top: none;
	padding: 20px;
	background-color: #fff;
	display: none;
}

.clear {
	clear: both;
}

table {
	width: 100%;
	border-collapse: collapse;
}

table td {
	padding: 8px;
	border: 1px solid #ddd;
	vertical-align: top;
}
</style>

</head>
<body>
	<form name="frm_mod_goods" method="post">
		<DIV class="clear"></DIV>
		<DIV id="container">
			<UL class="tabs">
				<li><A href="#tab1">상품정보</A></li>
				<li><A href="#tab3">제조사 소개</A></li>
				<li><A href="#tab4">상품소개</A></li>


				<li><A href="#tab7">상품이미지</A></li>
			</UL>
			<DIV class="tab_container">
				<DIV class="tab_content" id="tab1">
					<table>
						<tr>
							<td width=200>상품분류</td>
							<td width=500><select name="goods_category">
									<c:choose>
										<c:when test="${goods.goods_category eq '컴퓨터와 인터넷' }">
											<option value="컴퓨터와 인터넷" selected>컴퓨터와 인터넷</option>
											<option value="디지털 기기">디지털 기기</option>
										</c:when>
										<c:when test="${goods.goods_category eq '디지털 기기' }">
											<option value="컴퓨터와 인터넷">컴퓨터와 인터넷</option>
											<option value="디지털 기기" selected>디지털 기기</option>
										</c:when>
										<c:otherwise>
											<option value="컴퓨터와 인터넷">컴퓨터와 인터넷</option>
											<option value="디지털 기기">디지털 기기</option>
										</c:otherwise>
									</c:choose>
							</select> <input type="hidden" name="h_goods_category"
								value="${goods.goods_category}" /></td>
							<td><input type="button" value="수정반영"
								onClick="fn_modify_goods('${goods.goods_num }','goods_category')" />
							</td>
						</tr>
						<tr>
							<td>상품이름</td>
							<td><input name="goods_name" type="text" size="40"
								value="${goods.goods_name }" /></td>
							<td><input type="button" value="수정반영"
								onClick="fn_modify_goods('${goods.goods_num }','goods_name')" />
							</td>
						</tr>

						<tr>
							<td>제조사</td>
							<td><input name="goods_maker" type="text" size="40"
								value="${goods.goods_maker }" /></td>
							<td><input type="button" value="수정반영"
								onClick="fn_modify_goods('${goods.goods_num }','goods_maker')" />
							</td>

						</tr>
					
					
						<tr>
							<td>상품판매가격</td>
							<td><input name="goods_sales_price" type="text" size="40"
								value="${goods.goods_sales_price }" /></td>
							<td><input type="button" value="수정반영"
								onClick="fn_modify_goods('${goods.goods_num }','goods_sales_price')" />
							</td>

						</tr>


						<tr>
							<td>상품 구매 포인트</td>
							<td><input name="goods_point" type="text" size="40"
								value="${goods.goods_point }" /></td>
							<td><input type="button" value="수정반영"
								onClick="fn_modify_goods('${goods.goods_num }','goods_point')" />
							</td>

						</tr>

						<%-- 				  <input  name="goods_published_date"  type="date"  value="<fmt:formatDate value="${goods.goods_published_date}" pattern="yyyy-MM-dd" />" /> --%>
						<%-- 				 <input  type="button" value="수정반영"  onClick="fn_modify_goods('${goods.goods_num }','goods_published_date')"/> --%>
						<%-- 				<td><input name="goods_total_page" type="text" size="40"  value="${goods.goods_total_page }"/></td> --%>
						<%-- 				 <input  type="button" value="수정반영"  onClick="fn_modify_goods('${goods.goods_num }','goods_total_page')"/> --%>
						<%-- 				<td><input name="goods_isbn" type="text" size="40" value="${goods.goods_isbn }" /></td> --%>
						<%-- 				 <input  type="button" value="수정반영"  onClick="fn_modify_goods('${goods.goods_num }','goods_isbn')"/> --%>
						<tr>
							<td>상품 배송비</td>
							<td><input name="goods_delivery_price" type="text" size="40"
								value="${goods.goods_delivery_price }" /></td>
							<td><input type="button" value="수정반영"
								onClick="fn_modify_goods('${goods.goods_num }','goods_delivery_price')" />
							</td>

						</tr>
						<%-- 				  <input name="goods_delivery_date" type="date"  value="<fmt:formatDate value="${goods.goods_delivery_date}" pattern="yyyy-MM-dd" />" /> --%>
						<%-- 				 <input  type="button" value="수정반영"  onClick="fn_modify_goods('${goods.goods_num }','goods_delivery_date')"/> --%>
						<td>상품 재고 수량</td>
						<td><input name="goods_stock" type="text" size="40"
							value="${goods.goods_stock}" /></td>
						<td><input type="button" value="수정반영"
							onClick="fn_modify_goods('${goods.goods_num }','goods_stock')" />
						</td>
						</tr>

						<tr>
							<td>상품종류</td>
							<td><select name="goods_status">
									<option value="bestseller">베스트셀러</option>
									<option value="steadyseller">스테디셀러</option>
									<option value="newbook">신간</option>
									<option value="on_sale">판매중</option>
									<option value="buy_out">품절</option>
									<option value="out_of_print">절판</option>
							</select> <input type="hidden" name="h_goods_status"
								value="${goods.goods_status }" /></td>
							<td><input type="button" value="수정반영"
								onClick="fn_modify_goods('${goods.goods_num }','goods_status')" />
							</td>
						</tr>
						<tr>
							<td colspan=3><br></td>
						</tr>
						<tr>
							<td colspan="3" align="center">
								<c:choose>
									<c:when test="${goods.del_yn eq 'Y'}">
										<span style="color: red; font-weight: bold; margin-right: 10px;">(삭제된 상품)</span>
										<input type="button" value="상품 복원" onClick="fn_restore_goods('${goods.goods_num}')"
											style="background-color: #4CAF50; color: white; padding: 10px 20px; border: none; cursor: pointer; font-size: 16px;" />
										<input type="button" value="상품 삭제" onClick="fn_remove_goods('${goods.goods_num}')"
											style="background-color: #ccc; color: white; padding: 10px 20px; border: none; cursor: not-allowed; font-size: 16px;" disabled/>
									</c:when>
									<c:otherwise>
										<span style="color: green; font-weight: bold; margin-right: 10px;">(판매중)</span>
										<input type="button" value="상품 삭제" onClick="fn_remove_goods('${goods.goods_num}')"
											style="background-color: #f44336; color: white; padding: 10px 20px; border: none; cursor: pointer; font-size: 16px;" />
										<input type="button" value="상품 복원" onClick="fn_restore_goods('${goods.goods_num}')"
											style="background-color: #ccc; color: white; padding: 10px 20px; border: none; cursor: not-allowed; font-size: 16px;" disabled/>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</table>
				</DIV>










				<DIV class="tab_content" id="tab3">
					<H4>상품 제조사 소개</H4>
					<P>
					<table>
						<tr>
							<td>상품 제조사 소개</td>
							<td><textarea rows="100" cols="80"
									name="goods_goods_writer_intro">
						  ${goods.goods_goods_writer_intro }
						</textarea></td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp; <input type="button"
								value="수정반영"
								onClick="fn_modify_goods('${goods.goods_num }','goods_goods_writer_intro')" />
							</td>
						</tr>
					</table>
					</P>
				</DIV>

				<DIV class="tab_content" id="tab4">
					<H4>상품 소개</H4>
					<P>
					<table>
						<tr>
							<td>상품 소개</td>
							<td><textarea rows="100" cols="80" name="">
						  ${goods.goods_contents_order }
						</textarea></td>
							<td>&nbsp;&nbsp;&nbsp;&nbsp; <input type="button"
								value="수정반영"
								onClick="fn_modify_goods('${goods.goods_num }','goods_contents_order')" />
							</td>
						</tr>
					</table>
					</P>
				</DIV>


				<DIV class="tab_content" id="tab7">
					<form id="FILE_FORM" method="post" enctype="multipart/form-data">
						<h4>상품이미지</h4>
						<table>
							<tr>
								<c:forEach var="item" items="${imageFileList }"
									varStatus="itemNum">
									<c:choose>
										<c:when test="${item.fileType=='main_image' }">
											<tr>
												<td>메인 이미지</td>
												<td><input type="file" id="main_image"
													name="uploadFile"
													onchange="readURL(this,'preview${itemNum.count}');" /> <input
													type="hidden" name="image_id" value="${item.image_id}" />
													<br></td>
												<td><img id="preview${itemNum.count }" width=200
													height=200
													src="${contextPath}/download.do?goods_num=${item.goods_num}&fileName=${item.fileName}" />
												</td>
												<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td><input type="button" value="수정"
													onClick="modifyImageFile('main_image','${item.goods_num}','${item.image_id}','${item.fileType}')" />
												</td>
											</tr>
											<tr>
												<td><br></td>
											</tr>
										</c:when>
										<c:otherwise>
											<tr id="imageTr${item.image_id}">
												<td>상세 이미지${itemNum.count-1 }</td>
												<td><input type="file" name="uploadFile"
													id="detail_image_${item.image_id}"
													onchange="readURL(this,'preview${itemNum.count}');" /> <input
													type="hidden" name="image_id" value="${item.image_id }" />
													<br></td>
												<td><img id="preview${itemNum.count }" width=200
													height=200
													src="${contextPath}/download.do?goods_num=${item.goods_num}&fileName=${item.fileName}">
												</td>
												<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
												<td><input type="button" value="수정"
													onClick="modifyImageFile('detail_image_${item.image_id}','${item.goods_num}','${item.image_id}','${item.fileType}')" />
													<input type="button" value="삭제"
													onClick="deleteImageFile('${item.goods_num}','${item.image_id}','${item.fileName}','imageTr${item.image_id}')" />
												</td>
											</tr>
											<tr>
												<td><br></td>
											</tr>












										</c:otherwise>
									</c:choose>
								</c:forEach>
							<tr align="center">
								<td colspan="3">
									<div id="d_file"></div>
								</td>
							</tr>
							<tr>
								<td align=center colspan=2><input type="button"
									value="이미지파일추가하기" onClick="fn_addFile()" /></td>
							</tr>
						</table>
					</form>
				</DIV>
				<DIV class="clear"></DIV>
	</form>
</body>
</html>