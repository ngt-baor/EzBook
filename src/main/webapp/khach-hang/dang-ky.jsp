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
