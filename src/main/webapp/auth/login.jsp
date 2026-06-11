<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Đăng Nhập He Thong EZBook</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="auth-shell">
  <h1 class="auth-title">EZBook Admin</h1>
  <p class="auth-subtitle">Đăng nhập nhân viên / admin</p>

  <c:if test="${param.msg == 'logged-out'}">
    <p class="alert success">Bạn đã đăng xuất.</p>
  </c:if>
  <c:if test="${param.msg == 'reset-success'}">
    <p class="alert success">Đặt lại mật khẩu thành công, vui long đăng nhập lại.</p>
  </c:if>

  <c:if test="${param.error == 'invalid'}">
    <p class="alert error">Tài khoản hoặc mật khẩu không chính xác.</p>
  </c:if>
  <c:if test="${param.error == 'blocked'}">
    <p class="alert error">Tài khoản đang bị khóa.</p>
  </c:if>
  <c:if test="${param.error == 'forbidden'}">
    <p class="alert error">Bạn không có quyền truy cập chức năng này.</p>
  </c:if>
  <c:if test="${param.error == 'role-not-allowed'}">
    <p class="alert error">Tài khoản này không thuộc nhóm nhân viên/admin.</p>
  </c:if>
  <c:if test="${param.error == 'missing-data'}">
    <p class="alert error">Vui lòng nhập đầy đủ thông tin đăng nhập.</p>
  </c:if>
  <c:if test="${param.error == 'login-required'}">
    <p class="alert error">Bạn cần đăng nhập truoc khi truy cap chức năng này.</p>
  </c:if>

  <form action="${pageContext.request.contextPath}/login" method="post">
    <div class="form-grid">
      <label class="field">
        <span>Tài khoản</span>
        <input type="text" name="username" placeholder="username / SĐT / mã NV / Gmail" required>
      </label>

      <label class="field">
        <span>Mật khẩu</span>
        <input type="password" name="password" required>
      </label>
    </div>

    <div class="form-actions">
      <button class="btn-block" type="submit">Đăng nhập</button>
    </div>
  </form>

  <div class="auth-links">
    <a href="${pageContext.request.contextPath}/auth/forgot-password.jsp">Quên mật khẩu</a>
    <a href="${pageContext.request.contextPath}/khach-hang/dang-nhap.jsp">Đăng nhập khách hàng</a>
    <a href="${pageContext.request.contextPath}/khach-hang/dang-ky.jsp">Đăng ký khách hàng</a>
  </div>
</div>
</body>
</html>
