<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>객실 수정</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    /* 추가적인 스타일링 */
    body {
        background-color: #f8f9fa;
    }
    .card-header {
        background-color: #0d6efd;
        color: white;
        font-weight: bold;
    }
</style>
<script>
// 기존 JavaScript 코드는 그대로 사용합니다.
function fn_modify_business_info(attribute, element){
    var value = $(element).closest('.input-group').find('input, select').val();
    
    // AJAX 요청
    $.ajax({
        type : "post",
        async : false,
        url : "${contextPath}/business/modifyroom.do",
        data : {
            attribute : attribute,
            value : value
        },
        success : function(data, textStatus){
            if(data.trim() == 'mod_success'){
                alert("'" + value + "'(으)로 정보를 수정했습니다.");
            }else if(data.trim()=='failed'){
                alert("다시 시도해 주세요.");    
            }
        },
        error: function(xhr, status, error){
            console.error("AJAX Error:", {xhr, status, error});
            alert("에러가 발생했습니다. 개발자 콘솔을 확인해주세요.");
        }
    });
}
</script>
</head>
<body>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-7">
            <div class="card shadow-sm">
                <div class="card-header text-center h4">
                    객실 정보 수정
                </div>
                <div class="card-body p-4">
                    <form name="frm_mod_room" onsubmit="return false;">
                        
                        <div class="mb-3">
                            <label for="room_name" class="form-label">객실 이름</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="room_name" name="room_name" value="${roomInfo.room_name}">
                                <button class="btn btn-outline-primary" type="button" onclick="fn_modify_business_info('room_name', this)">수정</button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="price" class="form-label">가격 (원)</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="price" name="price" value="${roomInfo.price}" min="10000" max="500000" step="1000">
                                <button class="btn btn-outline-primary" type="button" onclick="fn_modify_business_info('price', this)">수정</button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="room_type" class="form-label">객실 타입</label>
                            <div class="input-group">
                                <select class="form-select" id="room_type" name="room_type">
                                    <option value="스탠다드" ${roomInfo.room_type == '스탠다드' ? 'selected' : ''}>스탠다드</option>
                                    <option value="디럭스" ${roomInfo.room_type == '디럭스' ? 'selected' : ''}>디럭스</option>
                                    <option value="스위트" ${roomInfo.room_type == '스위트' ? 'selected' : ''}>스위트</option>
                                </select>
                                <button class="btn btn-outline-primary" type="button" onclick="fn_modify_business_info('room_type', this)">수정</button>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="bed_type" class="form-label">침대 타입</label>
                            <div class="input-group">
                                <select class="form-select" id="bed_type" name="bed_type">
                                    <option value="더블" ${roomInfo.bed_type == '더블' ? 'selected' : ''}>더블</option>
                                    <option value="트윈" ${roomInfo.bed_type == '트윈' ? 'selected' : ''}>트윈</option>
                                    <option value="온돌" ${roomInfo.bed_type == '온돌' ? 'selected' : ''}>온돌</option>
                                </select>
                                <button class="btn btn-outline-primary" type="button" onclick="fn_modify_business_info('bed_type', this)">수정</button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="max_capacity" class="form-label">최대 인원 (명)</label>
                            <div class="input-group">
                                <input type="number" class="form-control" id="max_capacity" name="max_capacity" value="${roomInfo.max_capacity}" min="1">
                                <button class="btn btn-outline-primary" type="button" onclick="fn_modify_business_info('max_capacity', this)">수정</button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="room_size" class="form-label">면적 (m²)</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="room_size" name="room_size" value="${roomInfo.room_size}">
                                <button class="btn btn-outline-primary" type="button" onclick="fn_modify_business_info('room_size', this)">수정</button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="room_description" class="form-label">설명</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="room_description" name="room_description" value="${roomInfo.room_description}">
                                <button class="btn btn-outline-primary" type="button" onclick="fn_modify_business_info('room_description', this)">수정</button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="amenities" class="form-label">편의 시설</label>
                            <div class="input-group">
                                <input type="text" class="form-control" id="amenities" name="amenities" value="${roomInfo.amenities}">
                                <button class="btn btn-outline-primary" type="button" onclick="fn_modify_business_info('amenities', this)">수정</button>
                            </div>
                        </div>

                       <div class="d-grid mt-4">
    <button type="button" class="btn btn-secondary" onclick="history.back()">
        펜션 관리페이지로 가기
    </button>
</div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.min.js"></script>
</body>
</html>