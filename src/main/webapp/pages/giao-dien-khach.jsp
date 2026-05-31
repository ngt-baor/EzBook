<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    if (username == null || role == null || !"USER".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp?error=unauthorized");
        return;
    }
%>
<html>
<head>
    <title>Giao Dien Khach Hang</title>
</head>
<body>
<div style="width: 680px; margin: 40px auto; border: 1px solid #ccc; border-radius: 6px; padding: 20px;">
    <h2>Giao Dien Khach Hang</h2>
    <p>Xin chao <strong><%= username %></strong></p>

    <hr>
    <h3>Chuc nang nhanh</h3>
    <ul>
        <li><a href="<%= request.getContextPath() %>/auth/forgot-password.jsp">Dat lai mat khau</a></li>
        <li><a href="<%= request.getContextPath() %>/logout">Dang xuat</a></li>
    </ul>
</div>
</body>
</html>
