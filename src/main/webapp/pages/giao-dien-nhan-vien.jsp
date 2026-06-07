<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Trang Chu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">EZBook Workspace</p>
            <h1 class="page-title">Trang Chu</h1>
            <p class="page-subtitle">Man hinh dieu huong chinh cho Admin va Nhan vien, tap trung vao booking, hoa don, dich vu va quan ly tai khoan trong mot bo cuc desktop ro rang.</p>
        </div>
        <nav class="toolbar">
            
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chu</a>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a class="toolbar-link" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Nhan vien</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Tai khoan</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dich vu</a>
            </c:if>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hoa don</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/thong-ke/hien-thi">Thong ke</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Dang xuat</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Nguoi dang nhap</span>
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
        <c:if test="${sessionScope.role == 'ADMIN'}">
            <a class="action-card" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">
                <strong>Quan Ly Nhan Vien</strong>
                <span>Them, sua, xoa nhan vien va theo doi trang thai lam viec trong mot bang desktop rong.</span>
                <em>Admin only</em>
            </a>

            <a class="action-card" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">
                <strong>Quan Ly Tai Khoan</strong>
                <span>Tach rieng tai khoan nhan vien va khach hang, khoa mo khoa nhanh tu cung mot man hinh.</span>
                <em>Account control</em>
            </a>

            <a class="action-card" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">
                <strong>Quan Ly Dich Vu</strong>
                <span>CRUD loai dich vu va dich vu voi form lon, bang ro rang, phu hop thao tac tren PC.</span>
                <em>Service setup</em>
            </a>
        </c:if>

        <a class="action-card" href="${pageContext.request.contextPath}/booking/hien-thi">
            <strong>Quan Ly Booking</strong>
            <span>Dat lich theo khung gio, kiem tra trung lich, loc theo khach hang, ngay va trang thai.</span>
            <em>Operations</em>
        </a>

        <a class="action-card" href="${pageContext.request.contextPath}/hoa-don/hien-thi">
            <strong>Quan Ly Hoa Don</strong>
            <span>Theo doi thanh toan, cap nhat phuong thuc thanh toan va xu ly hoa don cho booking hoan thanh.</span>
            <em>Billing</em>
        </a>

        <a class="action-card" href="${pageContext.request.contextPath}/thong-ke/hien-thi">
            <strong>Thong Ke</strong>
            <span>Xem bieu do doanh thu theo thang, loc theo nam va tong hop so lieu tu hoa don da thanh toan.</span>
            <em>Analytics</em>
        </a>

        <a class="action-card" href="${pageContext.request.contextPath}/account/ho-so">
            <strong>Ho So Ca Nhan</strong>
            <span>Cap nhat thong tin tai khoan, doi mat khau va kiem tra vai tro dang duoc cap.</span>
            <em>Profile</em>
        </a>
    </section>
</div>
</body>
</html>
