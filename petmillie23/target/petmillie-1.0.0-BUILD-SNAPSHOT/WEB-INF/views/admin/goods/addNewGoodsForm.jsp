<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 등록</title>
<style>
body {
	font-family: Arial, sans-serif;
	padding: 40px;
	background-color: #f9f9f9;
}

h1 {
	margin-bottom: 20px;
}

form {
	background: white;
	padding: 20px;
	border-radius: 10px;
	box-shadow: 0 0 10px #ccc;
	width: 600px;
	margin: 0 auto;
}

table {
	width: 100%;
}

td {
	padding: 10px;
}

input[type="text"], input[type="file"] {
	width: 100%;
	padding: 8px;
	box-sizing: border-box;
}

.btn-submit {
	display: block;
	width: 100%;
	padding: 12px;
	background-color: #4CAF50;
	color: white;
	border: none;
	font-size: 16px;
	border-radius: 5px;
	margin-top: 20px; /* 테이블 바깥으로 나오면서 상단 여백 추가 */
	cursor: pointer;
}

.btn-submit:hover {
	background-color: #45a049;
}
</style>
</head>
<body>

	<h1>상품 등록</h1>

	<form action="${contextPath}/admin/goods/addNewGoods.do" method="post"
		enctype="multipart/form-data">
		<table>
			<tr>
				<td>상품명</td>
				<td><input type="text" name="goods_name" required></td>
			</tr>
			<tr>
				<td>제조사</td>
				<td><input type="text" name="goods_maker" required></td>
			</tr>
			<tr>
				<td>카테고리</td>
				<td><input type="text" name="goods_category" required></td>
			</tr>
			<tr>
				<td>정가</td>
				<td><input type="text" name="goods_price" required></td>
			</tr>
			<tr>
				<td>할인된 가격</td>
				<td><input type="text" name="goods_sales_price" required></td>
			</tr>
			<tr>
				<td>포인트</td>
				<td><input type="text" name="goods_point" required></td>
			</tr>
			<tr>
				<td>재고</td>
				<td><input type="text" name="goods_stock" required></td>
			</tr>
			<tr>
				<td>배송비</td>
				<td><input type="text" name="goods_delivery_price" required></td>
			</tr>
			<tr>
				<td>파일 첨부</td>
				<td><input type="file" name="goods_fileName" required></td>
			</tr>
			<tr>
				<td>판매 상태</td>
				<td><select name="goods_status">
						<option value="bestseller">베스트셀러</option>
						<option value="steadyseller">스테디셀러</option>
						<option value="newbook" selected>신간</option>
						<option value="on_sale">판매중</option>
						<option value="buy_out">품절</option>
						<option value="out_of_print">절판</option>
				</select></td>
			</tr>
			<tr>
				<td>작성자 소개</td>
				<td><input type="text" name="goods_goods_writer_intro" required></td>
			<tr>
				<td>제품소개</td>
    <td>
        <textarea rows="10" cols="50" name="goods_contents_order"></textarea>
    </td>
</tr>
            
			
            

            
            
            
            <tr>
                <td colspan="2"> <%-- 두 컬럼을 합쳐서 버튼이 가운데 오도록 --%>
                    <button type="submit" class="btn-submit">상품 등록</button>
                </td>
            </tr>
        </table>
    </form>

</body>
</html>