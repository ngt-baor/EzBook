<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>EZBook</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=ui-20260703">
</head>
<body>
<div class="landing">
    <div class="app-shell">
        <h1 class="auth-title">EZBook</h1>
        <p class="auth-subtitle">Không gian vận hành lịch hẹn chuyên nghiệp</p>

        <div class="action-grid">
            <a class="action-card" href="${pageContext.request.contextPath}/auth/login.jsp">
                <strong>Admin / Staff</strong>
                <span>Đăng nhập để quản lý booking, hóa đơn, nhân viên và dịch vụ.</span>
                <em>Back office</em>
            </a>
            <a class="action-card" href="${pageContext.request.contextPath}/khach-hang/dang-nhap.jsp">
                <strong>Khách Hàng</strong>
                <span>Đăng nhập để đặt lịch online và xem lịch của bạn.</span>
                <em>Booking</em>
            </a>
            <a class="action-card" href="${pageContext.request.contextPath}/khach-hang/dang-ky.jsp">
                <strong>Đăng Ký</strong>
                <span>Tạo tài khoản khách hàng moi bảng so dien thoai.</span>
                <em>New account</em>
            </a>
        </div>
    </div>
</div>
</body>
</html>
