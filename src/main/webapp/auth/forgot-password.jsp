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
  <p class="auth-subtitle">Nhập Gmail, nhận mã xác nhận rồi đặt lại mật khẩu</p>

  <c:if test="${param.error == 'missing-username'}">
    <p class="alert error">Vui lòng nhập Gmail.</p>
  </c:if>
  <c:if test="${param.error == 'missing-email'}">
    <p class="alert error">Vui lòng nhập Gmail để nhận mã xác nhận.</p>
  </c:if>
  <c:if test="${param.error == 'username-not-found'}">
    <p class="alert error">Gmail không tồn tại trong hệ thống.</p>
  </c:if>
  <c:if test="${param.error == 'invalid-email'}">
    <p class="alert error">Gmail không hợp lệ. Vui lòng nhập địa chỉ kết thúc bằng @gmail.com.</p>
  </c:if>
  <c:if test="${param.error == 'invalid-code'}">
    <p class="alert error">Mã xác nhận không chính xác.</p>
  </c:if>
  <c:if test="${param.error == 'mail-send-failed'}">
    <p class="alert error">Không gửi được mã về Gmail. Vui lòng kiểm tra cấu hình Gmail SMTP.</p>
  </c:if>
  <c:if test="${param.msg == 'code-sent'}">
    <p class="alert success">Đã gửi mã xác nhận về Gmail.</p>
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
        <span>Gmail</span>
        <input type="email" name="email" placeholder="ten@gmail.com" pattern="^[A-Za-z0-9._%+-]+@gmail\.com$" required>
      </label>
      <div class="field">
        <span>Mã xác nhận Gmail</span>
        <input type="text" name="ma_xac_nhan" maxlength="6" placeholder="Nhập mã 6 số" required>
        <button type="submit" formaction="${pageContext.request.contextPath}/account/quen-mat-khau/gui-ma" formnovalidate>Gửi mã</button>
      </div>
      <label class="field">
        <span>Mật khẩu mới</span>
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
