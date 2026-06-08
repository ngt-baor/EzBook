<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Quen Mat Khau - EZBook</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="auth-shell">
  <h1 class="auth-title">Quen Mat Khau</h1>
  <p class="auth-subtitle">Dat lai mat khau khong dung OTP</p>

  <c:if test="${param.error == 'missing-username'}">
    <p class="alert error">Vui long nhap tai khoan.</p>
  </c:if>
  <c:if test="${param.error == 'username-not-found'}">
    <p class="alert error">Tai khoan khong ton tai.</p>
  </c:if>
  <c:if test="${param.error == 'missing-data'}">
    <p class="alert error">Vui long nhap day du thong tin.</p>
  </c:if>
  <c:if test="${param.error == 'password-not-match'}">
    <p class="alert error">Mat khau xac nhan khong khop.</p>
  </c:if>
  <c:if test="${param.error == 'system'}">
    <p class="alert error">He thong tam loi, vui long thu lai.</p>
  </c:if>

  <form action="${pageContext.request.contextPath}/account/quen-mat-khau" method="post">
    <div class="form-grid">
      <label class="field">
        <span>Tai khoan</span>
        <input type="text" name="username" required>
      </label>
      <label class="field">
        <span>Mat khau moi</span>
        <input type="password" name="mat_khau_moi" required>
      </label>
      <label class="field">
        <span>Xac nhan mat khau moi</span>
        <input type="password" name="mat_khau_moi_xac_nhan" required>
      </label>
    </div>
    <div class="form-actions">
      <button class="btn-block" type="submit">Dat lai mat khau</button>
    </div>
  </form>

  <div class="auth-links">
    <a href="${pageContext.request.contextPath}/auth/login.jsp">Quay lai dang nhap</a>
  </div>
</div>
</body>
</html>

