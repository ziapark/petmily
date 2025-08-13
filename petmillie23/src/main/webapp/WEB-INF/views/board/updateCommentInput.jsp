<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="com.petmillie.board.vo.BoardVO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />


<div class="comment_up_del  ">
	<input type="button" onclick="comment_update(${vo.comment_id}, ${vo.comu_id})" value="수정" class="ct_btn update_btn">
</div>
<div class="comment row">
	<span class="col-1 commenter">${vo.member_id}</span>
	<span class="col comment_txt">
		<textarea class="update_comment_content">${vo.comment_content}</textarea>
	</span>
</div>

