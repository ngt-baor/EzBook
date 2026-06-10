<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Hồ Sơ Cá Nhân</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Account Center</p>
            <h1 class="page-title">Hồ Sơ Cá Nhân</h1>
            <p class="page-subtitle">Cập nhật thông tin liên hệ và đổi mật khẩu trên cung một màn hình, giữ bố cục ổn định cho ca Admin, Staff và Khách hàng.</p>
        </div>
        <nav class="toolbar">
            <c:choose>
                <c:when test="${sessionScope.role == 'USER'}">
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-khach.jsp">Trang khách hàng</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/khach-hang/booking-online">Đặt lịch</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Hồ sơ</a>
                    <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/khach-hang/dang-xuat">Đăng xuất</a>
                </c:when>
                <c:when test="${sessionScope.role == 'ADMIN'}">
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chủ</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Nhân viên</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Tài khoản</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dịch vụ</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Khuyến mãi</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hóa đơn</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/thong-ke/hien-thi">Thống kê</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Hồ sơ</a>
                    <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chủ</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hóa đơn</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Khuyến mãi</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/thong-ke/hien-thi">Thống kê</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Hồ sơ</a>
                    <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Tài khoản</span>
            <strong>${accountInfo.username}</strong>
        </article>
        <article class="stat-card">
            <span>Vai trò</span>
            <strong>${accountInfo.role}</strong>
        </article>
        <article class="stat-card">
            <span>Trạng thái</span>
            <strong>${accountInfo.active ? 'Đang hoạt động' : 'Bị khóa'}</strong>
        </article>
    </section>

    <c:if test="${param.msg == 'update-profile-success'}">
        <p class="alert success">Cập nhật ho so thành công.</p>
    </c:if>
    <c:if test="${param.msg == 'change-pass-success'}">
        <p class="alert success">Đổi mật khẩu thành công.</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p class="alert error">Có lỗi: ${param.error}</p>
    </c:if>

    <section class="workspace-grid equal-col">
        <article class="panel">
            <div class="panel-head">
                <h2>Cập Nhật Hồ Sơ</h2>
                <span class="meta-chip">Profile</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}/account/cap-nhat-ho-so" method="post">
                    <div class="form-grid">
                        <label class="field">
                            <span>Họ tên</span>
                            <input type="text" name="ho_ten" value="${accountInfo.fullName}" required>
                        </label>
                        <label class="field">
                            <span>Số điện thoại</span>
                            <input type="text" name="sdt" value="${accountInfo.phone}" required>
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>Đổi Mật Khẩu</h2>
                <span class="meta-chip">Security</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}/account/doi-mat-khau" method="post">
                    <div class="form-grid">
                        <label class="field">
                            <span>Mật khẩu cu</span>
                            <input type="password" name="mat_khau_cu" required>
                        </label>
                        <label class="field">
                            <span>Mật khẩu moi</span>
                            <input type="password" name="mat_khau_moi" required>
                        </label>
                        <label class="field">
                            <span>Xác nhận mật khẩu mới</span>
                            <input type="password" name="mat_khau_moi_xac_nhan" required>
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Đổi mật khẩu</button>
                    </div>
                </form>
            </div>
        </article>
    </section>
</div>
</body>
</html>
