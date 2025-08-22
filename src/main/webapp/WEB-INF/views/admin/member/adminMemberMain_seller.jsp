<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false" %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

<script>
function search_member(search_period){	
	var temp=calcPeriod(search_period);
	var date=temp.split(",");
	var beginDate=date[0];
	var endDate=date[1];
	
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
    formObj.action="${pageContext.request.contextPath}/admin/member/adminMemberMain_seller.do";
    formObj.submit();
}

function calcPeriod(search_period){
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
	
	if(beginMonth <10) beginMonth='0'+beginMonth;
	if(beginDay<10) beginDay='0'+beginDay;
	if(endMonth <10) endMonth='0'+endMonth;
	if(endDay<10) endDay='0'+endDay;
	endDate=endYear+'-'+endMonth +'-'+endDay;
	beginDate=beginYear+'-'+beginMonth +'-'+beginDay;
	return beginDate+","+endDate;
}

function fn_seller_detail(seller_id){
	var formObj=document.createElement("form");
	var i_seller_id = document.createElement("input");
	i_seller_id.name="seller_id";
	i_seller_id.value=seller_id;
    formObj.appendChild(i_seller_id);
    document.body.appendChild(formObj); 
    formObj.method="post";
    formObj.action="${pageContext.request.contextPath}/admin/member/sellerDetail.do";
    formObj.submit();
}

function fn_enable_detail_search(r_search){
	var frm=document.frm_delivery_list;
	var elements=[frm.beginYear, frm.beginMonth, frm.beginDay, frm.endYear, frm.endMonth, frm.endDay, frm.s_search_type, frm.t_search_word, frm.btn_search];
	if(r_search.value=='detail_search'){
		elements.forEach(e=>e.disabled=false);
	}else{
		elements.forEach(e=>e.disabled=true);
	}
}

