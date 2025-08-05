<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

<style>
/* 기존 list_view 스타일은 부트스트랩 table 클래스로 대체 가능하여 제거 */
</style>
<script>
function search_member(search_period){	
	var temp=calcPeriod(search_period);
	var date=temp.split(",");
	var beginDate=date[0];
	var endDate=date[1];
	
	var formObj=document.createElement("form");
    
	var formObj=document.createElement("form");
	var i_beginDate = document.createElement("input"); 
	var i_endDate = document.createElement("input");
    
	i_beginDate.name="beginDate";
	i_beginDate.value=beginDate;
	i_endDate.name="endDate";
	i_endDate.value=endDate;
	
    formObj.appendChild(i_beginDate);
    formObj.appendChild(i_endDate);
    document.body.appendChild(formObj); 
    formObj.method="get";
    formObj.action="/petmillie23/admin/member/adminMemberMain.do";
    formObj.submit();
}


function  calcPeriod(search_period){
	var dt = new Date();
	var beginYear,endYear;
	var beginMonth,endMonth;
	var beginDay,endDay;
	var beginDate,endDate;
	
	endYear = dt.getFullYear();
	endMonth = dt.getMonth()+1;
	endDay = dt.getDate();
	if(search_period=='today'){
		beginYear=endYear;
		beginMonth=endMonth;
		beginDay=endDay;
	}else if(search_period=='one_week'){
		var newDt = new Date(dt.setDate(dt.getDate() - 7));
		beginYear = newDt.getFullYear();
		beginMonth = newDt.getMonth() + 1;
		beginDay = newDt.getDate();
	}else if(search_period=='two_week'){
		var newDt = new Date(dt.setDate(dt.getDate() - 14));
		beginYear = newDt.getFullYear();
		beginMonth = newDt.getMonth() + 1;
		beginDay = newDt.getDate();
	}else if(search_period=='one_month'){
		var newDt = new Date(dt.setMonth(dt.getMonth() - 1));
		beginYear = newDt.getFullYear();
		beginMonth = newDt.getMonth() + 1;
		beginDay = newDt.getDate();
	}else if(search_period=='two_month'){
		var newDt = new Date(dt.setMonth(dt.getMonth() - 2));
		beginYear = newDt.getFullYear();
		beginMonth = newDt.getMonth() + 1;
		beginDay = newDt.getDate();
	}else if(search_period=='three_month'){
		var newDt = new Date(dt.setMonth(dt.getMonth() - 3));
		beginYear = newDt.getFullYear();
		beginMonth = newDt.getMonth() + 1;
		beginDay = newDt.getDate();
	}else if(search_period=='four_month'){
		var newDt = new Date(dt.setMonth(dt.getMonth() - 4));
		beginYear = newDt.getFullYear();
		beginMonth = newDt.getMonth() + 1;
		beginDay = newDt.getDate();
	}
	
	if(beginMonth <10){
		beginMonth='0'+beginMonth;
	}
	if(beginDay<10){
		beginDay='0'+beginDay;
	}
	if(endMonth <10){
		endMonth='0'+endMonth;
	}
	if(endDay<10){
		endDay='0'+endDay;
	}
	endDate=endYear+'-'+endMonth +'-'+endDay;
	beginDate=beginYear+'-'+beginMonth +'-'+beginDay;
	return beginDate+","+endDate;
}



function fn_member_detail(member_id){
	var formObj=document.createElement("form");
	var i_member_id = document.createElement("input");
	
	i_member_id.name="member_id";
	i_member_id.value=member_id;
	
    formObj.appendChild(i_member_id);
    document.body.appendChild(formObj); 
    formObj.method="post";
    formObj.action="/petmillie23/admin/member/memberDetail.do";
    formObj.submit();
	
}


function fn_enable_detail_search(r_search){
	var frm_delivery_list=document.frm_delivery_list;
	var t_beginYear=frm_delivery_list.beginYear;
	var t_beginMonth=frm_delivery_list.beginMonth;
	var t_beginDay=frm_delivery_list.beginDay;
	var t_endYear=frm_delivery_list.endYear;
	var t_endMonth=frm_delivery_list.endMonth;
	var t_endDay=frm_delivery_list.endDay;
	var s_search_type=frm_delivery_list.s_search_type;
	var t_search_word=frm_delivery_list.t_search_word;
	var btn_search=frm_delivery_list.btn_search;
	
	if(r_search.value=='detail_search'){
		t_beginYear.disabled=false;
		t_beginMonth.disabled=false;
		t_beginDay.disabled=false;
		t_endYear.disabled=false;
		t_endMonth.disabled=false;
		t_endDay.disabled=false;
		
		s_search_type.disabled=false;
		t_search_word.disabled=false;
		btn_search.disabled=false;
	}else{
		t_beginYear.disabled=true;
		t_beginMonth.disabled=true;
		t_beginDay.disabled=true;
		t_endYear.disabled=true;
		t_endMonth.disabled=true;
		t_endDay.disabled=true;
		
		s_search_type.disabled=true;
		t_search_word.disabled=true;
		btn_search.disabled=true;
	}
		
}

