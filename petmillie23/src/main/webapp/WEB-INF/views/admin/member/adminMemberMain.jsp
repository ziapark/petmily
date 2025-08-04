<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
	<H3>회원 조회</H3>
	<form name="frm_delivery_list" >	
		<table cellpadding="10" cellspacing="10"  >
			<tbody>
				<tr>
					<td>
						<input type="radio" name="r_search_option" value="simple_search" checked onClick="fn_enable_detail_search(this)"/> 간단조회 &nbsp;&nbsp;&nbsp;
						<input type="radio" name="r_search_option" value="detail_search"  onClick="fn_enable_detail_search(this)" /> 상세조회 &nbsp;&nbsp;&nbsp;
					</td>
				</tr>
				<tr>
					<td>
					  <select name="curYear">
					     <c:forEach   var="i" begin="0" end="5">
					        <option value="${endYear-i }" <c:if test="${endYear == endYear-i}">selected</c:if>>${endYear-i }</option>
					    </c:forEach>
					</select>년 <select name="curMonth" >
						 <c:forEach   var="i" begin="1" end="12">
					        <option value="${i }" <c:if test="${endMonth == i}">selected</c:if>>${i }</option>
					    </c:forEach>					
					</select>월
					
					 <select name="curDay">
					  <c:forEach   var="i" begin="1" end="31">
					        <option value="${i }" <c:if test="${endDay == i}">selected</c:if>>${i }</option>
					    </c:forEach>	
					</select>일  &nbsp;이전&nbsp;&nbsp;&nbsp;&nbsp; 
					<a href="javascript:search_member('today')">
					   <img   src="${pageContext.request.contextPath}/resources/image/btn_search_one_day.jpg">
					</a>
					<a href="javascript:search_member('one_week')">
					   <img   src="${pageContext.request.contextPath}/resources/image/btn_search_1_week.jpg">
					</a>
					<a href="javascript:search_member('two_week')">
					   <img   src="${pageContext.request.contextPath}/resources/image/btn_search_2_week.jpg">
					</a>
					<a href="javascript:search_member('one_month')">
					   <img   src="${pageContext.request.contextPath}/resources/image/btn_search_1_month.jpg">
					</a>
					<a href="javascript:search_member('two_month')">
					   <img   src="${pageContext.request.contextPath}/resources/image/btn_search_2_month.jpg">
					</a>
					<a href="javascript:search_member('three_month')">
					   <img   src="${pageContext.request.contextPath}/resources/image/btn_search_3_month.jpg">
					</a>
					<a href="javascript:search_member('four_month')">
					   <img   src="${pageContext.request.contextPath}/resources/image/btn_search_4_month.jpg">
					</a>
					&nbsp;까지 조회
					</td>
				</tr>
				
				<tr>
				  <td>
					조회 기간:
					<select name="beginYear" disabled>
					 <c:forEach   var="i" begin="0" end="5">
					    <option value="${endYear-i }" <c:if test="${beginYear == endYear-i}">selected</c:if>>${endYear-i }</option>
					</c:forEach>
					</select>년 
					<select name="beginMonth" disabled >
						<c:forEach var="i" begin="1" end="12">
					    	<option value="${i < 10 ? '0' : ''}${i }" <c:if test="${beginMonth == i}">selected</c:if>>${i < 10 ? '0' : ''}${i }</option>
						</c:forEach>					
					</select>월
					 <select name="beginDay" disabled >
					  <c:forEach   var="i" begin="1" end="31">
					    	<option value="${i < 10 ? '0' : ''}${i }" <c:if test="${beginDay == i}">selected</c:if>>${i < 10 ? '0' : ''}${i }</option>
					</c:forEach>	
					</select>일  &nbsp; ~
					
					<select name="endYear" disabled >
					 <c:forEach   var="i" begin="0" end="5">
					    <option value="${endYear-i }" <c:if test="${endYear == endYear-i}">selected</c:if>>${endYear-i }</option>
					</c:forEach>
					</select>년 
					<select name="endMonth" disabled >
						 <c:forEach   var="i" begin="1" end="12">
					    	<option value="${i < 10 ? '0' : ''}${i }" <c:if test="${endMonth == i}">selected</c:if>>${i < 10 ? '0' : ''}${i }</option>
						</c:forEach>					
					</select>월
					 <select name="endDay" disabled >
					  <c:forEach   var="i" begin="1" end="31">
					    	<option value="${i < 10 ? '0' : ''}${i }" <c:if test="${endDay == i}">selected</c:if>>${i < 10 ? '0' : ''}${i }</option>
					</c:forEach>	
					</select>
												 
				  </td>
				</tr>
				<tr>
				  <td>
				    <select name="s_search_type" disabled >
						<option value="all" checked>전체</option>
						<option value="member_name">회원이름</option>
						<option value="member_id">회원아이디</option>
						<option value="member_tel">회원휴대폰번호</option>
						<option value="member_addr">회원주소</option>
					</select>
					<input  type="text"  size="30" name="t_search_word" disabled />  
					<input   type="button"  value="조회" name="btn_search" onClick="fn_detail_search()" disabled  />
				  </td>
				</tr>				
			</tbody>
		</table>
	</form>   
	<div class="clear"></div>
	
	<table class="list_view">
		<colgroup>
			<col style="width: 10%;">
			<col style="width: 10%;">
			<col style="width: 15%;">
			<col style="width: 20%;">
			<col style="width: 35%;">
			<col style="width: 10%;">
			<col style="width: 10%;">
		</colgroup>
		<thead align=center bgcolor="#ffcc00">
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
		<tbody align=center>
			<c:choose>
				<c:when test="${empty member_list}">			
					<tr>
						<td colspan="7" class="fixed">
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
										<strong>활동중</strong>  
									</c:when>
									<c:otherwise>
										<strong>탈퇴</strong>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>	
		</tbody>
	</table>
  	<div class="clear"></div>
	<div id="page_wrap">
		<c:if test="${not empty member_list}">
			<c:forEach var="page" begin="1" end="10" step="1">
				<c:if test="${chapter > 1 && page == 1 }">
					<a href="${pageContext.request.contextPath}/admin/member/adminMemberMain.do?chapter=${chapter-1}&pageNum=${(chapter-1)*10 + 1 }">&nbsp;pre &nbsp;</a>
				</c:if>
				<a href="${pageContext.request.contextPath}/admin/member/adminMemberMain.do?chapter=${chapter}&pageNum=${page}">${(chapter-1)*10 + page } </a>
				<c:if test="${page == 10 }">
					<a href="${pageContext.request.contextPath}/admin/member/adminMemberMain.do?chapter=${chapter+1}&pageNum=${chapter*10+1}">&nbsp; next</a>
				</c:if> 
			</c:forEach>
		</c:if>
	</div>
</body>
</html>