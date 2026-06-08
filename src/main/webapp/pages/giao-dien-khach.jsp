<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Giao Dien Khach Hang</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Customer Workspace</p>
            <h1 class="page-title">Giao Dien Khach Hang</h1>
            <p class="page-subtitle">Trang dieu huong cho khach hang da dang nhap, tap trung vao booking online, theo doi lich da dat va cap nhat ho so ca nhan.</p>
        </div>
        <nav class="toolbar">
            
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-khach.jsp">Trang khach hang</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/khach-hang/booking-online">Dat lich</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/khach-hang/dang-xuat">Dang xuat</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Xin chao</span>
            <strong>${sessionScope.displayName}</strong>
        </article>
        <article class="stat-card">
            <span>Username</span>
            <strong>${sessionScope.username}</strong>
        </article>
        <article class="stat-card">
            <span>Vai tro</span>
            <strong>${sessionScope.role}</strong>
        </article>
    </section>

    <section class="action-grid">
        <a class="action-card" href="${pageContext.request.contextPath}/khach-hang/booking-online">
            <strong>Dat Lich Online</strong>
            <span>Chon dich vu, khung gio, xem lich da dat va huy lich neu booking van dang cho xu ly.</span>
            <em>Booking</em>
        </a>

        <a class="action-card" href="${pageContext.request.contextPath}/account/ho-so">
            <strong>Ho So Ca Nhan</strong>
            <span>Cap nhat thong tin lien he, doi mat khau va kiem tra trang thai tai khoan.</span>
            <em>Profile</em>
        </a>

        <a class="action-card" href="${pageContext.request.contextPath}/khach-hang/dang-xuat">
            <strong>Dang Xuat</strong>
            <span>Ket thuc phien dang nhap khach hang an toan sau khi dat lich xong.</span>
            <em>Sign out</em>
        </a>
    </section>
</div>
</body>
</html>

