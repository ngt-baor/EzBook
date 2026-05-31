<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Giao Dien Khach Hang</title>
</head>
<body>
<div style="width: 760px; margin: 40px auto; border: 1px solid #ccc; border-radius: 6px; padding: 20px; font-family: Arial, sans-serif;">
    <h2>Giao Dien Khach Hang</h2>
    <p>Xin chao: <strong>${sessionScope.displayName}</strong> (${sessionScope.username})</p>
    <p>Khach hang can dang nhap tai khoan de dat lich online.</p>

    <hr>
    <h3>Chuc nang</h3>
    <ul>
        <li><a href="${pageContext.request.contextPath}/khach-hang/booking-online">Dat lich online</a></li>
        <li><a href="${pageContext.request.contextPath}/account/ho-so">Cap nhat ho so / doi mat khau</a></li>
        <li><a href="${pageContext.request.contextPath}/khach-hang/dang-xuat">Dang xuat</a></li>
    </ul>
</div>
</body>
</html>
