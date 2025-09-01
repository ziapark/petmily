<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:choose>
    <c:when test="${not empty roomList}">
        <c:forEach var="room" items="${roomList}">
            <div class="col">
                <div class="card h-100 shadow-sm">
                    <img src="${contextPath}/roomImage.do?fileName=${room.fileName}" class="card-img-top" alt="객실 이미지" style="height: 200px; object-fit: cover;">
                    <div class="card-body">
                        <h5 class="card-title">${room.room_name}</h5>
                        <p class="card-text mb-1">
                            <strong>상태:</strong> 
                            <c:choose>
                                <c:when test="${room.room_status == '예약가능'}"><span style="color: green; font-weight: bold;">${room.room_status}</span></c:when>
                                <c:when test="${room.room_status == '삭제됨'}"><span style="color: gray; font-weight: bold;">${room.room_status}</span></c:when>
                                <c:otherwise><span style="color: red; font-weight: bold;">${room.room_status}</span></c:otherwise>
                            </c:choose>
                        </p>
                        <p class="card-text mb-1"><strong>가격:</strong> <fmt:formatNumber value="${room.price}" pattern="#,###" />원</p>
                        <p class="card-text mb-1"><strong>타입:</strong> ${room.room_type} / ${room.bed_type}</p>
                        <p class="card-text mb-1"><strong>인원:</strong> 최대 ${room.max_capacity}명 / ${room.room_size}㎡</p>
                        <p class="card-text mb-1"><strong>편의시설:</strong> ${room.amenities}</p>
                    </div>
                    <div class="card-footer bg-white border-top-0 d-flex justify-content-end gap-2">
                        <c:choose>
                            <c:when test="${room.room_status == '삭제됨'}">
                                <button type="button" class="btn btn-sm btn-success room-action-btn" data-action="restore" data-roomid="${room.room_id}">복구</button>
                            </c:when>
                            <c:otherwise>
                                <a href="${contextPath}/business/roomdetailInfo.do?room_id=${room.room_id}" class="btn btn-sm btn-outline-primary">수정</a>
                                <button type="button" class="btn btn-sm btn-outline-danger room-action-btn" data-action="delete" data-roomid="${room.room_id}">삭제</button>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:when>
    <c:otherwise>
        <div class="col">
            <p class="text-muted">이 펜션에는 등록된 객실이 없습니다.</p>
        </div>
    </c:otherwise>
</c:choose>
