<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Khach Hang Dang Ky</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="auth-shell">
    <h1 class="auth-title">Dang Ky Khach Hang</h1>
    <p class="auth-subtitle">Tao tai khoan de booking online</p>

    <c:if test="${param.error == 'missing-data'}">
        <p class="alert error">Vui long nhap day du thong tin.</p>
    </c:if>
    <c:if test="${param.error == 'password-not-match'}">
        <p class="alert error">Mat khau xac nhan khong khop.</p>
    </c:if>
    <c:if test="${param.error == 'register-failed'}">
        <p class="alert error">Dang ky that bai. So dien thoai co the da ton tai.</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/khach-hang/dang-ky" method="post">
        <div class="form-grid">
            <label class="field">
                <span>Ho ten</span>
                <input type="text" name="ho_ten" required>
            </label>

            <label class="field">
                <span>So dien thoai</span>
                <input type="text" name="sdt" required>
            </label>

            <label class="field">
                <span>Mat khau</span>
                <input type="password" name="mat_khau" required>
            </label>

            <label class="field">
                <span>Xac nhan mat khau</span>
                <input type="password" name="xac_nhan_mat_khau" required>
            </label>
        </div>

        <div class="form-actions">
            <button class="btn-block" type="submit">Dang ky</button>
        </div>
    </form>

    <div class="auth-links">
        <a href="${pageContext.request.contextPath}/khach-hang/dang-nhap.jsp">Dang nhap</a>
        <a href="${pageContext.request.contextPath}/auth/login.jsp">Dang nhap nhan vien/admin</a>
    </div>
</div>
</body>
</html>

