<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Quên Mật Khẩu - EZBook</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="auth-shell">
  <h1 class="auth-title">Quên Mật Khẩu</h1>
  <p class="auth-subtitle">Đặt lại mật khẩu không dùng OTP</p>

  <c:if test="${param.error == 'missing-username'}">
    <p class="alert error">Vui lòng nhập tài khoản.</p>
  </c:if>
  <c:if test="${param.error == 'username-not-found'}">
    <p class="alert error">Tài khoản không tồn tại.</p>
  </c:if>
  <c:if test="${param.error == 'missing-data'}">
    <p class="alert error">Vui lòng nhập đầy đủ thông tin.</p>
  </c:if>
  <c:if test="${param.error == 'password-not-match'}">
    <p class="alert error">Mật khẩu xác nhận không khớp.</p>
  </c:if>
  <c:if test="${param.error == 'system'}">
    <p class="alert error">Hệ thống tạm lỗi, vui lòng thử lại.</p>
  </c:if>

  <form action="${pageContext.request.contextPath}/account/quen-mat-khau" method="post">
    <div class="form-grid">
      <label class="field">
        <span>Tài khoản</span>
        <input type="text" name="username" required>
      </label>
      <label class="field">
        <span>Mật khẩu moi</span>
        <input type="password" name="mat_khau_moi" required>
      </label>
      <label class="field">
        <span>Xác nhận mật khẩu mới</span>
        <input type="password" name="mat_khau_moi_xac_nhan" required>
      </label>
    </div>
    <div class="form-actions">
      <button class="btn-block" type="submit">Đặt lại mật khẩu</button>
    </div>
  </form>

  <div class="auth-links">
    <a href="${pageContext.request.contextPath}/auth/login.jsp">Quay lại đăng nhập</a>
  </div>
</div>
</body>
</html>
