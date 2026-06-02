<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Khach Hang Dang Nhap</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div style="width: 420px; margin: 40px auto; border: 1px solid #ccc; border-radius: 6px; padding: 20px; font-family: Arial, sans-serif;">
    <h2 style="text-align: center;">Dang Nhap Khach Hang</h2>

    <c:if test="${param.msg == 'register-success'}">
        <p style="color: green;">Dang ky thanh cong. Vui long dang nhap.</p>
    </c:if>
    <c:if test="${param.msg == 'logged-out'}">
        <p style="color: green;">Ban da dang xuat.</p>
    </c:if>
    <c:if test="${param.error == 'login-required'}">
        <p style="color: red;">Ban can dang nhap de dat lich online.</p>
    </c:if>
    <c:if test="${param.error == 'invalid'}">
        <p style="color: red;">Tai khoan hoac mat khau khong dung.</p>
    </c:if>
    <c:if test="${param.error == 'blocked'}">
        <p style="color: red;">Tai khoan dang bi khoa.</p>
    </c:if>
    <c:if test="${param.error == 'role-not-allowed'}">
        <p style="color: red;">Tai khoan nay khong thuoc nhom khach hang.</p>
    </c:if>
    <c:if test="${param.error == 'forbidden'}">
        <p style="color: red;">Ban khong co quyen truy cap trang nay.</p>
    </c:if>
    <c:if test="${param.error == 'missing-data'}">
        <p style="color: red;">Vui long nhap day du thong tin.</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/khach-hang/dang-nhap" method="post">
        <label>Tai khoan (So dien thoai)</label><br>
        <input type="text" name="username" style="width: 100%; padding: 6px;" required><br><br>

        <label>Mat khau</label><br>
        <input type="password" name="password" style="width: 100%; padding: 6px;" required><br><br>

        <button type="submit" style="width: 100%; padding: 8px;">Dang nhap</button>
    </form>

    <p style="text-align: center; margin-top: 14px;">
        Chua co tai khoan?
        <a href="${pageContext.request.contextPath}/khach-hang/dang-ky.jsp">Dang ky ngay</a>
    </p>
    <p style="text-align: center; margin-top: 8px;">
        <a href="${pageContext.request.contextPath}/auth/forgot-password.jsp">Quen mat khau</a>
        |
        <a href="${pageContext.request.contextPath}/auth/login.jsp">Dang nhap nhan vien/admin</a>
    </p>
</div>
</body>
</html>
