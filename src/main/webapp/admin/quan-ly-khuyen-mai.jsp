<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quản Lý Khuyến Mãi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Promotion Workspace</p>
            <h1 class="page-title">Quản Lý Khuyến Mãi</h1>
            <p class="page-subtitle">Tạo và điều chỉnh mã giảm giá để áp dụng trực tiếp vào booking và hóa đơn.</p>
        </div>
        <nav class="toolbar">
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chủ</a>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a class="toolbar-link" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Nhân viên</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Tài khoản</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dịch vụ</a>
            </c:if>
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
            <span>Tổng mã</span>
            <strong>${listKhuyenMai.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Quyền truy cập</span>
            <strong>${canManageKhuyenMai ? 'Admin CRUD' : 'Chỉ xem'}</strong>
        </article>
        <article class="stat-card">
            <span>Áp dụng</span>
            <strong>Booking / Hóa đơn</strong>
        </article>
    </section>

    <c:if test="${param.msg != null}">
        <p class="alert success">Thành công: ${param.msg}</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p class="alert error">Lỗi: ${param.error}</p>
    </c:if>

    <article class="panel">
        <div class="panel-head">
            <h2>Tìm Kiếm Và Lọc Khuyến Mãi</h2>
            <span class="meta-chip">Promotion filter</span>
        </div>
        <div class="panel-body">
            <form action="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai" method="get">
                <div class="form-grid four-col">
                    <label class="field">
                        <span>Từ khóa</span>
                        <input type="text" name="tuKhoa" value="${param.tuKhoa}" placeholder="Mã KM hoặc mã giảm giá">
                    </label>
                    <label class="field">
                        <span>Loại giảm</span>
                        <select name="loaiGiam">
                            <option value="">Tất cả loại</option>
                            <option value="Phan tram" ${param.loaiGiam == 'Phan tram' ? 'selected' : ''}>Phần trăm</option>
                            <option value="So tien co dinh" ${param.loaiGiam == 'So tien co dinh' ? 'selected' : ''}>Số tiền cố định</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Trạng thái</span>
                        <select name="trangThai">
                            <option value="">Tất cả trạng thái</option>
                            <option value="active" ${param.trangThai == 'active' ? 'selected' : ''}>Hoạt động</option>
                            <option value="inactive" ${param.trangThai == 'inactive' ? 'selected' : ''}>Tạm ngừng</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Hiệu lực</span>
                        <select name="hieuLuc">
                            <option value="">Tất cả hiệu lực</option>
                            <option value="usable" ${param.hieuLuc == 'usable' ? 'selected' : ''}>Đang dùng được</option>
                            <option value="upcoming" ${param.hieuLuc == 'upcoming' ? 'selected' : ''}>Sắp diễn ra</option>
                            <option value="expired" ${param.hieuLuc == 'expired' ? 'selected' : ''}>Đã hết hạn</option>
                            <option value="out-of-stock" ${param.hieuLuc == 'out-of-stock' ? 'selected' : ''}>Hết lượt</option>
                        </select>
                    </label>
                    <div class="field">
                        <span>Kết quả</span>
                        <p class="panel-note">Đang hiển thị ${listKhuyenMai.size()} mã khuyến mãi theo điều kiện lọc.</p>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" style="background:#0f766e; color:#fff8e6;">Lọc khuyến mãi</button>
                    <a class="btn btn-muted" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Xóa bộ lọc</a>
                </div>
            </form>
        </div>
    </article>

    <c:if test="${canManageKhuyenMai}">
    <article class="panel" style="margin-top:32px;">
        <div class="panel-head">
            <h2>${editingKhuyenMai != null ? 'Sửa Khuyến Mãi' : 'Thêm Khuyến Mãi'}</h2>
            <span class="meta-chip">Promotion form</span>
        </div>
        <div class="panel-body">
            <form action="${pageContext.request.contextPath}${editingKhuyenMai != null ? '/admin/quan-ly-khuyen-mai/sua' : '/admin/quan-ly-khuyen-mai/them'}" method="post">
                <div class="form-grid four-col">
                    <label class="field">
                        <span>Mã KM</span>
                        <input type="text" name="id" value="${editingKhuyenMai.id}" ${editingKhuyenMai != null ? 'readonly' : ''} required>
                    </label>
                    <label class="field">
                        <span>Mã giảm giá</span>
                        <input type="text" name="ma_giam_gia" value="${editingKhuyenMai.ma_giam_gia}" placeholder="CHAOHE" required>
                    </label>
                    <label class="field">
                        <span>Loại giảm</span>
                        <select name="loai_giam" required>
                            <option value="Phan tram" ${editingKhuyenMai == null || editingKhuyenMai.loai_giam == 'Phan tram' ? 'selected' : ''}>Phần trăm</option>
                            <option value="So tien co dinh" ${editingKhuyenMai != null && editingKhuyenMai.loai_giam == 'So tien co dinh' ? 'selected' : ''}>Số tiền cố định</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Giá trị</span>
                        <input type="number" min="0" step="0.01" name="gia_tri" value="${editingKhuyenMai.gia_tri}" required>
                    </label>
                    <label class="field">
                        <span>Ngày bắt đầu</span>
                        <input type="datetime-local" name="ngay_bat_dau" value="${editingNgayBatDau}" required>
                    </label>
                    <label class="field">
                        <span>Ngày kết thúc</span>
                        <input type="datetime-local" name="ngay_ket_thuc" value="${editingNgayKetThuc}" required>
                    </label>
                    <label class="field">
                        <span>Số lượng còn lại</span>
                        <input type="number" min="0" step="1" name="so_luong_gioi_han" value="${editingKhuyenMai.so_luong_gioi_han}" required>
                    </label>
                    <label class="field">
                        <span>Trạng thái</span>
                        <select name="trang_thai">
                            <option value="true" ${editingKhuyenMai == null || editingKhuyenMai.trang_thai ? 'selected' : ''}>Hoạt động</option>
                            <option value="false" ${editingKhuyenMai != null && !editingKhuyenMai.trang_thai ? 'selected' : ''}>Tạm ngừng</option>
                        </select>
                    </label>
                </div>
                <div class="form-actions">
                    <button type="submit" style="background:#0f766e; color:#fff8e6;">${editingKhuyenMai != null ? 'Cập nhật khuyến mãi' : 'Thêm khuyến mãi'}</button>
                    <c:if test="${editingKhuyenMai != null}">
                        <a class="btn btn-muted" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Hủy sửa</a>
                    </c:if>
                </div>
            </form>
        </div>
    </article>
    </c:if>

    <article class="panel" style="margin-top:32px;">
        <div class="panel-head">
            <h2>Danh Sách Khuyến Mãi</h2>
            <span class="meta-chip">${listKhuyenMai.size()} muc</span>
        </div>
        <div class="table-wrap">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Mã KM</th>
                    <th>Mã giảm giá</th>
                    <th>Loại</th>
                    <th>Giá trị</th>
                    <th>Bắt đầu</th>
                    <th>Kết thúc</th>
                    <th>Còn lại</th>
                    <th>Trạng thái</th>
                    <c:if test="${canManageKhuyenMai}">
                        <th>Hành động</th>
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
                        <td>${km.trang_thai ? 'Hoạt động' : 'Tạm ngừng'}</td>
                        <c:if test="${canManageKhuyenMai}">
                            <td>
                                <div class="table-actions" style="display:flex; flex-wrap:nowrap; align-items:center; gap:8px; white-space:nowrap;">
                                    <a class="btn btn-muted btn-compact table-link invoice-action-btn"
                                       style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1; text-decoration:none;"
                                       href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai?editId=${km.id}">Sửa</a>
                                    <form action="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai/xoa" method="post" style="display:inline-flex; margin:0;">
                                        <input type="hidden" name="id" value="${km.id}">
                                        <button class="invoice-action-btn"
                                                style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1;"
                                                type="submit" onclick="return confirm('Xóa khuyến mãi này?')">Xóa</button>
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

