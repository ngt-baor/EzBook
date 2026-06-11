<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Khách Hàng Đăng Ký</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="auth-shell">
    <h1 class="auth-title">Đăng Ký Khách Hàng</h1>
    <p class="auth-subtitle">Tạo tài khoản để booking online</p>

    <c:if test="${param.error == 'missing-data'}">
        <p class="alert error">Vui lòng nhập đầy đủ thông tin.</p>
    </c:if>
    <c:if test="${param.error == 'password-not-match'}">
        <p class="alert error">Mật khẩu xác nhận không khớp.</p>
    </c:if>
    <c:if test="${param.error == 'invalid-email'}">
        <p class="alert error">Gmail không hợp lệ. Vui lòng nhập địa chỉ kết thúc bằng @gmail.com.</p>
    </c:if>
    <c:if test="${param.error == 'email-exists'}">
        <p class="alert error">Gmail này đã được sử dụng cho tài khoản khác.</p>
    </c:if>
    <c:if test="${param.error == 'invalid-code'}">
        <p class="alert error">Mã xác nhận không chính xác.</p>
    </c:if>
    <c:if test="${param.error == 'mail-send-failed'}">
        <p class="alert error">Không gửi được mã về Gmail. Vui lòng kiểm tra cấu hình Gmail SMTP.</p>
    </c:if>
    <c:if test="${param.msg == 'code-sent'}">
        <p class="alert success">Đã gửi mã xác nhận về Gmail.</p>
    </c:if>
    <c:if test="${param.error == 'register-failed'}">
        <p class="alert error">Đăng ký thất bại. Số điện thoại có thể đã tồn tại.</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/khach-hang/dang-ky" method="post">
        <div class="form-grid">
            <label class="field">
                <span>Họ tên</span>
                <input type="text" name="ho_ten" required>
            </label>

            <label class="field">
                <span>Số điện thoại</span>
                <input type="text" name="sdt" required>
            </label>

            <label class="field">
                <span>Gmail</span>
                <input type="email" name="email" placeholder="tenkhachhang@gmail.com" pattern="^[A-Za-z0-9._%+-]+@gmail\.com$" required>
            </label>
            <div class="field">
                <span>Mã xác nhận Gmail</span>
                <input type="text" name="ma_xac_nhan" maxlength="6" placeholder="Nhập mã 6 số" required>
                <button type="submit" formaction="${pageContext.request.contextPath}/khach-hang/dang-ky/gui-ma" formnovalidate>Gửi mã</button>
            </div>

            <label class="field">
                <span>Mật khẩu</span>
                <input type="password" name="mat_khau" required>
            </label>

            <label class="field">
                <span>Xác nhận mật khẩu</span>
                <input type="password" name="xac_nhan_mat_khau" required>
            </label>
        </div>

        <div class="form-actions">
            <button class="btn-block" type="submit">Đăng ký</button>
        </div>
    </form>

    <div class="auth-links">
        <a href="${pageContext.request.contextPath}/khach-hang/dang-nhap.jsp">Đăng nhập</a>
        <a href="${pageContext.request.contextPath}/auth/login.jsp">Đăng nhập nhân viên/admin</a>
    </div>
</div>
</body>
</html>
