<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="com.petmillie.board.vo.BoardVO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta charset="utf-8">
<title>펫밀리</title>
<link rel="stylesheet" href="css/common.css">
<script src="js/validation.js"></script>
<script>
  $(document).ready(function() {
    var comu_id = "${param.num}"; // 또는 모델에서 뿌려준 값
    loadCommentList(comu_id);
  });
</script>
</head>
<body>
	<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold">커뮤니티</h2>
			<p></p>	
		</div>
	</div>
	<div class="row row-cols-1">
		<!-- 게시글 출력 -->
	    <div class="row">
		    <div class="col tar"><span>글쓴이:&nbsp;</span>${vo.member_id}&nbsp;<span>작성일:&nbsp;</span>${vo.reg_date}&nbsp;<span>조회수:&nbsp;</span>${vo.views}</div>	   
    	</div>
    	<div class="row">
		    <div class="alert alert-light fw-bold" style="text-align:left; font-size: 1.2em;">${vo.subject}</div>
	    </div>
    	<div class="row">
    		<div class="contents_box" style="text-align:left;">
    			<c:if test="${not empty vo.file_name}">
				  <div class="imgbox">
				  	<!-- FileDownloadController에  /board/image.do 맵핑있음 -->
				    <img src="${contextPath}/board/image.do?fileName=${vo.file_name}&comu_id=${vo.comu_id}" />
				  </div>
				</c:if>
	  			${vo.content}
	  		</div>
    	</div>
    	
    	<div class="comment_wrap row">
    		<!-- 좋아요 -->
    		<div id="like" class="${liked ? 'like_on' : 'like_off'}">
			    <input type="button" onclick="like(${vo.comu_id})" id="likeBtn" value="좋아요"><span id="likeCount" >${likeCount}</span>
			</div>
    		<!-- 댓글영역 -->
    		<div id="commentListArea" class="commentlist_box"></div>
			<!-- 댓글입력영역 -->
    		<div class="textarea_box">
    			<form id="frmComment" action="${pageContext.request.contextPath}/commentReg.do" method="post">
				    <input type="hidden" id="comu_id" name="comu_id" value="${vo.comu_id}">
				    <textarea id="textareaWord" name="comment_content" placeholder="댓글 입력란입니다."></textarea>
				    <div class="btn_box">
				        <input type="button" onclick="comment_reg()" class="btn btn-sm btn-primary" value="등록"/>
				    </div>
				</form>
    		</div>
    	</div>
    	<!-- 하단 버튼부 -->
		<div style="padding-top:10px;">
		    <a href="#" class="btn btn-sm btn-secondary">이전</a>
		
		    <c:if test="${vo.member_id == sessionScope.memberInfo.member_id}">
		        <a href="${contextPath}/board/updateForm.do?num=${vo.comu_id}&board_type=${param.board_type}" class="btn btn-sm btn-primary">수정</a>
		        <a href="${contextPath}/board/delete.do?num=${vo.comu_id}" class="btn btn-sm btn-danger">삭제</a>
		    </c:if>
		</div>
    	
   	</div>
</div>

<script type="text/javascript">
	
//댓글등록	
function comment_reg() {
    var sessionId = "${sessionScope.memberInfo.member_id}";
    if (sessionId == null || sessionId === "") {
        alert("로그인 후 이용해 주세요.");
        location.href = "${pageContext.request.contextPath}/member/loginForm.do";
        return;
    }

    var content = document.getElementById("textareaWord").value.trim();
    var comu_id = document.getElementById("comu_id").value;

    if (content === "") {
        alert("댓글 내용을 입력하세요.");
        return;
    }

    // AJAX 요청
    $.ajax({
        url: "${pageContext.request.contextPath}/board/commentReg.do",
        type: "POST",
        data: {
            comu_id: comu_id,
            textareaWord: content
        },
        success: function(response) {
      	
            // 등록 성공 후 댓글리스트 다시 불러오기
            loadCommentList(comu_id);
            // 입력창 초기화
            document.getElementById("textareaWord").value = "";
        },
        error: function() {
            alert("댓글 등록 실패");
        }
    });
}

// 댓글 삭제
function comment_delete(comment_id) {
    var sessionId = "${sessionScope.memberInfo.member_id}";
    if (sessionId === null || sessionId === "") {
        alert("로그인 후 이용해 주세요.");
        location.href = "${pageContext.request.contextPath}/member/loginForm.do";
        return;
    }

    
    var comu_id = document.getElementById("comu_id").value;

    // AJAX 요청
    $.ajax({
        url: "${pageContext.request.contextPath}/board/commentDelete.do",
        type: "POST",
        data: {comment_id: comment_id},
        success: function(response) {
      		if(response === "success"){
      		  // 삭제 성공 후 댓글리스트 다시 불러오기
                loadCommentList(comu_id);
      		}else{
      			alert("댓글 삭제 실패");
      		}
          
           
        },
        error: function() {
            alert("댓글 삭제 오류");
        }
    });
}
//댓글수정 1 - 댓글수정창 열기
function comment_updateForm(comment_id) {
	//기존 댓글내용 

    $.ajax({
        url: "${pageContext.request.contextPath}/board/updateCommentInput.do",
        type: "GET",
        data: { comment_id: comment_id },
        success: function(data) {
        	
        	 $("#comment_box_" + comment_id).html(data); 
			
        },
        error: function() {
            alert("댓글 수정창 열기 에러");
        }
    });
}
//댓글수정 2 - 댓글수정
function comment_update(comment_id,comu_id) {

	var content = $(".update_comment_content").val().trim();
	
    if (content === "") {
        alert("댓글 내용을 입력하세요.");
        return;
    }
    $.ajax({
        url: "${pageContext.request.contextPath}/board/commentUpdate.do",
        type: "GET",
        data: { comment_id: comment_id ,
        		content: content },
        success: function(response) {
        	
        	if(response === "success"){
        		  // 수정 성공 후 댓글리스트 다시 불러오기
                  loadCommentList(comu_id);
        		}else{
        			alert("댓글 수정 실패");
        		}

        },
        error: function() {
            alert("댓글 수정 에러");
        }
    });
}

function loadCommentList(comu_id) {
    $.ajax({
        url: "${pageContext.request.contextPath}/board/commentList.do",
        type: "GET",
        data: { comu_id: comu_id },
        success: function(data) {
        	
            $("#commentListArea").html(data);  // 서버에서 댓글 리스트 HTML로 받아와서 넣기
           
        },
        error: function() {
            alert("댓글 목록 불러오기 실패!");
        }
    });
}


// 좋아요
function like(comu_id) {
    var sessionId = "${sessionScope.memberInfo.member_id}";
    if (sessionId === null || sessionId === "") {
        alert("게시글 '좋아요'는 로그인 후 이용가능합니다.");
        return;
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/board/like.do",
        type: "POST", // ← 가능하면 POST로 바꾸는 게 좋아
        dataType: "json",
        data: { comu_id: comu_id },
        success: function(response) {
        	console.log("response.liked = ", response.liked);
            if (response.status === "unauthorized") {
                alert("로그인 후 이용가능합니다.");
                return;
            }

            // 좋아요 버튼 상태 업데이트
         
            if (response.liked) {
            	$("#like").removeClass("like_off").addClass("like_on");
            } else {
            	$("#like").removeClass("like_on").addClass("like_off");
            }

            // 좋아요 수 즉시 반영
            $("#likeCount").text(response.likeCount);
        },
        error: function() {
        	 console.error("AJAX error:", textStatus, errorThrown);
            alert("좋아요 에러");
        }
    });
}

</script>
</body>
</html>