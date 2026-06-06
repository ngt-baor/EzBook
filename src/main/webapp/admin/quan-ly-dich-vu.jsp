<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quan Ly Dich Vu</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Admin Workspace</p>
            <h1 class="page-title">Quan Ly Dich Vu</h1>
            <p class="page-subtitle">Tach ro thao tac voi loai dich vu va dich vu, uu tien form lon de nhap lieu nhanh va bang full-width de kiem tra lai du lieu.</p>
        </div>
        <nav class="toolbar">
            
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chu</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Nhan vien</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Tai khoan</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dich vu</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hoa don</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Dang xuat</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Loai dich vu</span>
            <strong>${listLoaiDichVu.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Dich vu</span>
            <strong>${listDichVu.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Quyen truy cap</span>
            <strong>Admin only</strong>
        </article>
    </section>

    <c:if test="${param.msg != null}">
        <p class="alert success">Thanh cong: ${param.msg}</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p class="alert error">Loi: ${param.error}</p>
    </c:if>

    <section class="workspace-grid equal-col">
        <article class="panel">
            <div class="panel-head">
                <h2>${editingLoai != null ? 'Sua Loai Dich Vu' : 'Them Loai Dich Vu'}</h2>
                <span class="meta-chip">Loai</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}${editingLoai != null ? '/admin/quan-ly-dich-vu/loai/sua' : '/admin/quan-ly-dich-vu/loai/them'}" method="post">
                    <div class="form-grid">
                        <label class="field">
                            <span>Ma loai</span>
                            <input type="text" name="id" value="${editingLoai.id}" ${editingLoai != null ? 'readonly' : ''} required>
                        </label>
                        <label class="field">
                            <span>Ten loai</span>
                            <input type="text" name="ten_loai" value="${editingLoai.ten_loai}" required>
                        </label>
                        <label class="field">
                            <span>Mo ta</span>
                            <textarea name="mo_ta" rows="4">${editingLoai.mo_ta}</textarea>
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="submit">${editingLoai != null ? 'Cap nhat loai' : 'Them loai'}</button>
                        <c:if test="${editingLoai != null}">
                            <a class="btn btn-muted" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Huy sua</a>
                        </c:if>
                    </div>
                </form>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>${editingDichVu != null ? 'Sua Dich Vu' : 'Them Dich Vu'}</h2>
                <span class="meta-chip">Service</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}${editingDichVu != null ? '/admin/quan-ly-dich-vu/dich-vu/sua' : '/admin/quan-ly-dich-vu/dich-vu/them'}" method="post">
                    <div class="form-grid">
                        <label class="field">
                            <span>Ma dich vu</span>
                            <input type="text" name="id" value="${editingDichVu.id}" ${editingDichVu != null ? 'readonly' : ''} required>
                        </label>
                        <label class="field">
                            <span>Loai dich vu</span>
                            <select name="loai_dich_vu_id" required>
                                <option value="">-- Chon loai --</option>
                                <c:forEach items="${listLoaiDichVu}" var="ldv">
                                    <option value="${ldv.id}" ${editingDichVu != null && editingDichVu.loai_dich_vu_id == ldv.id ? 'selected' : ''}>${ldv.id} - ${ldv.ten_loai}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Ten dich vu</span>
                            <input type="text" name="ten_dich_vu" value="${editingDichVu.ten_dich_vu}" required>
                        </label>
                        <label class="field">
                            <span>Gia tien</span>
                            <input type="number" min="0" step="1000" name="gia_tien" value="${editingDichVu.gia_tien}" required>
                        </label>
                        <label class="field">
                            <span>Trang thai</span>
                            <select name="trang_thai">
                                <option value="true" ${editingDichVu == null || editingDichVu.trang_thai ? 'selected' : ''}>Hoat dong</option>
                                <option value="false" ${editingDichVu != null && !editingDichVu.trang_thai ? 'selected' : ''}>Ngung</option>
                            </select>
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="submit">${editingDichVu != null ? 'Cap nhat dich vu' : 'Them dich vu'}</button>
                        <c:if test="${editingDichVu != null}">
                            <a class="btn btn-muted" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Huy sua</a>
                        </c:if>
                    </div>
                </form>
            </div>
        </article>
    </section>

    <section class="content-stack">
        <article class="panel">
            <div class="panel-head">
                <h2>Danh Sach Loai Dich Vu</h2>
                <span class="meta-chip">${listLoaiDichVu.size()} muc</span>
            </div>
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Ma loai</th>
                        <th>Ten loai</th>
                        <th>Mo ta</th>
                        <th>Hanh dong</th>
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
                                       href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu?editLoaiId=${ldv.id}">Sua</a>
                                    <form action="${pageContext.request.contextPath}/admin/quan-ly-dich-vu/loai/xoa" method="post" style="display:inline-flex; margin:0;">
                                        <input type="hidden" name="id" value="${ldv.id}">
                                        <button class="invoice-action-btn"
                                                style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1;"
                                                type="submit" onclick="return confirm('Xoa loai dich vu nay?')">Xoa</button>
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
                <h2>Danh Sach Dich Vu</h2>
                <span class="meta-chip">${listDichVu.size()} muc</span>
            </div>
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Ma DV</th>
                        <th>Ten dich vu</th>
                        <th>Loai</th>
                        <th>Gia tien</th>
                        <th>Trang thai</th>
                        <th>Hanh dong</th>
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
                            <td>${dv.gia_tien}</td>
                            <td>${dv.trang_thai ? 'Hoat dong' : 'Ngung'}</td>
                            <td>
                                <div class="table-actions" style="display:flex; flex-wrap:nowrap; align-items:center; gap:8px; white-space:nowrap;">
                                    <a class="btn btn-muted btn-compact table-link invoice-action-btn"
                                       style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1; text-decoration:none;"
                                       href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu?editDichVuId=${dv.id}">Sua</a>
                                    <form action="${pageContext.request.contextPath}/admin/quan-ly-dich-vu/dich-vu/xoa" method="post" style="display:inline-flex; margin:0;">
                                        <input type="hidden" name="id" value="${dv.id}">
                                        <button class="invoice-action-btn"
                                                style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1;"
                                                type="submit" onclick="return confirm('Xoa dich vu nay?')">Xoa</button>
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
