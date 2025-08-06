<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"
    %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"/>

<script type="text/javascript">
	var loopSearch=true;
	function keywordSearch(){
		if(loopSearch==false)
			return;
	 var value=document.frmSearch.searchWord.value;
		$.ajax({
			type : "get",
			async : true, //false인 경우 동기식으로 처리한다.
			url : "${contextPath}/goods/keywordSearch.do",
			data : {keyword:value},
			success : function(data, textStatus) {
			    var jsonInfo = JSON.parse(data);
				displayResult(jsonInfo);
			},
			error : function(data, textStatus) {
				alert("에러가 발생했습니다."+data);
			},
			complete : function(data, textStatus) {
				//alert("작업을완료 했습니다");
				
			}
		}); //end ajax	
	}
	
	function displayResult(jsonInfo){
		var count = jsonInfo.keyword.length;
		if(count > 0) {
		    var html = '';
		    for(var i in jsonInfo.keyword){
			   html += "<a href=\"javascript:select('"+jsonInfo.keyword[i]+"')\">"+jsonInfo.keyword[i]+"</a><br/>";
		    }
		    var listView = document.getElementById("suggestList");
		    listView.innerHTML = html;
		    show('suggest');
		}else{
		    hide('suggest');
		} 
	}
	
	function select(selectedKeyword) {
		 document.frmSearch.searchWord.value=selectedKeyword;
		 loopSearch = false;
		 hide('suggest');
	}
		
	function show(elementId) {
		 var element = document.getElementById(elementId);
		 if(element) {
		  element.style.display = 'block';
		 }
		}
	
	function hide(elementId){
	   var element = document.getElementById(elementId);
	   if(element){
		  element.style.display = 'none';
	   }
	}

</script>
<body>
<div class="header_wrap">
	<div id="logo">
	<a href="${contextPath}/main/main.do">
		<img alt="petmily" src="${contextPath}/resources/image/logo.png">
		</a>
	</div>
	<div id="head_link">
		<ul>
		   <c:choose>
		     <c:when test="${isLogOn==true and not empty memberInfo}">
			   <li><a href="${contextPath}/member/logout.do" class="btn-sm btn btn-outline-dark">로그아웃</a></li>
			   <li><a href="${contextPath}/mypage/myPageMain.do" class="btn-sm btn btn-outline-dark">마이페이지</a></li>
			   <li><a href="${contextPath}/cart/myCartList.do" class="btn-sm btn btn-outline-dark">장바구니</a></li>
			   <li><a href="#" class="btn-sm btn btn-outline-dark">주문배송</a></li>
			   <li><a href="#" class="btn-sm btn btn-outline-dark">고객센터</a></li>
			 </c:when>
			 <c:when test="${isLogOn==true and not empty businessInfo}">
			   <li><a href="${contextPath}/member/logout.do" class="btn-sm btn btn-outline-dark">로그아웃</a></li>
			 </c:when>
			 <c:otherwise>
			   <li><a href="${contextPath}/member/loginForm.do" class="btn-sm btn btn-outline-dark">로그인</a></li>
			   <li><a href="${contextPath}/member/memberForm.do" class="btn-sm btn btn-outline-dark">회원가입</a></li>
			   <li><a href="${contextPath}/business/loginForm.do" class="btn-sm btn btn-outline-dark">사업자 로그인</a></li>
			   <li><a href="${contextPath}/business/businessForm.do" class="btn-sm btn btn-outline-dark">사업자 회원가입</a></li>
			 </c:otherwise>
			</c:choose>	  
		</ul>
	</div>
	<div class="clear"></div>
	<div id="search" >
		<form name="frmSearch" action="${contextPath}/goods/searchGoods.do" >
			<input name="searchWord" class="form-control search_input" type="text"  onKeyUp="keywordSearch()" placeholder="검색어를 입력하세요"> 
			<input type="submit" name="search" class="btn-primary btn-sm"  value="검색" >
		</form>
	</div>
   <div id="suggest">
        <div id="suggestList"></div>
   </div>
