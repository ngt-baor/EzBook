<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Quen Mat Khau - EZBook</title>
</head>
<body>
<div style="width: 420px; margin: 50px auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px;">
  <h2 style="text-align: center;">QUEN MAT KHAU</h2>
  <c:if test="${param.error == 'missing-username'}">
    <p style="color: red; text-align: center;">Vui long nhap tai khoan.</p>
  </c:if>
  <c:if test="${param.error == 'username-not-found'}">
    <p style="color: red; text-align: center;">Tai khoan khong ton tai.</p>
  </c:if>
  <c:if test="${param.error == 'missing-data'}">
    <p style="color: red; text-align: center;">Vui long nhap day du thong tin.</p>
  </c:if>
  <c:if test="${param.error == 'password-not-match'}">
    <p style="color: red; text-align: center;">Mat khau xac nhan khong khop.</p>
  </c:if>
  <c:if test="${param.error == 'system'}">
    <p style="color: red; text-align: center;">He thong tam loi, vui long thu lai.</p>
  </c:if>
  <form action="${pageContext.request.contextPath}/account/quen-mat-khau" method="post">
    <label>Tai khoan (username):</label><br>
    <input type="text" name="username" style="width: 100%; padding: 6px;" required><br><br>
    <label>Mat khau moi:</label><br>
    <input type="password" name="mat_khau_moi" style="width: 100%; padding: 6px;" required><br><br>
    <label>Xac nhan mat khau moi:</label><br>
    <input type="password" name="mat_khau_moi_xac_nhan" style="width: 100%; padding: 6px;" required><br><br>
    <button type="submit" style="width: 100%; padding: 8px; background-color: #28a745; color: white; border: none; cursor: pointer;">
      Dat Lai Mat Khau
    </button>
  </form>
  <p style="text-align: center; margin-top: 14px;">
    <a href="${pageContext.request.contextPath}/auth/login.jsp">Quay lai dang nhap</a>
  </p>
</div>
</body>
</html>