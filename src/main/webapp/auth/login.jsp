<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Dang Nhap He Thong EZBook</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div class="auth-shell">
  <h1 class="auth-title">EZBook Admin</h1>
  <p class="auth-subtitle">Dang nhap nhan vien / admin</p>

  <c:if test="${param.msg == 'logged-out'}">
    <p class="alert success">Ban da dang xuat.</p>
  </c:if>
  <c:if test="${param.msg == 'reset-success'}">
    <p class="alert success">Dat lai mat khau thanh cong, vui long dang nhap lai.</p>
  </c:if>

  <c:if test="${param.error == 'invalid'}">
    <p class="alert error">Tai khoan hoac mat khau khong chinh xac.</p>
  </c:if>
  <c:if test="${param.error == 'blocked'}">
    <p class="alert error">Tai khoan dang bi khoa.</p>
  </c:if>
  <c:if test="${param.error == 'forbidden'}">
    <p class="alert error">Ban khong co quyen truy cap chuc nang nay.</p>
  </c:if>
  <c:if test="${param.error == 'role-not-allowed'}">
    <p class="alert error">Tai khoan nay khong thuoc nhom nhan vien/admin.</p>
  </c:if>
  <c:if test="${param.error == 'missing-data'}">
    <p class="alert error">Vui long nhap day du thong tin dang nhap.</p>
  </c:if>
  <c:if test="${param.error == 'login-required'}">
    <p class="alert error">Ban can dang nhap truoc khi truy cap chuc nang nay.</p>
  </c:if>

  <form action="${pageContext.request.contextPath}/login" method="post">
    <div class="form-grid">
      <label class="field">
        <span>Tai khoan</span>
        <input type="text" name="username" placeholder="username / SDT / ma NV" required>
      </label>

      <label class="field">
        <span>Mat khau</span>
        <input type="password" name="password" required>
      </label>
    </div>

    <div class="form-actions">
      <button class="btn-block" type="submit">Dang nhap</button>
    </div>
  </form>

  <div class="auth-links">
    <a href="${pageContext.request.contextPath}/auth/forgot-password.jsp">Quen mat khau</a>
    <a href="${pageContext.request.contextPath}/khach-hang/dang-nhap.jsp">Dang nhap khach hang</a>
    <a href="${pageContext.request.contextPath}/khach-hang/dang-ky.jsp">Dang ky khach hang</a>
  </div>
</div>
</body>
</html>