</div>
<div class="nav-area" style="position:relative; clear:both;">
	<div class="nav_inner">
		<ul class="gnb">
		  <li><a href="#">식품</a></li>
		  <li><a href="#">장난감</a></li>
		  <li><a href="#">목욕/위생</a></li>
		  <li><a href="#">산책용품</a></li>
		  <li><a href="#">추가하셈</a></li>
		  
		  <c:choose>
			<c:when test="${isLogOn==true and memberInfo.member_id =='admin' }">
				<li><a href="#">관리자</a></li>
			</c:when>
			<c:when test="${isLogOn==true and not empty memberInfo}">
			  <li><a href="#">나의 주문</a></li>
			  <li><a href="#">마이페이지</a></li>
			</c:when>
			<c:when test="${not empty businessInfo}">
  				<li><a href="${contextPath}/business/mypension.do?business_id=${businessInfo.business_id}">사업자</a></li>
			</c:when>
			</c:choose>
		  <li><a href="${contextPath}/board/boardList.do?board_type=notice">커뮤니티</a></li>
		</ul>
		
		<div class="submenu-wrap">
			<ul class="submenu">
			    <li><a href="${contextPath}/goods/goodsList.do"">식품3-1</a></li>
			    <li><a href="#">식품3-2</a></li>
			    <li><a href="#">식품3-3</a></li>
			  </ul>
			  <ul class="submenu">
			    <li><a href="#">장난감3-1</a></li>
			    <li><a href="#">장난감-2</a></li>
			    <li><a href="#">장난감3-3</a></li>
			  </ul>
			  <ul class="submenu">
			    <li><a href="#">목욕/위생3-1</a></li>
			    <li><a href="#">목욕/위생3-2</a></li>
			    <li><a href="#">목욕/위생3-3</a></li>
			  </ul>
			  <ul class="submenu">
			    <li><a href="#">산책용품생3-1</a></li>
			    <li><a href="#">산책용품생3-2</a></li>
			    <li><a href="#">산책용품생3-3</a></li>
			  </ul>
			  <ul class="submenu">
			    <li><a href="#">추가하셈3-1</a></li>
			    <li><a href="#">추가하셈3-2</a></li>
			    <li><a href="#">추가하셈3-3</a></li>
			  </ul>
			  <c:if test="${empty businessInfo and empty memberInfo }">
			  <ul class="submenu">
			    <li><a href="${contextPath}/board/boardList.do?board_type=notice">공지사항</a></li>
			    <li><a href="${contextPath}/board/boardList.do?board_type=qna">질문게시판</a></li>
			    <li><a href="${contextPath}/board/boardList.do?board_type=comu_dog">커뮤니티:강아지</a></li>
			    <li><a href="${contextPath}/board/boardList.do?board_type=comu_cat">커뮤니티:고양이</a></li>
			  </ul>
			  </c:if>
			  <c:if test="${not empty businessInfo}">
			  <ul class="submenu">
			  	<li><a href="${contextPath}/business/addpensionForm.do">업체 등록</a>
			  	<li><a href="${contextPath}/reservation/reserForm.do">예약 확인</a>
			  	<li><a href="${contextPath}/business/businessDetailInfo.do">사업자 정보관리</a>
			  </ul>
			  	<ul class="submenu">
			    <li><a href="${contextPath}/board/boardList.do?board_type=notice">공지사항</a></li>
			    <li><a href="${contextPath}/board/boardList.do?board_type=qna">질문게시판</a></li>
			    <li><a href="${contextPath}/board/boardList.do?board_type=comu_dog">커뮤니티:강아지</a></li>
			    <li><a href="${contextPath}/board/boardList.do?board_type=comu_cat">커뮤니티:고양이</a></li>
			  </ul>
			  </c:if>
			<c:choose>
			<c:when test="${isLogOn==true and memberInfo.member_id =='admin' }">
				<ul class="submenu">
				<li><a href="${contextPath}/admin/goods/adminGoodsMain.do">상품관리</a></li>
				<li><a href="${contextPath}/admin/order/adminOrderMain.do">주문관리</a></li>
				<li><a href="${contextPath}/admin/member/adminMemberMain.do">회원관리</a></li>
				<li><a href="#">배송관리</a></li>
				<li><a href="#">게시판관리</a></li>
				</ul>
				<ul class="submenu">
			    <li><a href="${contextPath}/board/boardList.do?board_type=notice">공지사항</a></li>
			    <li><a href="${contextPath}/board/boardList.do?board_type=qna">질문게시판</a></li>
			    <li><a href="${contextPath}/board/boardList.do?board_type=comu_dog">커뮤니티:강아지</a></li>
			    <li><a href="${contextPath}/board/boardList.do?board_type=comu_cat">커뮤니티:고양이</a></li>
			  </ul>
			</c:when>
			<c:when test="${isLogOn==true and not empty memberInfo.member_id !='admin' }">
			  <ul class="submenu">
				<li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문내역/배송 조회</a></li>
				<li><a href="#">반품/교환 신청 및 조회</a></li>
				<li><a href="#">취소 주문 내역</a></li>
				<li><a href="#">세금 계산서</a></li>
			</ul>
			  <ul class="submenu">
				<li><a href="${contextPath}/mypage/myDetailInfo.do">회원정보관리</a></li>
				<li><a href="#">나의 주소록</a></li>
				<li><a href="#">개인정보 동의내역</a></li>
				<li><a href="${contextPath}/member/deleteForm.do">회원탈퇴</a></li>
			</ul>
			<ul class="submenu">
			    <li><a href="${contextPath}/board/boardList.do?board_type=notice">공지사항</a></li>
			    <li><a href="${contextPath}/board/boardList.do?board_type=qna">질문게시판</a></li>
			    <li><a href="${contextPath}/board/boardList.do?board_type=comu_dog">커뮤니티:강아지</a></li>
			    <li><a href="${contextPath}/board/boardList.do?board_type=comu_cat">커뮤니티:고양이</a></li>
			  </ul>
			</c:when>
			</c:choose>

		</div>
	
	
	</div>
	
</div>

</body>
</html>