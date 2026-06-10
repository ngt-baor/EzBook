<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Giao Diện Khách Hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Customer Workspace</p>
            <h1 class="page-title">Giao Diện Khách Hàng</h1>
            <p class="page-subtitle">Trang điều hướng cho khách hàng đã đăng nhập, tập trung vào booking online, theo dõi lịch đã đặt và cập nhật hồ sơ cá nhân.</p>
        </div>
        <nav class="toolbar">
            
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-khach.jsp">Trang khách hàng</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/khach-hang/booking-online">Đặt lịch</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Hồ sơ</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/khach-hang/dang-xuat">Đăng xuất</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Xin chào</span>
            <strong>${sessionScope.displayName}</strong>
        </article>
        <article class="stat-card">
            <span>Username</span>
            <strong>${sessionScope.username}</strong>
        </article>
        <article class="stat-card">
            <span>Vai trò</span>
            <strong>${sessionScope.role}</strong>
        </article>
    </section>

    <section class="action-grid">
        <a class="action-card" href="${pageContext.request.contextPath}/khach-hang/booking-online">
            <strong>Đặt Lịch Online</strong>
            <span>Chọn dịch vụ, khung giờ, xem lịch đã đặt và hủy lịch neu booking vẫn đang chờ xử lý.</span>
            <em>Booking</em>
        </a>

        <a class="action-card" href="${pageContext.request.contextPath}/account/ho-so">
            <strong>Hồ Sơ Cá Nhân</strong>
            <span>Cập nhật thông tin liên hệ, đổi mật khẩu và kiểm tra trạng thái tài khoản.</span>
            <em>Profile</em>
        </a>

        <a class="action-card" href="${pageContext.request.contextPath}/khach-hang/dang-xuat">
            <strong>Đăng Xuất</strong>
            <span>Kết thúc phiên đăng nhập khách hàng an toàn sau khi đặt lịch xong.</span>
            <em>Sign out</em>
        </a>
    </section>
</div>
</body>
</html>
