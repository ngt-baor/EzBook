<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Trang Chủ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">EZBook Workspace</p>
            <h1 class="page-title">Trang Chủ</h1>
            <p class="page-subtitle">Màn hình điều hướng chính cho Admin và Nhân viên, tập trung vào booking, hóa đơn, dịch vụ và quản lý tài khoản trong một bố cục desktop rõ ràng.</p>
        </div>
        <nav class="toolbar">
            
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chủ</a>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a class="toolbar-link" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Nhân viên</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Tài khoản</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dịch vụ</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Khuyến mãi</a>
            </c:if>
            <c:if test="${sessionScope.role == 'STAFF'}">
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Khuyến mãi</a>
            </c:if>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hóa đơn</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/thong-ke/hien-thi">Thống kê</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Hồ sơ</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Người đăng nhập</span>
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
        <c:if test="${sessionScope.role == 'ADMIN'}">
            <a class="action-card" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">
                <strong>Quản Lý Nhân Viên</strong>
                <span>Thêm, sửa, xóa nhân viên và theo dõi trạng thái làm việc trong mot bảng desktop rộng.</span>
                <em>Admin only</em>
            </a>

            <a class="action-card" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">
                <strong>Quản Lý Tài Khoản</strong>
                <span>Tách riêng tài khoản nhân viên và khách hàng, khóa mở khóa nhanh từ cung một màn hình.</span>
                <em>Account control</em>
            </a>

            <a class="action-card" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">
                <strong>Quản Lý Dịch Vụ</strong>
                <span>CRUD loai dịch vụ và dịch vụ voi form lớn, bảng rõ ràng, phù hợp thao tác trên PC.</span>
                <em>Service setup</em>
            </a>

            <a class="action-card" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">
                <strong>Quản Lý Khuyến Mãi</strong>
                <span>Tạo mã giảm giá, giới hạn số lượng và áp dụng trực tiếp vào booking, hóa đơn.</span>
                <em>Promotion setup</em>
            </a>
        </c:if>

        <c:if test="${sessionScope.role == 'STAFF'}">
            <a class="action-card" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">
                <strong>Danh Sách Khuyến Mãi</strong>
                <span>Xem các mã khuyến mãi đang có để tư vấn và hỗ trợ khách hàng khi tạo booking.</span>
                <em>View only</em>
            </a>
        </c:if>

        <a class="action-card" href="${pageContext.request.contextPath}/booking/hien-thi">
            <strong>Quản Lý Booking</strong>
            <span>Đặt lịch theở khung giờ, kiểm tra trùng lịch, lọc theo khách hàng, ngày và trạng thái.</span>
            <em>Operations</em>
        </a>

        <a class="action-card" href="${pageContext.request.contextPath}/hoa-don/hien-thi">
            <strong>Quản Lý Hóa Đơn</strong>
            <span>Theo dõi thanh toán, cập nhật phương thức thanh toán và xử lý hóa đơn cho booking hoàn thành.</span>
            <em>Billing</em>
        </a>

        <a class="action-card" href="${pageContext.request.contextPath}/thong-ke/hien-thi">
            <strong>Thống Kê</strong>
            <span>Xem bịểu đồ doanh thu theo tháng, lọc theo năm và tổng hợp số liệu từ hóa đơn đã thanh toán.</span>
            <em>Analytics</em>
        </a>

        <a class="action-card" href="${pageContext.request.contextPath}/account/ho-so">
            <strong>Hồ Sơ Cá Nhân</strong>
            <span>Cập nhật thông tin tài khoản, đổi mật khẩu và kiểm tra vai trò đang được cấp.</span>
            <em>Profile</em>
        </a>
    </section>
</div>
</body>
</html>