//상세조회 버튼 클릭 시 수행
function fn_detail_search(){
	var frm_delivery_list=document.frm_delivery_list;
	
	var beginYear=frm_delivery_list.beginYear.value;
	var beginMonth=frm_delivery_list.beginMonth.value;
	var beginDay=frm_delivery_list.beginDay.value;
	var endYear=frm_delivery_list.endYear.value;
	var endMonth=frm_delivery_list.endMonth.value;
	var endDay=frm_delivery_list.endDay.value;
	var search_type=frm_delivery_list.s_search_type.value;
	var search_word=frm_delivery_list.t_search_word.value;

	var formObj=document.createElement("form");
	var i_beginDate = document.createElement("input"); 
	var i_endDate = document.createElement("input");
	var i_search_type = document.createElement("input");
	var i_search_word = document.createElement("input");
    
    i_beginDate.name="beginDate";
    i_endDate.name="endDate";
    i_search_type.name="search_type";
    i_search_word.name="search_word";
    
	i_beginDate.value=beginYear+"-"+beginMonth+"-"+beginDay;
    i_endDate.value=endYear+"-"+endMonth+"-"+endDay;
    i_search_type.value=search_type;
    i_search_word.value=search_word;
	
    formObj.appendChild(i_beginDate);
    formObj.appendChild(i_endDate);
    formObj.appendChild(i_search_type);
    formObj.appendChild(i_search_word);
    document.body.appendChild(formObj); 
    formObj.method="get";
    formObj.action="/petmillie23/admin/member/adminMemberMain.do";
    formObj.submit();
	
}
</script>
</head>
<body>
<div class="container text-center mt-5 mb-3">
	<h3 class="mb-4">회원 조회</h3>
	<form name="frm_delivery_list" >	
		<div class="row justify-content-center">
			<div class="col-md-12">
				<div class="bg-light p-4 rounded">
					<div class="d-flex align-items-center mb-3">
						<div class="form-check me-3">
							<input class="form-check-input" type="radio" name="r_search_option" value="simple_search" checked onClick="fn_enable_detail_search(this)" id="simpleSearch">
							<label class="form-check-label" for="simpleSearch">간단조회</label>
						</div>
						<div class="form-check">
							<input class="form-check-input" type="radio" name="r_search_option" value="detail_search"  onClick="fn_enable_detail_search(this)" id="detailSearch">
							<label class="form-check-label" for="detailSearch">상세조회</label>
						</div>
					</div>
					
					<div class="d-flex flex-wrap align-items-center mb-3">
					  <select name="curYear" class="form-select d-inline-block w-auto me-1">
					     <c:forEach   var="i" begin="0" end="5">
					        <option value="${endYear-i }" <c:if test="${endYear == endYear-i}">selected</c:if>>${endYear-i }</option>
					    </c:forEach>
					</select>년
					<select name="curMonth" class="form-select d-inline-block w-auto me-1">
						 <c:forEach   var="i" begin="1" end="12">
					        <option value="${i }" <c:if test="${endMonth == i}">selected</c:if>>${i }</option>
					    </c:forEach>					
					</select>월
					
					 <select name="curDay" class="form-select d-inline-block w-auto me-1">
					  <c:forEach   var="i" begin="1" end="31">
					        <option value="${i }" <c:if test="${endDay == i}">selected</c:if>>${i }</option>
					    </c:forEach>	
					</select>일  &nbsp;이전&nbsp;
					<div class="btn-group" role="group">
						<a href="javascript:search_member('today')" class="btn btn-sm btn-outline-secondary">오늘</a>
						<a href="javascript:search_member('one_week')" class="btn btn-sm btn-outline-secondary">1주</a>
						<a href="javascript:search_member('two_week')" class="btn btn-sm btn-outline-secondary">2주</a>
						<a href="javascript:search_member('one_month')" class="btn btn-sm btn-outline-secondary">1개월</a>
						<a href="javascript:search_member('two_month')" class="btn btn-sm btn-outline-secondary">2개월</a>
						<a href="javascript:search_member('three_month')" class="btn btn-sm btn-outline-secondary">3개월</a>
						<a href="javascript:search_member('four_month')" class="btn btn-sm btn-outline-secondary">4개월</a>
					</div>
					 &nbsp;까지 조회
					</div>
					
					<div class="d-flex flex-wrap align-items-center mb-3">
						<span class="me-2">조회 기간:</span>
						<select name="beginYear" class="form-select d-inline-block w-auto me-1" disabled>
						 <c:forEach   var="i" begin="0" end="5">
						    <option value="${endYear-i }" <c:if test="${beginYear == endYear-i}">selected</c:if>>${endYear-i }</option>
						</c:forEach>
						</select>년 
						<select name="beginMonth" class="form-select d-inline-block w-auto me-1" disabled >
							<c:forEach var="i" begin="1" end="12">
						    	<option value="${i < 10 ? '0' : ''}${i }" <c:if test="${beginMonth == i}">selected</c:if>>${i < 10 ? '0' : ''}${i }</option>
							</c:forEach>					
						</select>월
						 <select name="beginDay" class="form-select d-inline-block w-auto me-1" disabled >
						  <c:forEach   var="i" begin="1" end="31">
						    	<option value="${i < 10 ? '0' : ''}${i }" <c:if test="${beginDay == i}">selected</c:if>>${i < 10 ? '0' : ''}${i }</option>
						</c:forEach>	
						</select>일  ~
						
						<select name="endYear" class="form-select d-inline-block w-auto mx-1" disabled >
						 <c:forEach   var="i" begin="0" end="5">
						    <option value="${endYear-i }" <c:if test="${endYear == endYear-i}">selected</c:if>>${endYear-i }</option>
						</c:forEach>
						</select>년 
						<select name="endMonth" class="form-select d-inline-block w-auto me-1" disabled >
							 <c:forEach   var="i" begin="1" end="12">
						    	<option value="${i < 10 ? '0' : ''}${i }" <c:if test="${endMonth == i}">selected</c:if>>${i < 10 ? '0' : ''}${i }</option>
							</c:forEach>					
						</select>월
						 <select name="endDay" class="form-select d-inline-block w-auto me-1" disabled >
						  <c:forEach   var="i" begin="1" end="31">
						    	<option value="${i < 10 ? '0' : ''}${i }" <c:if test="${endDay == i}">selected</c:if>>${i < 10 ? '0' : ''}${i }</option>
						</c:forEach>	
						</select>일
					</div>
					
					<div class="d-flex align-items-center">
						<select name="s_search_type" class="form-select d-inline-block w-auto me-2" disabled >
							<option value="all" checked>전체</option>
							<option value="member_name">회원이름</option>
							<option value="member_id">회원아이디</option>
							<option value="member_tel">회원휴대폰번호</option>
							<option value="member_addr">회원주소</option>
						</select>
						<input  type="text"  name="t_search_word" class="form-control d-inline-block me-2" disabled />  
						<input   type="button"  value="조회" name="btn_search" class="btn btn-primary" onClick="fn_detail_search()" disabled  />
					</div>
				</div>
			</div>
		</div>
	</form>   
	
	<div class="row mt-4">
		<div class="col-md-12">
			<table class="table table-bordered table-hover">
				<thead class="text-center">
					<tr>
						<th>회원아이디</th>
						<th>회원이름</th>
						<th>휴대폰번호</th>
						<th>이메일</th>
						<th>주소</th>
						<th>가입일</th>
						<th>탈퇴여부</th>
					</tr>
				</thead>
				<tbody class="text-center">
					<c:choose>
						<c:when test="${empty member_list}">			
							<tr>
								<td colspan="7">
									<strong>조회된 회원이 없습니다.</strong>
								</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="item" items="${member_list}" varStatus="item_num">
								<tr>       
									<td>
										<a href="javascript:fn_member_detail('${item.member_id}')">
											<strong>${item.member_id}</strong>
										</a>
									</td>
									<td>
										<strong>${item.member_name}</strong>
									</td>
									<td>
										<strong>${item.tel1}-${item.tel2}-${item.tel3}</strong>
									</td>
									<td>
										<strong>${item.email1}@${item.email2}</strong>
									</td>
									<td>
										<strong>[${item.zipcode}] ${item.roadAddress} ${item.namujiAddress}</strong>
									</td>
									<td>
										<c:set var="member_join" value="${item.member_join}" />
										<c:set var="arr" value="${fn:split(member_join,' ')}" />
										<strong><c:out value="${arr[0]}" /></strong>
									</td>
									<td>
										<c:choose>
											<c:when test="${item.del_yn == 'N' }">
												<span class="badge bg-success">활동중</span>  
											</c:when>
											<c:otherwise>
												<span class="badge bg-danger">탈퇴</span>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>	
				</tbody>
			</table>
		</div>
	</div>

	<div class="row mt-4">
		<div class="col-md-12 d-flex justify-content-center">
			<nav>
				<ul class="pagination">
					<c:if test="${not empty member_list}">
						<c:if test="${chapter > 1}">
							<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/admin/member/adminMemberMain.do?chapter=${chapter-1}&pageNum=${(chapter-1)*10 + 1 }">Previous</a></li>
						</c:if>
						<c:forEach var="page" begin="1" end="10" step="1">
							<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/admin/member/adminMemberMain.do?chapter=${chapter}&pageNum=${page}">${(chapter-1)*10 + page }</a></li>
						</c:forEach>
						<c:if test="${page == 10}">
							<li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/admin/member/adminMemberMain.do?chapter=${chapter+1}&pageNum=${chapter*10+1}">Next</a></li>
						</c:if>
					</c:if>
				</ul>
			</nav>
		</div>
	</div>
</div>
</body>
</html>