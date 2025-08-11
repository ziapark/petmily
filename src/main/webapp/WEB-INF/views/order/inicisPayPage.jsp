<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <!-- 반드시 이니시스 표준결제 JS CDN 포함 -->
    <script src="https://stdpay.inicis.com/stdjs/INIStdPay.js"></script>
</head>
<body>
    <form id="inicisPayForm" method="post" action="https://stdpay.inicis.com/stdpay/payMain.do">
        <input type="hidden" name="mid" value="${mid}" />
        <input type="hidden" name="oid" value="${oid}" />
        <input type="hidden" name="price" value="${price}" />
        <input type="hidden" name="buyername" value="홍길동" />
        <input type="hidden" name="buyertel" value="01012341234" />
        <input type="hidden" name="buyeremail" value="test@abc.com" />
        <input type="hidden" name="timestamp" value="${timestamp}" />
        <input type="hidden" name="signature" value="${signature}" />
        <!-- 기타 결제 파라미터 추가 가능 -->
        <button type="button" onclick="fn_inicis_pay()">이니시스 결제하기</button>
    </form>

    <script>
        function fn_inicis_pay() {
            var form = document.getElementById("inicisPayForm");
            INIStdPay.popup(form); // 결제창 뜸!
        }
    </script>
</body>
</html>
