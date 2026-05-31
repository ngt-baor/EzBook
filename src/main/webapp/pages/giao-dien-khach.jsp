<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Giao Dien Khach Hang</title>
</head>
<body>
<div style="width: 680px; margin: 40px auto; border: 1px solid #ccc; border-radius: 6px; padding: 20px;">
    <h2>Giao Dien Khach Hang</h2>
    <p>Che do khong dang nhap dang bat.</p>

    <hr>
    <h3>Chuc nang nhanh</h3>
    <ul>
        <li><a href="<%= request.getContextPath() %>/auth/forgot-password.jsp">Dat lai mat khau</a></li>
        <li><a href="<%= request.getContextPath() %>/pages/giao-dien-nhan-vien.jsp">Trang nhan vien</a></li>
    </ul>
</div>
</body>
</html>
