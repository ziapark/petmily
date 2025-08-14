<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"
    %> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
 
  <div id="sticky" style="position:absolute; right:50px; top:0;">
    <div class="hospital_pp pp_don">
        <a href="${contextPath}/medi/hptAndPms.do">동물병원/약국</a>
    </div>
    <div class="chat_pp pp_don">
        <a href="${contextPath}/medi/hptAndPms.do">채팅문의</a>
    </div>
</div>

 <script>
 const box = document.getElementById('sticky');
 let currentTop = window.scrollY + window.innerHeight - box.offsetHeight - 100;

 function animate() {
     const targetTop = window.scrollY + window.innerHeight - box.offsetHeight - 100;
     currentTop += (targetTop - currentTop) * 0.1; // 0.1은 속도, 작을수록 느리고 부드러움
     box.style.top = currentTop + 'px';
     requestAnimationFrame(animate);
 }

 animate();
</script>
