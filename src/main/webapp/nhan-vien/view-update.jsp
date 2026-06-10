<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Cập Nhật Nhân Viên</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="auth-shell">
  <header class="page-header">
    <div class="page-heading">
      <p class="eyebrow">Admin Workspace</p>
      <h1 class="page-title">Cập Nhật Nhân Viên</h1>
      <p class="page-subtitle">Điều chỉnh nhanh thông tin, vai trò và trạng thái làm việc mà không rời khỏi luồng quản lý nhân sự.</p>
    </div>
  </header>

  <div class="panel">
    <div class="panel-head">
      <h2>${nv.id}</h2>
      <span class="meta-chip">Edit mode</span>
    </div>
    <div class="panel-body">
      <form action="${pageContext.request.contextPath}/nhan-vien/sua" method="post">
        <input type="hidden" name="id" value="${nv.id}">

        <div class="form-grid">
          <label class="field">
            <span>Mã nhân viên</span>
            <input type="text" value="${nv.id}" readonly>
          </label>
          <label class="field">
            <span>Họ tên</span>
            <input type="text" name="ho_ten" value="${nv.ho_ten}" required>
          </label>
          <label class="field">
            <span>Số điện thoại</span>
            <input type="text" name="sdt" value="${nv.sdt}">
          </label>
          <label class="field">
            <span>Vai trò</span>
            <select name="vai_tro">
              <option value="Ky thuat vien Truong" ${nv.vai_tro == 'Ky thuat vien Truong' ? 'selected' : ''}>Kỹ thuật viên Trưởng</option>
              <option value="Nhan vien Ky thuat" ${nv.vai_tro == 'Nhan vien Ky thuat' ? 'selected' : ''}>Nhân viên Kỹ thuật</option>
              <option value="Tiep tan" ${nv.vai_tro == 'Tiep tan' ? 'selected' : ''}>Tiếp tân</option>
            </select>
          </label>
          <div class="choice-group">
            <span>Trạng thái</span>
            <div class="choice-row">
              <label class="choice-pill">
                <input type="radio" name="trang_thai" value="true" ${nv.trang_thai ? 'checked' : ''}>
                Đang làm việc
              </label>
              <label class="choice-pill">
                <input type="radio" name="trang_thai" value="false" ${!nv.trang_thai ? 'checked' : ''}>
                Tạm nghỉ
              </label>
            </div>
          </div>
        </div>

        <div class="form-actions">
          <button type="submit">Cập nhật</button>
          <a class="btn btn-muted" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Quay lại</a>
        </div>
      </form>
    </div>
  </div>
</div>
</body>
</html>
