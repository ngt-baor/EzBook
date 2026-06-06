<%--
  Created by IntelliJ IDEA.
  User: Bao
  Date: 5/31/2026
  Time: 08:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>EZBook Nhan Vien</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Admin Workspace</p>
            <h1 class="page-title">Nhan Vien</h1>
            <p class="page-subtitle">Trang dieu huong nhanh ve man hinh quan ly nhan vien.</p>
        </div>
        <nav class="toolbar">
            
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chu</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Nhan vien</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Tai khoan</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dich vu</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hoa don</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Dang xuat</a>
        </nav>
    </header>

    <section class="action-grid">
        <a class="action-card" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">
            <strong>Mo Danh Sach Nhan Vien</strong>
            <span>Them, sua, xoa va kiem tra trang thai lam viec cua nhan vien.</span>
            <em>Admin</em>
        </a>
    </section>
</div>
</body>
</html>