function fn_detail_search(){
	var frm=document.frm_delivery_list;
	var formObj=document.createElement("form");
	var i_beginDate = document.createElement("input"); 
	var i_endDate = document.createElement("input");
	var i_search_type = document.createElement("input");
	var i_search_word = document.createElement("input");
    
	i_beginDate.name="beginDate";
	i_endDate.name="endDate";
	i_search_type.name="search_type";
	i_search_word.name="search_word";
    
	i_beginDate.value=frm.beginYear.value+"-"+frm.beginMonth.value+"-"+frm.beginDay.value;
	i_endDate.value=frm.endYear.value+"-"+frm.endMonth.value+"-"+frm.endDay.value;
	i_search_type.value=frm.s_search_type.value;
	i_search_word.value=frm.t_search_word.value;
	
    formObj.appendChild(i_beginDate);
    formObj.appendChild(i_endDate);
    formObj.appendChild(i_search_type);
    formObj.appendChild(i_search_word);
    document.body.appendChild(formObj); 
    formObj.method="get";
    formObj.action="${pageContext.request.contextPath}/admin/member/adminMemberMain_seller.do";
    formObj.submit();
}
</script>
</head>
<body>
<div class="container text-center mt-3 mb-3">
	<div class="row row-cols-1 mb-3">
		<div class="col bg-light p-5 text-start">
			<h2 class="fw-bold h2h2">사업자회원 관리</h2>
		</div>
	</div>
	 <div class="row seller_menu">
			<ul>	
				<li><a href="${contextPath}/admin/goods/addNewGoodsForm.do">상품등록</a></li>
				<li><a href="${contextPath}/admin/goods/adminGoodsMain.do">상품관리</a></li>
				<li><a href="${contextPath}/admin/order/adminOrderMain.do">주문/배송관리</a></li>							
				<li><a href="${contextPath}/admin/member/adminMemberMain.do">회원관리</a></li>
				<li><a href="#">회계관리</a></li>
				<li><a href="#">펜션등록</a></li>
				<li><a href="#">펜션관리</a></li>
				<li><a href="${contextPath}/reservation/adminPensionCheck.do">예약관리</a></li>	
			</ul>
		</div>
	<div class="container mb-3">
	  <div class="row text-center">
	    <div class="col">
	      <div class="card">
	        <div class="card-body">
	          <a href="${contextPath}/admin/member/adminMemberMain.do" class="stretched-link text-decoration-none fw-bold">일반회원 관리</a>
	        </div>
	      </div>
	    </div>
	    <div class="col">
	      <div class="card">
	        <div class="card-body">
	          <a href="${contextPath}/admin/member/adminMemberMain_seller.do" class="stretched-link text-decoration-none fw-bold">사업자회원 관리</a>
	        </div>
	      </div>
	    </div>
	  </div>
	</div>
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
							<input class="form-check-input" type="radio" name="r_search_option" value="detail_search" onClick="fn_enable_detail_search(this)" id="detailSearch">
							<label class="form-check-label" for="detailSearch">상세조회</label>
						</div>
					</div>

					<div class="d-flex align-items-center mb-3">
						<select name="s_search_type" class="form-select d-inline-block w-auto me-2" disabled >
							<option value="all" selected>전체</option>
							<option value="business_name">사업자명</option>
							<option value="seller_id">사업자아이디</option>
							<option value="owner_name">대표자명</option>
							<option value="phone">전화번호</option>
						</select>
						<input type="text" name="t_search_word" class="form-control d-inline-block me-2" disabled />  
						<input type="button" value="조회" name="btn_search" class="btn btn-primary" onClick="fn_detail_search()" disabled />
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
						<th>사업자아이디</th>
						<th>사업자명</th>
						<th>대표자명</th>
						<th>전화번호</th>
						<th>이메일</th>
						<th>주소</th>
						<th>등록일</th>
						<th>승인상태</th>
					</tr>
				</thead>
				<tbody class="text-center">
					<c:choose>
						<c:when test="${empty business_list}">			
							<tr>
								<td colspan="8">
									<strong>조회된 사업자회원이 없습니다.</strong>
								</td>
							</tr>
						</c:when>
						<c:otherwise>
							<c:forEach var="item" items="${business_list}" varStatus="item_num">
								<tr>       
									<td><strong><a href="${contextPath}/admin/member/adminSellerMemberDetailInfo.do?seller_id=${item.seller_id}">${item.seller_id}</a></strong></td>
									<td><strong>${item.business_name}</strong></td>
									<td><strong>${item.owner_name}</strong></td>
									<td><strong>${item.phone1}-${item.phone2}-${item.phone3}</strong></td>
									<td><strong>${item.email1}@${item.email2}</strong></td>
									<td><strong>[${item.zipcode}] ${item.roadAddress} ${item.namujiAddress}</strong></td>
									<td><c:set var="reg_date" value="${item.reg_date}" />
									    <c:set var="arr" value="${fn:split(reg_date,' ')}" />
									    <strong><c:out value="${arr[0]}" /></strong>
									</td>
									<td>
										<select class="form-select form-select-sm approval_status_select" data-seller-id="${item.seller_id}">
									        <option value="approve" ${item.approval_status == 'approve' ? 'selected' : ''}>승인</option>
									        <option value="pending" ${item.approval_status == 'pending' ? 'selected' : ''}>미승인</option>
									    </select>
									</td>
								</tr>
							</c:forEach>
						</c:otherwise>
					</c:choose>	
				</tbody>
			</table>
		</div>
	</div>
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const selects = document.querySelectorAll('.approval_status_select');
    selects.forEach(sel => {
        sel.addEventListener('change', function() {
            const sellerId = this.dataset.sellerId;
            const newStatus = this.value;
            
            fetch('${contextPath}/admin/member/updateApprovalStatus.do', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                },
                body: new URLSearchParams({
                    seller_id: sellerId,
                    approval_status: newStatus
                })
            })
            .then(res => res.text())
            .then(result => {
                if(result === 'success'){
                    alert('승인 상태가 변경되었습니다.');
                } else {
                    alert('변경 실패! 다시 시도해주세요.');
                }
            })
            .catch(err => {
                console.error(err);
                alert('서버 오류 발생!');
            });

        });
    });
});
</script>
</body>
</html>
