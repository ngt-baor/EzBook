<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Trang Chu</title>
</head>
<body>
<div style="width: 760px; margin: 40px auto; border: 1px solid #ccc; border-radius: 6px; padding: 20px; font-family: Arial, sans-serif;">
    <h2>Trang Chu</h2>
    <p>Xin chao: <strong>${sessionScope.displayName}</strong> (${sessionScope.username}) - Role: <strong>${sessionScope.role}</strong></p>

    <hr>
    <h3>Chuc nang</h3>
    <ul>
        <c:if test="${sessionScope.role == 'ADMIN'}">
            <li><a href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Quan ly nhan vien (Admin)</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Quan ly tai khoan (khoa/mo khoa)</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">CRUD loai dich vu + dich vu</a></li>
        </c:if>
        <li><a href="${pageContext.request.contextPath}/booking/hien-thi">Quan ly booking + thong ke</a></li>
        <li><a href="${pageContext.request.contextPath}/hoa-don/hien-thi">Quan ly hoa don</a></li>
        <li><a href="${pageContext.request.contextPath}/account/ho-so">Ho so ca nhan / doi mat khau</a></li>
        <li><a href="${pageContext.request.contextPath}/logout">Dang xuat</a></li>
    </ul>
</div>
</body>
</html>
