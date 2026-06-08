<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Khach Hang Dang Nhap</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="auth-shell">
    <h1 class="auth-title">Khach Hang</h1>
    <p class="auth-subtitle">Dang nhap de dat lich online</p>

    <c:if test="${param.msg == 'register-success'}">
        <p class="alert success">Dang ky thanh cong. Vui long dang nhap.</p>
    </c:if>
    <c:if test="${param.msg == 'logged-out'}">
        <p class="alert success">Ban da dang xuat.</p>
    </c:if>
    <c:if test="${param.error == 'login-required'}">
        <p class="alert error">Ban can dang nhap de dat lich online.</p>
    </c:if>
    <c:if test="${param.error == 'invalid'}">
        <p class="alert error">Tai khoan hoac mat khau khong dung.</p>
    </c:if>
    <c:if test="${param.error == 'blocked'}">
        <p class="alert error">Tai khoan dang bi khoa.</p>
    </c:if>
    <c:if test="${param.error == 'role-not-allowed'}">
        <p class="alert error">Tai khoan nay khong thuoc nhom khach hang.</p>
    </c:if>
    <c:if test="${param.error == 'forbidden'}">
        <p class="alert error">Ban khong co quyen truy cap trang nay.</p>
    </c:if>
    <c:if test="${param.error == 'missing-data'}">
        <p class="alert error">Vui long nhap day du thong tin.</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/khach-hang/dang-nhap" method="post">
        <div class="form-grid">
            <label class="field">
                <span>Tai khoan</span>
                <input type="text" name="username" placeholder="So dien thoai" required>
            </label>

            <label class="field">
                <span>Mat khau</span>
                <input type="password" name="password" required>
            </label>
        </div>

        <div class="form-actions">
            <button class="btn-block" type="submit">Dang nhap</button>
        </div>
    </form>

    <div class="auth-links">
        <a href="${pageContext.request.contextPath}/khach-hang/dang-ky.jsp">Dang ky ngay</a>
        <a href="${pageContext.request.contextPath}/auth/forgot-password.jsp">Quen mat khau</a>
        <a href="${pageContext.request.contextPath}/auth/login.jsp">Dang nhap nhan vien/admin</a>
    </div>
</div>
</body>
</html>

