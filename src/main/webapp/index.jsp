<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>EZBook</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div class="landing">
    <div class="app-shell">
        <h1 class="auth-title">EZBook</h1>
        <p class="auth-subtitle">Retro booking workspace</p>

        <div class="action-grid">
            <a class="action-card" href="${pageContext.request.contextPath}/auth/login.jsp">
                <strong>Admin / Staff</strong>
                <span>Dang nhap de quan ly booking, hoa don, nhan vien va dich vu.</span>
                <em>Back office</em>
            </a>
            <a class="action-card" href="${pageContext.request.contextPath}/khach-hang/dang-nhap.jsp">
                <strong>Khach Hang</strong>
                <span>Dang nhap de dat lich online va xem lich cua ban.</span>
                <em>Booking</em>
            </a>
            <a class="action-card" href="${pageContext.request.contextPath}/khach-hang/dang-ky.jsp">
                <strong>Dang Ky</strong>
                <span>Tao tai khoan khach hang moi bang so dien thoai.</span>
                <em>New account</em>
            </a>
        </div>
    </div>
</div>
</body>
</html>
