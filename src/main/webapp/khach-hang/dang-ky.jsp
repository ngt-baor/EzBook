<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Khach Hang Dang Ky</title>
</head>
<body>
<div style="width: 420px; margin: 40px auto; border: 1px solid #ccc; border-radius: 6px; padding: 20px; font-family: Arial, sans-serif;">
    <h2 style="text-align: center;">Dang Ky Tai Khoan Khach Hang</h2>

    <c:if test="${param.error == 'missing-data'}">
        <p style="color: red;">Vui long nhap day du thong tin.</p>
    </c:if>
    <c:if test="${param.error == 'password-not-match'}">
        <p style="color: red;">Mat khau xac nhan khong khop.</p>
    </c:if>
    <c:if test="${param.error == 'register-failed'}">
        <p style="color: red;">Dang ky that bai. So dien thoai co the da ton tai.</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/khach-hang/dang-ky" method="post">
        <label>Ho ten</label><br>
        <input type="text" name="ho_ten" style="width: 100%; padding: 6px;" required><br><br>

        <label>So dien thoai (dong thoi la tai khoan)</label><br>
        <input type="text" name="sdt" style="width: 100%; padding: 6px;" required><br><br>

        <label>Mat khau</label><br>
        <input type="password" name="mat_khau" style="width: 100%; padding: 6px;" required><br><br>

        <label>Xac nhan mat khau</label><br>
        <input type="password" name="xac_nhan_mat_khau" style="width: 100%; padding: 6px;" required><br><br>

        <button type="submit" style="width: 100%; padding: 8px;">Dang ky</button>
    </form>

    <p style="text-align: center; margin-top: 14px;">
        Da co tai khoan?
        <a href="${pageContext.request.contextPath}/khach-hang/dang-nhap.jsp">Dang nhap</a>
    </p>
</div>
</body>
</html>
