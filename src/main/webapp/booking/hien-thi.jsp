<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<html>
<head>
    <title>Quản Lý Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Operations Workspace</p>
            <h1 class="page-title">Quản Lý Booking</h1>
            <p class="page-subtitle">Điều phối lịch hẹn theo khung giờ, kiểm tra trùng lịch nhân viên và theo dõi workflow Pending -> Confirmed -> Completed -> Cancelled.</p>
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
            <span>Tổng booking</span>
            <strong>${listBooking.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Khung giờ</span>
            <strong>${khungGio.size()} slot</strong>
        </article>
        <article class="stat-card">
            <span>Workflow</span>
            <strong>4 buoc</strong>
        </article>
    </section>

    <c:if test="${param.msg == 'created-success'}">
        <p class="alert success">Tạo booking thành công.</p>
    </c:if>
    <c:if test="${param.msg == 'status-updated'}">
        <p class="alert success">Cập nhật trạng thái thành công.</p>
    </c:if>
    <c:if test="${param.msg == 'status-updated-invoice-created'}">
        <p class="alert success">Đã chuyển Completed và sẵn sàng hóa đơn o trạng thái Chưa thanh toán.</p>
    </c:if>
    <c:if test="${param.error == 'staff-time-conflict'}">
        <p class="alert error">Nhân viên đã có lịch ở khung giờ này.</p>
    </c:if>
    <c:if test="${param.error == 'staff-not-bookable'}">
        <p class="alert error">Không thể đặt lịch cho tài khoản admin. Vui lòng chọn nhân viên khác.</p>
    </c:if>
    <c:if test="${param.error == 'invalid-promotion'}">
        <p class="alert error">Khuyến mãi không hợp lệ, đã hết hạn, hết lượt hoặc đang tạm ngừng.</p>
    </c:if>
    <c:if test="${param.error == 'service-not-active'}">
        <p class="alert error">Dịch vụ này đang ngừng hoạt động. Vui lòng chọn dịch vụ khác.</p>
    </c:if>
    <c:if test="${param.error == 'invalid-status-transition'}">
        <p class="alert error">Khong hop le workflow: Pending -> Confirmed -> Completed -> Cancelled.</p>
    </c:if>
    <c:if test="${param.error == 'invoice-auto-create-failed'}">
        <p class="alert error">Đã chuyển Completed nhưng tạo hóa đơn tự động thất bại.</p>
    </c:if>
    <c:if test="${param.error != null && param.error != 'staff-time-conflict' && param.error != 'staff-not-bookable' && param.error != 'invalid-promotion' && param.error != 'service-not-active' && param.error != 'invalid-status-transition' && param.error != 'invoice-auto-create-failed'}">
        <p class="alert error">Có lỗi: ${param.error}</p>
    </c:if>

    <section class="workspace-grid equal-col">
        <article class="panel">
            <div class="panel-head">
                <h2>Tạo Booking Mới</h2>
                <span class="meta-chip">Pending default</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}/booking/them" method="post">
                    <div class="form-grid two-col">
                        <label class="field">
                            <span>Khách hàng</span>
                            <select name="khach_hang_id" required>
                                <option value="">-- Chọn khách hàng --</option>
                                <c:forEach items="${listKhachHang}" var="kh">
                                    <option value="${kh.id}">${kh.ho_ten} - ${kh.sdt}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Nhân viên</span>
                            <select name="nhan_vien_id" required>
                                <option value="">-- Chọn nhân viên --</option>
                                <c:forEach items="${listNhanVien}" var="nv">
                                    <option value="${nv.id}">${nv.id} - ${nv.ho_ten}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Loại dịch vụ</span>
                            <select id="staffServiceTypeSelect" required>
                                <option value="">-- Chọn loại dịch vụ --</option>
                                <c:forEach items="${listLoaiDichVu}" var="ldv">
                                    <option value="${ldv.id}">${ldv.id} - ${ldv.ten_loai}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Dịch vụ</span>
                            <select id="staffServiceSelect" name="dich_vu_id" required disabled>
                                <option value="">-- Chọn loại dịch vụ trước --</option>
                                <c:forEach items="${listDichVu}" var="dv">
                                    <option value="${dv.id}" data-loai-id="${dv.loai_dich_vu_id}" data-price="${dv.gia_tien}">${dv.ten_dich_vu}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <div class="field">
                            <span>Giá dịch vụ</span>
                            <p id="staffServicePrice" class="panel-note">Chọn dịch vụ để xem giá.</p>
                        </div>
                        <label class="field">
                            <span>Ngày hẹn</span>
                            <input type="date" name="ngay_hen" required>
                        </label>
                        <label class="field">
                            <span>Khung giờ</span>
                            <select name="khung_gio" required>
                                <option value="">-- Chọn khung giờ --</option>
                                <c:forEach items="${khungGio}" var="slot">
                                    <option value="${slot}">${slot}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Khuyến mãi</span>
                            <select name="khuyen_mai_id">
                                <option value="">-- Không áp dụng --</option>
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
                            <span>Ghi chú</span>
                            <textarea name="ghi_chu" rows="4"></textarea>
                        </label>
                        <div class="field">
                            <span>Phương thức thanh toán</span>
                            <p class="panel-note">Tiền mặt</p>
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Đặt lịch</button>
                    </div>
                </form>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>Bộ Lọc Và Tìm Kiếm</h2>
                <span class="meta-chip">Realtime query</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}/booking/hien-thi" method="get">
                    <div class="form-grid two-col">
                        <label class="field">
                            <span>Tên khách / so dien thoai</span>
                            <input type="text" name="tuKhoa" value="${param.tuKhoa}">
                        </label>
                        <label class="field">
                            <span>Trạng thái</span>
                            <select name="trangThai">
                                <option value="">-- Tất cả --</option>
                                <option value="Pending" ${param.trangThai == 'Pending' ? 'selected' : ''}>Pending</option>
                                <option value="Confirmed" ${param.trangThai == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                <option value="Completed" ${param.trangThai == 'Completed' ? 'selected' : ''}>Completed</option>
                                <option value="Cancelled" ${param.trangThai == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                            </select>
                        </label>
                        <label class="field">
                            <span>Từ ngày</span>
                            <input type="date" name="ngayTu" value="${param.ngayTu}">
                        </label>
                        <label class="field">
                            <span>Đến ngày</span>
                            <input type="date" name="ngayDen" value="${param.ngayDen}">
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Áp dụng bộ lọc</button>
                    </div>
                </form>
            </div>
        </article>
    </section>

    <article class="panel booking-list-panel">
        <div class="panel-head">
            <h2>Danh Sách Booking</h2>
            <span class="meta-chip">${listBooking.size()} lich</span>
        </div>
        <div class="table-wrap">
            <table class="data-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Khách hàng</th>
                    <th>SDT</th>
                    <th>Nhân viên</th>
                    <th>Dịch vụ</th>
                    <th>Khuyến mãi</th>
                    <th>Thời gian hẹn</th>
                    <th>Thanh toán</th>
                    <th>Trạng thái</th>
                    <th>Workflow</th>
                    <th>Ghi chú</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${listBooking}" var="b">
                    <tr>
                        <td>${b.id}</td>
                        <td>${b.khachHangTen}</td>
                        <td>${b.khachHangSdt}</td>
                        <td>${b.nhanVienTen}</td>
                        <td>${b.dichVuTen}</td>
                        <td>${b.khuyenMaiCode}</td>
                        <td>${b.thoiGianHenText}</td>
                        <td>
                            <c:choose>
                                <c:when test="${b.phuongThucThanhToan == 'Tien mat'}">Tiền mặt</c:when>
                                <c:when test="${b.phuongThucThanhToan == 'Chuyen khoan'}">Chuyển khoản</c:when>
                                <c:otherwise>${b.phuongThucThanhToan}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${b.trangThaiBooking}</td>
                        <td>
                            <div class="table-actions" style="display:flex; flex-wrap:nowrap; align-items:center; gap:8px; white-space:nowrap;">
                                <c:choose>
                                    <c:when test="${b.trangThaiBooking == 'Pending'}">
                                        <form action="${pageContext.request.contextPath}/booking/cap-nhat-trang-thai" method="post" style="display:inline-flex; margin:0;">
                                            <input type="hidden" name="id" value="${b.id}">
                                            <input type="hidden" name="nextStatus" value="Confirmed">
                                            <button type="submit">Confirm</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/booking/cap-nhat-trang-thai" method="post" style="display:inline-flex; margin:0;">
                                            <input type="hidden" name="id" value="${b.id}">
                                            <input type="hidden" name="nextStatus" value="Cancelled">
                                            <button class="btn-workflow-cancel" type="submit" style="background:#f7d2bf; color:#a23923;">Cancel</button>
                                        </form>
                                    </c:when>
                                    <c:when test="${b.trangThaiBooking == 'Confirmed'}">
                                        <form action="${pageContext.request.contextPath}/booking/cap-nhat-trang-thai" method="post" style="display:inline-flex; margin:0;">
                                            <input type="hidden" name="id" value="${b.id}">
                                            <input type="hidden" name="nextStatus" value="Completed">
                                            <button type="submit">Complete</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/booking/cap-nhat-trang-thai" method="post" style="display:inline-flex; margin:0;">
                                            <input type="hidden" name="id" value="${b.id}">
                                            <input type="hidden" name="nextStatus" value="Cancelled">
                                            <button class="btn-workflow-cancel" type="submit" style="background:#f7d2bf; color:#a23923;">Cancel</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="mini-note" style="font-size:18px; font-weight:800; color:#5f5445;">Không có thao tác</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </td>
                        <td>${b.ghiChuKhachHang}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </article>

</div>
<script>
    (function () {
        const loaiSelect = document.getElementById('staffServiceTypeSelect');
        const dichVuSelect = document.getElementById('staffServiceSelect');
        const priceText = document.getElementById('staffServicePrice');
        if (!loaiSelect || !dichVuSelect) {
            return;
        }

        const allServiceOptions = Array.from(dichVuSelect.querySelectorAll('option[data-loai-id]'));

        function resetServicePlaceholder(text) {
            dichVuSelect.innerHTML = '';
            const placeholder = document.createElement('option');
            placeholder.value = '';
            placeholder.textContent = text;
            dichVuSelect.appendChild(placeholder);
        }

        function formatCurrency(rawPrice) {
            const price = Number(rawPrice);
            if (!Number.isFinite(price)) {
                return 'Chọn dịch vụ để xem giá.';
            }
            return new Intl.NumberFormat('vi-VN', { maximumFractionDigits: 0 }).format(price) + ' đ';
        }

        function updateServicePrice() {
            if (!priceText) {
                return;
            }
            const selectedOption = dichVuSelect.options[dichVuSelect.selectedIndex];
            priceText.textContent = selectedOption && selectedOption.dataset.price
                ? formatCurrency(selectedOption.dataset.price)
                : 'Chọn dịch vụ để xem giá.';
        }

        function renderServicesByType() {
            const selectedLoaiId = loaiSelect.value;
            resetServicePlaceholder(selectedLoaiId ? '-- Chọn dịch vụ --' : '-- Chọn loại dịch vụ trước --');
            dichVuSelect.disabled = !selectedLoaiId;
            updateServicePrice();

            if (!selectedLoaiId) {
                return;
            }

            allServiceOptions
                .filter(option => option.dataset.loaiId === selectedLoaiId)
                .forEach(option => dichVuSelect.appendChild(option.cloneNode(true)));
        }

        loaiSelect.addEventListener('change', renderServicesByType);
        dichVuSelect.addEventListener('change', updateServicePrice);
        renderServicesByType();
    })();
</script>
</body>
</html>
