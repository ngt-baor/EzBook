<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Dang Nhap He Thong EZBook</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div style="width: 420px; margin: 50px auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; font-family: Arial, sans-serif;">
  <h2 style="text-align: center">DANG NHAP NHAN VIEN / ADMIN</h2>

  <c:if test="${param.msg == 'logged-out'}">
    <p style="color: green; text-align: center;">Ban da dang xuat.</p>
  </c:if>
  <c:if test="${param.msg == 'reset-success'}">
    <p style="color: green; text-align: center;">Dat lai mat khau thanh cong, vui long dang nhap lai.</p>
  </c:if>

  <c:if test="${param.error == 'invalid'}">
    <p style="color: red; text-align: center;">Tai khoan hoac mat khau khong chinh xac.</p>
  </c:if>
  <c:if test="${param.error == 'blocked'}">
    <p style="color: red; text-align: center;">Tai khoan dang bi khoa.</p>
  </c:if>
  <c:if test="${param.error == 'forbidden'}">
    <p style="color: red; text-align: center;">Ban khong co quyen truy cap chuc nang nay.</p>
  </c:if>
  <c:if test="${param.error == 'role-not-allowed'}">
    <p style="color: red; text-align: center;">Tai khoan nay khong thuoc nhom nhan vien/admin.</p>
  </c:if>
  <c:if test="${param.error == 'missing-data'}">
    <p style="color: red; text-align: center;">Vui long nhap day du thong tin dang nhap.</p>
  </c:if>
  <c:if test="${param.error == 'login-required'}">
    <p style="color: red; text-align: center;">Ban can dang nhap truoc khi truy cap chuc nang nay.</p>
  </c:if>

  <form action="${pageContext.request.contextPath}/login" method="post">
    <label>Tai khoan (username / SDT / ma NV)</label><br>
    <input type="text" name="username" style="width: 100%; padding: 6px;" required><br><br>

    <label>Mat khau</label><br>
    <input type="password" name="password" style="width: 100%; padding: 6px;" required><br><br>

    <button type="submit" style="width: 100%; padding: 8px;">Dang nhap</button>
  </form>

  <p style="text-align:center; margin-top: 12px;">
    <a href="${pageContext.request.contextPath}/auth/forgot-password.jsp">Quen mat khau</a>
  </p>
  <p style="text-align:center; margin-top: 8px;">
    <a href="${pageContext.request.contextPath}/khach-hang/dang-nhap.jsp">Dang nhap khach hang</a>
    |
    <a href="${pageContext.request.contextPath}/khach-hang/dang-ky.jsp">Dang ky khach hang</a>
  </p>
</div>
</body>
</html>
