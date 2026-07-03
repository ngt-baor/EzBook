<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<html>
<head>
    <title>Quản Lý Dịch Vụ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=ui-20260703">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Admin Workspace</p>
            <h1 class="page-title">Quản Lý Dịch Vụ</h1>
            <p class="page-subtitle">Tách ro thao tác voi loai dịch vụ và dịch vụ, ưu tiên form lớn để nhập liệu nhanh và bảng full-width để kiểm tra lại dữ liệu.</p>
        </div>
        <nav class="toolbar">
            
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chủ</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Nhân viên</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Tài khoản</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dịch vụ</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Khuyến mãi</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hóa đơn</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/thong-ke/hien-thi">Thống kê</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Hồ sơ</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Loại dịch vụ</span>
            <strong>${listLoaiDichVu.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Dịch vụ</span>
            <strong>${listDichVu.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Quyền truy cập</span>
            <strong>Admin only</strong>
        </article>
    </section>

    <c:if test="${param.msg != null}">
        <p class="alert success">Thành công: ${param.msg}</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p class="alert error">Lỗi: ${param.error}</p>
    </c:if>

    <section class="workspace-grid equal-col">
        <article class="panel">
            <div class="panel-head">
                <h2>${editingLoai != null ? 'Sửa Loại Dịch Vụ' : 'Thêm Loại Dịch Vụ'}</h2>
                <span class="meta-chip">Loại</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}${editingLoai != null ? '/admin/quan-ly-dich-vu/loai/sua' : '/admin/quan-ly-dich-vu/loai/them'}" method="post">
                    <div class="form-grid">
                        <label class="field">
                            <span>Mã loại</span>
                            <input type="text" name="id" value="${editingLoai.id}" ${editingLoai != null ? 'readonly' : ''} required>
                        </label>
                        <label class="field">
                            <span>Tên loại</span>
                            <input type="text" name="ten_loai" value="${editingLoai.ten_loai}" required>
                        </label>
                        <label class="field">
                            <span>Mô tả</span>
                            <textarea name="mo_ta" rows="4">${editingLoai.mo_ta}</textarea>
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="submit">${editingLoai != null ? 'Cập nhật loại' : 'Thêm loại'}</button>
                        <c:if test="${editingLoai != null}">
                            <a class="btn btn-muted" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Hủy sửa</a>
                        </c:if>
                    </div>
                </form>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>${editingDichVu != null ? 'Sửa Dịch Vụ' : 'Thêm Dịch Vụ'}</h2>
                <span class="meta-chip">Service</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}${editingDichVu != null ? '/admin/quan-ly-dich-vu/dich-vu/sua' : '/admin/quan-ly-dich-vu/dich-vu/them'}" method="post">
                    <div class="form-grid">
                        <label class="field">
                            <span>Mã dịch vụ</span>
                            <input type="text" name="id" value="${editingDichVu.id}" ${editingDichVu != null ? 'readonly' : ''} required>
                        </label>
                        <label class="field">
                            <span>Loại dịch vụ</span>
                            <select name="loai_dich_vu_id" required>
                                <option value="">-- Chọn loại --</option>
                                <c:forEach items="${listLoaiDichVu}" var="ldv">
                                    <option value="${ldv.id}" ${editingDichVu != null && editingDichVu.loai_dich_vu_id == ldv.id ? 'selected' : ''}>${ldv.id} - ${ldv.ten_loai}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Tên dịch vụ</span>
                            <input type="text" name="ten_dich_vu" value="${editingDichVu.ten_dich_vu}" required>
                        </label>
                        <label class="field">
                            <span>Giá tiền</span>
                            <input type="number" min="0" step="1000" name="gia_tien" value="${editingDichVu.gia_tien}" required>
                        </label>
                        <label class="field">
                            <span>Trạng thái</span>
                            <select name="trang_thai">
                                <option value="true" ${editingDichVu == null || editingDichVu.trang_thai ? 'selected' : ''}>Hoạt động</option>
                                <option value="false" ${editingDichVu != null && !editingDichVu.trang_thai ? 'selected' : ''}>Ngừng</option>
                            </select>
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="submit">${editingDichVu != null ? 'Cập nhật dịch vụ' : 'Thêm dịch vụ'}</button>
                        <c:if test="${editingDichVu != null}">
                            <a class="btn btn-muted" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Hủy sửa</a>
                        </c:if>
                    </div>
                </form>
            </div>
        </article>
    </section>

    <section class="content-stack">
        <article class="panel">
            <div class="panel-head">
                <h2>Danh Sách Loại Dịch Vụ</h2>
                <span class="meta-chip">${listLoaiDichVu.size()} muc</span>
            </div>
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Mã loại</th>
                        <th>Tên loại</th>
                        <th>Mô tả</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${listLoaiDichVu}" var="ldv">
                        <tr>
                            <td>${ldv.id}</td>
                            <td>${ldv.ten_loai}</td>
                            <td>${ldv.mo_ta}</td>
                            <td>
                                <div class="table-actions" style="display:flex; flex-wrap:nowrap; align-items:center; gap:8px; white-space:nowrap;">
                                    <a class="btn btn-muted btn-compact table-link invoice-action-btn"
                                       style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1; text-decoration:none;"
                                       href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu?editLoaiId=${ldv.id}">Sửa</a>
                                    <form action="${pageContext.request.contextPath}/admin/quan-ly-dich-vu/loai/xoa" method="post" style="display:inline-flex; margin:0;">
                                        <input type="hidden" name="id" value="${ldv.id}">
                                        <button class="invoice-action-btn"
                                                style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1;"
                                                type="submit" onclick="return confirm('Xóa loại dịch vụ này?')">Xóa</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>Danh Sách Dịch Vụ</h2>
                <span class="meta-chip">${listDichVu.size()} muc</span>
            </div>
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Mã DV</th>
                        <th>Tên dịch vụ</th>
                        <th>Loại</th>
                        <th>Giá tiền</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${listDichVu}" var="dv">
                        <tr>
                            <td>${dv.id}</td>
                            <td>${dv.ten_dich_vu}</td>
                            <td>
                                <c:forEach items="${listLoaiDichVu}" var="ldv">
                                    <c:if test="${ldv.id == dv.loai_dich_vu_id}">
                                        ${ldv.ten_loai}
                                    </c:if>
                                </c:forEach>
                            </td>
                            <td><fmt:formatNumber value="${dv.gia_tien}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</td>
                            <td>${dv.trang_thai ? 'Hoạt động' : 'Ngừng'}</td>
                            <td>
                                <div class="table-actions" style="display:flex; flex-wrap:nowrap; align-items:center; gap:8px; white-space:nowrap;">
                                    <a class="btn btn-muted btn-compact table-link invoice-action-btn"
                                       style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1; text-decoration:none;"
                                       href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu?editDichVuId=${dv.id}">Sửa</a>
                                    <form action="${pageContext.request.contextPath}/admin/quan-ly-dich-vu/dich-vu/xoa" method="post" style="display:inline-flex; margin:0;">
                                        <input type="hidden" name="id" value="${dv.id}">
                                        <button class="invoice-action-btn"
                                                style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1;"
                                                type="submit" onclick="return confirm('Xóa dịch vụ này?')">Xóa</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </article>
    </section>
</div>
</body>
</html>

