<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="com.petmillie.board.vo.BoardVO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<c:forEach var="comment" items="${commentList}">
	<c:choose>
		<c:when test="${sessionScope.memberInfo.member_id == comment.member_id}">		
		    <div id="comment_box_${comment.comment_id}" class="comment_box">
				<div class="comment_up_del">
					<input type="button" onclick="comment_updateForm(${comment.comment_id})" value="수정" class="ct_btn update_btn">
					<input type="button" onclick="comment_delete(${comment.comment_id})" value="삭제" class="ct_btn del_btn">
				</div>
				<div class="comment row">
					<span class="col-1 commenter">${comment.member_id}</span>
					<span class="col comment_txt">${comment.comment_content}</span>
				</div>
			</div>
		</c:when>
		<c:otherwise>
		    <div id="comment_box_${comment.comment_id}" class="comment_box">
				<div class="comment row">
					<span class="col-1 commenter">${comment.member_id}</span>
					<span class="col comment_txt">${comment.comment_content}</span>
				</div>
			</div>
		</c:otherwise>
	</c:choose>
</c:forEach>
