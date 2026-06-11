<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<html>
<head>
    <title>Quản Lý Hóa Đơn</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Billing Workspace</p>
            <h1 class="page-title">Quản Lý Hóa Đơn</h1>
            <p class="page-subtitle">Khong gian thao tác hóa đơn cho Admin và Staff, ưu tiên nhập liệu rõ ràng và scan nhanh trạng thái thanh toán.</p>
        </div>
        <nav class="toolbar">
            
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chủ</a>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a class="toolbar-link" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Nhân viên</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Tài khoản</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dịch vụ</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Khuyến mãi</a>
            </c:if>
            <c:if test="${sessionScope.role == 'STAFF'}">
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Khuyến mãi</a>
            </c:if>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hóa đơn</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/thong-ke/hien-thi">Thống kê</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Hồ sơ</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Số hóa đơn</span>
            <strong>${listHoaDon.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Booking lien ket</span>
            <strong>${listBooking.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Phương thức</span>
            <strong>Tiền mặt / Chuyển khoản</strong>
        </article>
    </section>

    <c:if test="${param.msg != null}">
        <p class="alert success">Thành công: ${param.msg}</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p class="alert error">Lỗi: ${param.error}. Nếu trùng booking_id, mỗi booking chỉ tạo được 1 hóa đơn.</p>
    </c:if>

    <article class="panel">
        <div class="panel-head">
            <h2>Tìm Kiếm Và Lọc Hóa Đơn</h2>
            <span class="meta-chip">Invoice filter</span>
        </div>
        <div class="panel-body">
            <form action="${pageContext.request.contextPath}/hoa-don/hien-thi" method="get">
                <div class="form-grid four-col">
                    <label class="field">
                        <span>Từ khóa</span>
                        <input type="text" name="tuKhoa" value="${param.tuKhoa}" placeholder="Mã HĐ hoặc booking">
                    </label>
                    <label class="field">
                        <span>Trạng thái</span>
                        <select name="trangThai">
                            <option value="">Tất cả trạng thái</option>
                            <option value="Chua thanh toan" ${param.trangThai == 'Chua thanh toan' ? 'selected' : ''}>Chưa thanh toán</option>
                            <option value="Da thanh toan" ${param.trangThai == 'Da thanh toan' ? 'selected' : ''}>Đã thanh toán</option>
                            <option value="Huy hoa don" ${param.trangThai == 'Huy hoa don' ? 'selected' : ''}>Hủy hóa đơn</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Phương thức</span>
                        <select name="phuongThuc">
                            <option value="">Tất cả phương thức</option>
                            <option value="Tien mat" ${param.phuongThuc == 'Tien mat' ? 'selected' : ''}>Tiền mặt</option>
                            <option value="Chuyen khoan" ${param.phuongThuc == 'Chuyen khoan' ? 'selected' : ''}>Chuyển khoản</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Từ ngày TT</span>
                        <input type="date" name="ngayTu" value="${param.ngayTu}">
                    </label>
                    <label class="field">
                        <span>Đến ngày TT</span>
                        <input type="date" name="ngayDen" value="${param.ngayDen}">
                    </label>
                    <div class="field">
                        <span>Kết quả</span>
                        <p class="panel-note">Đang hiển thị ${listHoaDon.size()} hóa đơn theo điều kiện lọc.</p>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit">Lọc hóa đơn</button>
                    <a class="btn btn-muted" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Xóa bộ lọc</a>
                </div>
            </form>
        </div>
    </article>

    <article class="panel" style="margin-top:32px;">
        <div class="panel-head">
            <h2>${editingHoaDon != null ? 'Sửa Hóa Đơn' : 'Thêm Hóa Đơn'}</h2>
            <span class="meta-chip">Billing form</span>
        </div>
        <div class="panel-body">
            <form action="${pageContext.request.contextPath}${editingHoaDon != null ? '/hoa-don/sua' : '/hoa-don/them'}" method="post">
                <div class="form-grid four-col">
                    <label class="field">
                        <span>Mã hóa đơn</span>
                        <input type="text" name="id" value="${editingHoaDon.id}" ${editingHoaDon != null ? 'readonly' : ''} required>
                    </label>
                    <label class="field">
                        <span>Booking</span>
                        <select name="booking_id" required>
                            <option value="">-- Chọn booking --</option>
                            <c:forEach items="${listBooking}" var="b">
                                <option value="${b.id}" ${editingHoaDon != null && editingHoaDon.booking_id == b.id ? 'selected' : ''}>${b.id}</option>
                            </c:forEach>
                        </select>
                    </label>
                    <label class="field">
                        <span>Tổng tiền gốc</span>
                        <input type="number" min="0" step="1000" name="tong_tien_goc" value="${editingHoaDon.tong_tien_goc}" required>
                    </label>
                    <label class="field">
                        <span>Khuyến mãi</span>
                        <select name="khuyen_mai_id">
                            <option value="">-- Theo booking / Không áp dụng --</option>
                            <c:forEach items="${listKhuyenMai}" var="km">
                                <option value="${km.id}">
                                    ${km.ma_giam_gia} -
                                    <c:choose>
                                        <c:when test="${km.loai_giam == 'Phan tram'}">
                                            <fmt:formatNumber value="${km.gia_tri}" type="number" groupingUsed="true" maxFractionDigits="0"/>%
                                        </c:when>
                                        <c:otherwise>
                                            <fmt:formatNumber value="${km.gia_tri}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ
                                        </c:otherwise>
                                    </c:choose>
                                </option>
                            </c:forEach>
                        </select>
                    </label>
                    <label class="field">
                        <span>Phương thức thanh toán</span>
                        <select name="phuong_thuc_thanh_toan" required>
                            <option value="Tien mat" ${editingHoaDon == null || editingHoaDon.phuong_thuc_thanh_toan == 'Tien mat' ? 'selected' : ''}>Tiền mặt</option>
                            <option value="Chuyen khoan" ${editingHoaDon != null && editingHoaDon.phuong_thuc_thanh_toan == 'Chuyen khoan' ? 'selected' : ''}>Chuyển khoản</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Trạng thái thanh toán</span>
                        <select name="trang_thai_thanh_toan" required>
                            <option value="Chua thanh toan" ${editingHoaDon == null || editingHoaDon.trang_thai_thanh_toan == 'Chua thanh toan' ? 'selected' : ''}>Chưa thanh toán</option>
                            <option value="Da thanh toan" ${editingHoaDon != null && editingHoaDon.trang_thai_thanh_toan == 'Da thanh toan' ? 'selected' : ''}>Đã thanh toán</option>
                            <option value="Huy hoa don" ${editingHoaDon != null && editingHoaDon.trang_thai_thanh_toan == 'Huy hoa don' ? 'selected' : ''}>Hủy hóa đơn</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Thời gian thanh toán</span>
                        <input type="datetime-local" name="thoi_gian_thanh_toan" value="${editingHoaDonTimeInput}">
                    </label>
                    <div class="field">
                        <span>Ghi chú</span>
                        <p class="panel-note">Thành tiền được tính tự động = Tổng tiền gốc - Khuyến mãi. Nếu booking da co mã khuyến mãi, hệ thống tự áp dụng khi để trống.</p>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit">${editingHoaDon != null ? 'Cập nhật hóa đơn' : 'Thêm hóa đơn'}</button>
                    <c:if test="${editingHoaDon != null}">
                        <a class="btn btn-muted" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hủy sửa</a>
                    </c:if>
                </div>
            </form>
        </div>
    </article>

    <article class="panel" style="margin-top:32px;">
        <div class="panel-head">
            <h2>Danh Sách Hóa Đơn</h2>
            <span class="meta-chip">${listHoaDon.size()} muc</span>
        </div>
        <div class="table-wrap">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Mã HĐ</th>
                    <th>Booking</th>
                    <th>Tổng gốc</th>
                    <th>Khuyến mãi / Giảm giá</th>
                    <th>Thành tiền</th>
                    <th>PTTT</th>
                    <th>Thời gian TT</th>
                    <th>Trạng thái TT</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${listHoaDon}" var="hd">
                    <tr>
                        <td>${hd.id}</td>
                        <td>${hd.booking_id}</td>
                        <td><fmt:formatNumber value="${hd.tong_tien_goc}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</td>
                        <td><fmt:formatNumber value="${hd.tien_giam_gia}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</td>
                        <td><fmt:formatNumber value="${hd.thanh_tien}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</td>
                        <td>
                            <c:choose>
                                <c:when test="${hd.phuong_thuc_thanh_toan == 'Tien mat'}">Tiền mặt</c:when>
                                <c:when test="${hd.phuong_thuc_thanh_toan == 'Chuyen khoan'}">Chuyển khoản</c:when>
                                <c:otherwise>${hd.phuong_thuc_thanh_toan}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${hd.thoi_gian_thanh_toan}</td>
                        <td>
                            <c:choose>
                                <c:when test="${hd.trang_thai_thanh_toan == 'Chua thanh toan'}">
                                    <div class="payment-confirm-box" data-payment-confirm>
                                        <button class="btn btn-compact" type="button" data-show-payment-confirm
                                                style="height:42px; min-height:42px; padding:0 14px; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1.15; white-space:nowrap;"
                                                onclick="var box=this.closest('[data-payment-confirm]'); this.style.display='none'; box.querySelector('[data-payment-actions]').style.display='inline-flex';">
                                            Xác nhận đã thanh toán
                                        </button>
                                        <div class="payment-confirm-actions" data-payment-actions style="display:none; flex-direction:row; gap:8px; align-items:center; white-space:nowrap;">
                                            <form action="${pageContext.request.contextPath}/hoa-don/xac-nhan-thanh-toan" method="post" style="display:inline-flex; margin:0;">
                                                <input type="hidden" name="id" value="${hd.id}">
                                                <button class="btn-confirm-paid" type="submit" style="height:42px; min-height:42px; padding:0 14px; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1; background:#2f7d42; color:#fff8e6;">Confirm</button>
                                            </form>
                                            <button class="btn-deny-paid" type="button" data-hide-payment-confirm
                                                    style="height:42px; min-height:42px; padding:0 14px; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1; background:#f7d2bf; color:#a23923;"
                                                    onclick="var box=this.closest('[data-payment-confirm]'); box.querySelector('[data-payment-actions]').style.display='none'; box.querySelector('[data-show-payment-confirm]').style.display='inline-flex';">
                                                Deny
                                            </button>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <span class="status-chip payment-status-chip"
                                          style="height:42px; min-height:42px; padding:0 14px; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1; white-space:nowrap;">
                                        <c:choose>
                                            <c:when test="${hd.trang_thai_thanh_toan == 'Da thanh toan'}">Đã thanh toán</c:when>
                                            <c:when test="${hd.trang_thai_thanh_toan == 'Huy hoa don'}">Hủy hóa đơn</c:when>
                                            <c:otherwise>${hd.trang_thai_thanh_toan}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="table-actions" style="display:flex; flex-wrap:nowrap; align-items:center; gap:8px; white-space:nowrap;">
                                <a class="btn btn-muted btn-compact table-link invoice-action-btn"
                                   style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1; text-decoration:none;"
                                   href="${pageContext.request.contextPath}/hoa-don/hien-thi?editId=${hd.id}">Sửa</a>
                                <form action="${pageContext.request.contextPath}/hoa-don/xoa" method="post" style="display:inline-flex; margin:0;">
                                    <input type="hidden" name="id" value="${hd.id}">
                                    <button class="invoice-action-btn"
                                            style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1;"
                                            type="submit" onclick="return confirm('Xóa hóa đơn này?')">Xóa</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </article>
</div>
</body>
</html>

