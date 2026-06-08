<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quan Ly Khuyen Mai</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Promotion Workspace</p>
            <h1 class="page-title">Quan Ly Khuyen Mai</h1>
            <p class="page-subtitle">Tao va dieu chinh ma giam gia de ap dung truc tiep vao booking va hoa don.</p>
        </div>
        <nav class="toolbar">
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chu</a>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a class="toolbar-link" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Nhan vien</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Tai khoan</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dich vu</a>
            </c:if>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Khuyen mai</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hoa don</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/thong-ke/hien-thi">Thong ke</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Dang xuat</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Tong ma</span>
            <strong>${listKhuyenMai.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Quyen truy cap</span>
            <strong>${canManageKhuyenMai ? 'Admin CRUD' : 'Chi xem'}</strong>
        </article>
        <article class="stat-card">
            <span>Ap dung</span>
            <strong>Booking / Hoa don</strong>
        </article>
    </section>

    <c:if test="${param.msg != null}">
        <p class="alert success">Thanh cong: ${param.msg}</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p class="alert error">Loi: ${param.error}</p>
    </c:if>

    <article class="panel">
        <div class="panel-head">
            <h2>Tim Kiem Va Loc Khuyen Mai</h2>
            <span class="meta-chip">Promotion filter</span>
        </div>
        <div class="panel-body">
            <form action="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai" method="get">
                <div class="form-grid four-col">
                    <label class="field">
                        <span>Tu khoa</span>
                        <input type="text" name="tuKhoa" value="${param.tuKhoa}" placeholder="Ma KM hoac ma giam gia">
                    </label>
                    <label class="field">
                        <span>Loai giam</span>
                        <select name="loaiGiam">
                            <option value="">Tat ca loai</option>
                            <option value="Phan tram" ${param.loaiGiam == 'Phan tram' ? 'selected' : ''}>Phan tram</option>
                            <option value="So tien co dinh" ${param.loaiGiam == 'So tien co dinh' ? 'selected' : ''}>So tien co dinh</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Trang thai</span>
                        <select name="trangThai">
                            <option value="">Tat ca trang thai</option>
                            <option value="active" ${param.trangThai == 'active' ? 'selected' : ''}>Hoat dong</option>
                            <option value="inactive" ${param.trangThai == 'inactive' ? 'selected' : ''}>Tam ngung</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Hieu luc</span>
                        <select name="hieuLuc">
                            <option value="">Tat ca hieu luc</option>
                            <option value="usable" ${param.hieuLuc == 'usable' ? 'selected' : ''}>Dang dung duoc</option>
                            <option value="upcoming" ${param.hieuLuc == 'upcoming' ? 'selected' : ''}>Sap dien ra</option>
                            <option value="expired" ${param.hieuLuc == 'expired' ? 'selected' : ''}>Da het han</option>
                            <option value="out-of-stock" ${param.hieuLuc == 'out-of-stock' ? 'selected' : ''}>Het luot</option>
                        </select>
                    </label>
                    <div class="field">
                        <span>Ket qua</span>
                        <p class="panel-note">Dang hien thi ${listKhuyenMai.size()} ma khuyen mai theo dieu kien loc.</p>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" style="background:#0f766e; color:#fff8e6;">Loc khuyen mai</button>
                    <a class="btn btn-muted" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Xoa bo loc</a>
                </div>
            </form>
        </div>
    </article>

    <c:if test="${canManageKhuyenMai}">
    <article class="panel" style="margin-top:32px;">
        <div class="panel-head">
            <h2>${editingKhuyenMai != null ? 'Sua Khuyen Mai' : 'Them Khuyen Mai'}</h2>
            <span class="meta-chip">Promotion form</span>
        </div>
        <div class="panel-body">
            <form action="${pageContext.request.contextPath}${editingKhuyenMai != null ? '/admin/quan-ly-khuyen-mai/sua' : '/admin/quan-ly-khuyen-mai/them'}" method="post">
                <div class="form-grid four-col">
                    <label class="field">
                        <span>Ma KM</span>
                        <input type="text" name="id" value="${editingKhuyenMai.id}" ${editingKhuyenMai != null ? 'readonly' : ''} required>
                    </label>
                    <label class="field">
                        <span>Ma giam gia</span>
                        <input type="text" name="ma_giam_gia" value="${editingKhuyenMai.ma_giam_gia}" placeholder="CHAOHE" required>
                    </label>
                    <label class="field">
                        <span>Loai giam</span>
                        <select name="loai_giam" required>
                            <option value="Phan tram" ${editingKhuyenMai == null || editingKhuyenMai.loai_giam == 'Phan tram' ? 'selected' : ''}>Phan tram</option>
                            <option value="So tien co dinh" ${editingKhuyenMai != null && editingKhuyenMai.loai_giam == 'So tien co dinh' ? 'selected' : ''}>So tien co dinh</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Gia tri</span>
                        <input type="number" min="0" step="1000" name="gia_tri" value="${editingKhuyenMai.gia_tri}" required>
                    </label>
                    <label class="field">
                        <span>Ngay bat dau</span>
                        <input type="datetime-local" name="ngay_bat_dau" value="${editingNgayBatDau}" required>
                    </label>
                    <label class="field">
                        <span>Ngay ket thuc</span>
                        <input type="datetime-local" name="ngay_ket_thuc" value="${editingNgayKetThuc}" required>
                    </label>
                    <label class="field">
                        <span>So luong con lai</span>
                        <input type="number" min="0" step="1" name="so_luong_gioi_han" value="${editingKhuyenMai.so_luong_gioi_han}" required>
                    </label>
                    <label class="field">
                        <span>Trang thai</span>
                        <select name="trang_thai">
                            <option value="true" ${editingKhuyenMai == null || editingKhuyenMai.trang_thai ? 'selected' : ''}>Hoat dong</option>
                            <option value="false" ${editingKhuyenMai != null && !editingKhuyenMai.trang_thai ? 'selected' : ''}>Tam ngung</option>
                        </select>
                    </label>
                </div>
                <div class="form-actions">
                    <button type="submit" style="background:#0f766e; color:#fff8e6;">${editingKhuyenMai != null ? 'Cap nhat khuyen mai' : 'Them khuyen mai'}</button>
                    <c:if test="${editingKhuyenMai != null}">
                        <a class="btn btn-muted" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Huy sua</a>
                    </c:if>
                </div>
            </form>
        </div>
    </article>
    </c:if>

    <article class="panel" style="margin-top:32px;">
        <div class="panel-head">
            <h2>Danh Sach Khuyen Mai</h2>
            <span class="meta-chip">${listKhuyenMai.size()} muc</span>
        </div>
        <div class="table-wrap">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Ma KM</th>
                    <th>Ma giam gia</th>
                    <th>Loai</th>
                    <th>Gia tri</th>
                    <th>Bat dau</th>
                    <th>Ket thuc</th>
                    <th>Con lai</th>
                    <th>Trang thai</th>
                    <c:if test="${canManageKhuyenMai}">
                        <th>Hanh dong</th>
                    </c:if>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${listKhuyenMai}" var="km">
                    <tr>
                        <td>${km.id}</td>
                        <td>${km.ma_giam_gia}</td>
                        <td>${km.loai_giam}</td>
                        <td>${km.gia_tri}</td>
                        <td>${km.ngay_bat_dau}</td>
                        <td>${km.ngay_ket_thuc}</td>
                        <td>${km.so_luong_gioi_han}</td>
                        <td>${km.trang_thai ? 'Hoat dong' : 'Tam ngung'}</td>
                        <c:if test="${canManageKhuyenMai}">
                            <td>
                                <div class="table-actions" style="display:flex; flex-wrap:nowrap; align-items:center; gap:8px; white-space:nowrap;">
                                    <a class="btn btn-muted btn-compact table-link invoice-action-btn"
                                       style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1; text-decoration:none;"
                                       href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai?editId=${km.id}">Sua</a>
                                    <form action="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai/xoa" method="post" style="display:inline-flex; margin:0;">
                                        <input type="hidden" name="id" value="${km.id}">
                                        <button class="invoice-action-btn"
                                                style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1;"
                                                type="submit" onclick="return confirm('Xoa khuyen mai nay?')">Xoa</button>
                                    </form>
                                </div>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </article>
</div>
</body>
</html>
