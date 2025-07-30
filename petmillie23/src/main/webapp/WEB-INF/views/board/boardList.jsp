<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.petmillie.board.vo.BoardVO"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<%
    Integer total_record_obj = (Integer) request.getAttribute("total_record");
    int total_record = (total_record_obj != null) ? total_record_obj.intValue() : 0;

    Integer pageNum_obj = (Integer) request.getAttribute("pageNum");
    int pageNum = (pageNum_obj != null) ? pageNum_obj.intValue() : 1;

    Integer total_page_obj = (Integer) request.getAttribute("total_page");
    int total_page = (total_page_obj != null) ? total_page_obj.intValue() : 1;
%>
<%
	String sessionId = (String) session.getAttribute("sessionId");

%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.6/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-4Q6Gf2aSP4eDXB8Miphtr37CMZZQ5oXLH2yaXMJ2w8e2ZtHTl7GptT4jmndRuHDT" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<meta charset="utf-8">
<link rel="stylesheet" href="css/basic.css">

<title>펫밀리</title>
<script type="text/javascript">
	function checkForm() {	
	var sessionId = "${sessionScope.memberInfo.member_id}"; 
  
    if (sessionId == null || sessionId == "") {
        alert("로그인 해주세요");
        return false;
    }

    location.href = "${contextPath}/board/writeForm.do?id=" + sessionId;
}
</script>
</head>
<body>
  <div class="container text-center mt-3 mb-3">
  	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold">게시판rpt</h2>
			<p>게시판입니다.</p>	
		</div>
	</div>
	<div class="row row-cols-1">
	<form action="${contextPath}/boardList.do" method="get">

		<div class="text-end"> 
			<span class="badge text-bg-success" style="padding:10px;">전체 <%=total_record%>건	</span>
		</div>
	
		<div style="padding-top: 20px">
			<table class="table table-hover text-center">
				<tr>
					<th>번호</th>
					<th>제목</th>
					<th>작성일</th>
					<th>조회</th>
					<th>글쓴이</th>
				</tr>

				<%
				    List<BoardVO> boardList = (List<BoardVO>) request.getAttribute("boardList");
				    if (boardList == null) {
				        boardList = new ArrayList<>(); // null 방지용 빈 리스트 초기화
				    }
					for (int j = 0; j < boardList.size() ; j++){
						
						BoardVO notice = (BoardVO) boardList.get(j);
				%>
				<tr>
					<td><%=notice.getComu_id()%></td>
					<td><a href="${contextPath}/board/view.do?num=<%=notice.getComu_id()%>&page=<%=pageNum%>"><%=notice.getSubject()%></a></td>
					<td><%=notice.getReg_date()%></td>
					<td><%=notice.getViews()%></td>
					<td><%=notice.getMember_id()%></td>
				</tr>
				<%
					}
				%>
			</table>
		</div>
		<div align="center">
			<c:set var="currentPage" value="<%=pageNum%>" />
			<c:forEach var="i" begin="1" end="<%=total_page%>">
				<a href="<c:url value="boardList.do?pageNum=${i}" /> ">
					<c:choose>
						<c:when test="${currentPage==i}">
							<font color='4C5317'><b style="color:#0d6efd;"> [${i}]</b></font>
						</c:when>
						<c:otherwise>
							<font color='4C5317'> [${i}]</font>

						</c:otherwise>
					</c:choose>
				</a>
			</c:forEach>
		</div>
		
		<div class="py-3" align="right">							
			<a href="#" onclick="checkForm(); return false;" class="btn btn-primary">글쓰기</a>				
		</div>			
		<!-- 검색 전용 폼 -->
		<form action="${contextPath}/boardList.do" method="get" class="d-flex justify-content-start align-items-center gap-2">
			<select name="items" class="txt search_select">
				<option value="subject">제목에서</option>
				<option value="content">본문에서</option>
				<option value="member_id">글쓴이에서</option>
			</select>
			<input name="text" type="text" class="search_input"/>
			<input type="submit" class="btn btn-primary btn-sm" value="검색"/>
		</form>
	</form>	
	</div>		
</div>

	
</body>
</html>