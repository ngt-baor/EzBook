<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Đăng Nhập Hệ Thống EZBook</title>
</head>
<body>
<div style="width: 350px; margin: 50px auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px;">
  <h2 style="text-align: center">ĐĂNG NHẬP</h2>

  <c:if test="${param.error == 'invalid'}">
    <p style="color: red; text-align: center;">Tài khoản hoặc mật khẩu không chính xác!</p>
  </c:if>
  <c:if test="${param.error == 'blocked'}">
    <p style="color: red; text-align: center;">Tài khoản của bạn hiện đang bị khóa!</p>
  </c:if>
  <c:if test="${param.msg == 'reset-success'}">
    <p style="color: green; text-align: center;">Đổi mật khẩu thành công. Bạn hãy đăng nhập lại.</p>
  </c:if>

  <form action="/login" method="post">
    <label>Tài khoản (Username hoặc Mã NV hoặc Số điện thoại):</label><br>
    <input type="text" name="username" style="width: 100%; padding: 5px;" required><br><br>

    <label>Mật khẩu:</label><br>
    <input type="password" name="password" style="width: 100%; padding: 5px;" required><br><br>

    <button type="submit" style="width: 100%; padding: 8px; background-color: #28a745; color: white; border: none; cursor: pointer;">
      Đăng nhập
    </button>
  </form>

  <p style="text-align:center; margin-top: 12px;">
    <a href="${pageContext.request.contextPath}/auth/forgot-password.jsp">Quên mật khẩu?</a>
  </p>
</div>
</body>
</html>
