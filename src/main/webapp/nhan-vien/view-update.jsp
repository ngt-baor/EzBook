<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Cap Nhat Nhan Vien</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div class="auth-shell">
  <header class="page-header">
    <div class="page-heading">
      <p class="eyebrow">Admin Workspace</p>
      <h1 class="page-title">Cap Nhat Nhan Vien</h1>
      <p class="page-subtitle">Dieu chinh nhanh thong tin, vai tro va trang thai lam viec ma khong roi khoi luong quan ly nhan su.</p>
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
            <span>Ma nhan vien</span>
            <input type="text" value="${nv.id}" readonly>
          </label>
          <label class="field">
            <span>Ho ten</span>
            <input type="text" name="ho_ten" value="${nv.ho_ten}" required>
          </label>
          <label class="field">
            <span>So dien thoai</span>
            <input type="text" name="sdt" value="${nv.sdt}">
          </label>
          <label class="field">
            <span>Vai tro</span>
            <select name="vai_tro">
              <option value="Ky thuat vien Truong" ${nv.vai_tro == 'Ky thuat vien Truong' ? 'selected' : ''}>Ky thuat vien Truong</option>
              <option value="Nhan vien Ky thuat" ${nv.vai_tro == 'Nhan vien Ky thuat' ? 'selected' : ''}>Nhan vien Ky thuat</option>
              <option value="Tiep tan" ${nv.vai_tro == 'Tiep tan' ? 'selected' : ''}>Tiep tan</option>
            </select>
          </label>
          <div class="choice-group">
            <span>Trang thai</span>
            <div class="choice-row">
              <label class="choice-pill">
                <input type="radio" name="trang_thai" value="true" ${nv.trang_thai ? 'checked' : ''}>
                Dang lam viec
              </label>
              <label class="choice-pill">
                <input type="radio" name="trang_thai" value="false" ${!nv.trang_thai ? 'checked' : ''}>
                Tam nghi
              </label>
            </div>
          </div>
        </div>

        <div class="form-actions">
          <button type="submit">Cap nhat</button>
          <a class="btn btn-muted" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Quay lai</a>
        </div>
      </form>
    </div>
  </div>
</div>
</body>
</html>
