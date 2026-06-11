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
            <p class="page-subtitle">Cập nhật thông tin liên hệ và đổi mật khẩu trên cùng một màn hình, giữ bố cục ổn định cho Admin, Staff và Khách hàng.</p>
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
        <p class="alert success">Cập nhật hồ sơ thành công.</p>
    </c:if>
    <c:if test="${param.msg == 'change-pass-success'}">
        <p class="alert success">Đổi mật khẩu thành công.</p>
    </c:if>
    <c:if test="${param.msg == 'code-sent'}">
        <p class="alert success">Đã gửi mã xác nhận về Gmail.</p>
    </c:if>
    <c:if test="${param.error == 'invalid-email'}">
        <p class="alert error">Gmail không hợp lệ. Vui lòng nhập địa chỉ kết thúc bằng @gmail.com.</p>
    </c:if>
    <c:if test="${param.error == 'email-exists'}">
        <p class="alert error">Gmail này đã được sử dụng cho tài khoản khác.</p>
    </c:if>
    <c:if test="${param.error == 'wrong-profile-password'}">
        <p class="alert error">Mật khẩu xác nhận không chính xác. Hồ sơ chưa được cập nhật.</p>
    </c:if>
    <c:if test="${param.error == 'email-not-match-account'}">
        <p class="alert error">Gmail không khớp với tài khoản hiện tại.</p>
    </c:if>
    <c:if test="${param.error == 'invalid-code'}">
        <p class="alert error">Mã xác nhận không chính xác.</p>
    </c:if>
    <c:if test="${param.error == 'missing-data'}">
        <p class="alert error">Vui lòng nhập đầy đủ thông tin.</p>
    </c:if>
    <c:if test="${param.error == 'password-not-match'}">
        <p class="alert error">Mật khẩu mới và xác nhận mật khẩu mới không khớp.</p>
    </c:if>
    <c:if test="${param.error == 'wrong-old-pass'}">
        <p class="alert error">Mật khẩu cũ không chính xác.</p>
    </c:if>
    <c:if test="${param.error == 'change-pass-failed'}">
        <p class="alert error">Không thể đổi mật khẩu. Vui lòng thử lại.</p>
    </c:if>
    <c:if test="${param.error == 'missing-email'}">
        <p class="alert error">Vui lòng nhập Gmail để nhận mã xác nhận.</p>
    </c:if>
    <c:if test="${param.error == 'update-profile-failed'}">
        <p class="alert error">Không thể cập nhật hồ sơ. Vui lòng thử lại.</p>
    </c:if>
    <c:if test="${param.error == 'mail-send-failed'}">
        <p class="alert error">Không gửi được mã về Gmail. Vui lòng kiểm tra cấu hình Gmail SMTP.</p>
    </c:if>
    <c:if test="${param.error != null && param.error != 'invalid-email' && param.error != 'email-exists' && param.error != 'wrong-profile-password' && param.error != 'email-not-match-account' && param.error != 'invalid-code' && param.error != 'missing-data' && param.error != 'password-not-match' && param.error != 'wrong-old-pass' && param.error != 'change-pass-failed' && param.error != 'missing-email' && param.error != 'update-profile-failed' && param.error != 'mail-send-failed'}">
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
                        <label class="field">
                            <span>Gmail</span>
                            <input type="email" name="email" value="${accountInfo.email}" placeholder="ten@gmail.com" pattern="^[A-Za-z0-9._%+-]+@gmail\.com$" required>
                        </label>
                        <label class="field">
                            <span>Mật khẩu xác nhận</span>
                            <input type="password" name="mat_khau_xac_nhan" placeholder="Nhập mật khẩu hiện tại để lưu hồ sơ" required>
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
                            <span>Mật khẩu cũ</span>
                            <input type="password" name="mat_khau_cu" required>
                        </label>
                        <div class="field">
                            <span>Gmail nhận mã</span>
                            <input type="email" name="email" value="${accountInfo.email}" pattern="^[A-Za-z0-9._%+-]+@gmail\.com$" required>
                            <button type="submit" formaction="${pageContext.request.contextPath}/account/doi-mat-khau/gui-ma" formnovalidate>Gửi mã</button>
                        </div>
                        <label class="field">
                            <span>Mã xác nhận Gmail</span>
                            <input type="text" name="ma_xac_nhan" maxlength="6" placeholder="Nhập mã 6 số" required>
                        </label>
                        <label class="field">
                            <span>Mật khẩu mới</span>
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
