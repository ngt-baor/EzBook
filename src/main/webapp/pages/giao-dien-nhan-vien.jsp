<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Giao Dien Nhan Vien</title>
</head>
<body>
<div style="width: 680px; margin: 40px auto; border: 1px solid #ccc; border-radius: 6px; padding: 20px;">
    <h2>Giao Dien Nhan Vien</h2>
    <p>Che do khong dang nhap dang bat.</p>

    <hr>
    <h3>Chuc nang nhanh</h3>
    <ul>
        <li><a href="<%= request.getContextPath() %>/nhan-vien/hien-thi">Quan ly nhan vien</a></li>
        <li><a href="<%= request.getContextPath() %>/booking/hien-thi">Quan ly booking + thong ke</a></li>
        <li><a href="<%= request.getContextPath() %>/auth/forgot-password.jsp">Doi/Dat lai mat khau</a></li>
        <li><a href="<%= request.getContextPath() %>/pages/giao-dien-khach.jsp">Trang khach hang</a></li>
    </ul>
</div>
</body>
</html>
