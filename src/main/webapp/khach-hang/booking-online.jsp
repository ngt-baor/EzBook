<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Đặt Lịch Online</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=ui-20260703">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Customer Booking</p>
            <h1 class="page-title">Đặt Lịch Online</h1>
            <p class="page-subtitle">Khách hàng co the đặt lịch theở khung giờ, xem lịch đã đặt và hủy lịch neu trạng thái con Pending hoặc Confirmed.</p>
        </div>
        <nav class="toolbar">
            
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-khach.jsp">Trang khách hàng</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/khach-hang/booking-online">Đặt lịch</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Hồ sơ</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/khach-hang/dang-xuat">Đăng xuất</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Khách hàng</span>
            <strong>${customerName}</strong>
        </article>
        <article class="stat-card">
            <span>Số điện thoại</span>
            <strong>${sdtTimKiem}</strong>
        </article>
        <article class="stat-card">
            <span>Lịch của tôi</span>
            <strong>${bookingCuaToi.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Lịch hôm này</span>
            <strong>${lichHomNayCount}</strong>
        </article>
        <article class="stat-card">
            <span>Lịch sắp tới</span>
            <strong>${lichSapToiCount}</strong>
        </article>
    </section>

    <c:if test="${param.msg == 'created-success'}">
        <p class="alert success">Đặt lịch thành công. Booking đang ở trạng thái Pending.</p>
    </c:if>
    <c:if test="${param.msg == 'cancel-success'}">
        <p class="alert success">Hủy lịch thành công.</p>
    </c:if>
    <c:if test="${param.error == 'staff-time-conflict'}">
        <p class="alert error">Nhân viên đã có lịch ở khung giờ này, vui long chọn giờ khác.</p>
    </c:if>
    <c:if test="${param.error == 'staff-not-bookable'}">
        <p class="alert error">Không thể đặt lịch cho tài khoản admin. Vui lòng chọn nhân viên khác.</p>
    </c:if>
    <c:if test="${param.error == 'past-booking-not-allowed'}">
        <p class="alert error">Khách hàng chi được đặt lịch từ thời điểm hiện tại trở đi.</p>
    </c:if>
    <c:if test="${param.error == 'invalid-promotion'}">
        <p class="alert error">Mã khuyến mãi không hợp lệ, đã hết hạn, hết lượt hoặc đang tạm ngừng.</p>
    </c:if>
    <c:if test="${param.error == 'service-not-active'}">
        <p class="alert error">Dịch vụ này đang ngừng hoạt động. Vui lòng chọn dịch vụ khác.</p>
    </c:if>
    <c:if test="${param.error == 'customer-not-found'}">
        <p class="alert error">Khong tim thay ho so khách hàng. Vui lòng đăng nhập lại.</p>
    </c:if>
    <c:if test="${param.error == 'cancel-not-allowed'}">
        <p class="alert error">Chỉ được hủy lịch ở trạng thái Pending hoặc Confirmed.</p>
    </c:if>
    <c:if test="${param.error == 'cancel-missing-data'}">
        <p class="alert error">Không đủ thông tin để hủy lịch.</p>
    </c:if>
    <c:if test="${param.error != null && param.error != 'staff-time-conflict' && param.error != 'staff-not-bookable' && param.error != 'past-booking-not-allowed' && param.error != 'invalid-promotion' && param.error != 'service-not-active' && param.error != 'customer-not-found' && param.error != 'cancel-not-allowed' && param.error != 'cancel-missing-data'}">
        <p class="alert error">Có lỗi: ${param.error}</p>
    </c:if>

    <section class="workspace-grid equal-col">
        <article class="panel">
            <div class="panel-head">
                <h2>Form Đặt Lịch</h2>
                <span class="meta-chip">Online booking</span>
            </div>
            <div class="panel-body">
                <p class="panel-note">Xin chào ${customerName}. Bạn có thể để trống nhân viên để hệ thống tự sắp xếp.</p>
                <form action="${pageContext.request.contextPath}/khach-hang/booking-online/tao" method="post">
                    <div class="form-grid">
                        <label class="field">
                            <span>Loại dịch vụ</span>
                            <select id="customerServiceTypeSelect" required>
                                <option value="">-- Chọn loại dịch vụ --</option>
                                <c:forEach items="${listLoaiDichVu}" var="ldv">
                                    <option value="${ldv.id}">${ldv.ten_loai}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Dịch vụ</span>
                            <select id="customerServiceSelect" name="dich_vu_id" required disabled>
                                <option value="">-- Chọn loại dịch vụ trước --</option>
                                <c:forEach items="${listDichVu}" var="dv">
                                    <option value="${dv.id}" data-loai-id="${dv.loai_dich_vu_id}" data-price="${dv.gia_tien}">${dv.ten_dich_vu}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <div class="field">
                            <span>Giá dịch vụ</span>
                            <p id="customerServicePrice" class="panel-note">Chọn dịch vụ để xem giá.</p>
                        </div>
                        <label class="field">
                            <span>Nhân viên</span>
                            <select name="nhan_vien_id">
                                <option value="">-- Hệ thống tự sắp xếp --</option>
                                <c:forEach items="${listNhanVien}" var="nv">
                                    <option value="${nv.id}">${nv.ho_ten}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Ngày hẹn</span>
                            <input type="date" name="ngay_hen" min="${todayDate}" required>
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
                            <span>Phương thức thanh toán</span>
                            <select name="phuong_thuc_thanh_toan" required>
                                <option value="Tien mat">Tiền mặt</option>
                                <option value="Chuyen khoan">Chuyển khoản</option>
                            </select>
                        </label>
                        <label class="field">
                            <span>Mã khuyến mãi</span>
                            <input type="text" name="ma_khuyen_mai">
                        </label>
                        <label class="field">
                            <span>Ghi chú</span>
                            <textarea name="ghi_chu" rows="4"></textarea>
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Đặt lịch</button>
                    </div>
                </form>
            </div>
        </article>

        <div class="content-stack">
        <article class="panel">
            <div class="panel-head">
                <h2>Top Dịch Vụ Được Đặt Nhiều Nhất</h2>
                <span class="meta-chip">Hot services</span>
            </div>
            <div class="panel-body">
                <div class="service-rank-grid">
                    <c:forEach items="${topDichVuHot}" var="dv" varStatus="st">
                        <article class="service-rank-card" data-rank="${st.index + 1}">
                            <span class="meta-chip">Top ${st.index + 1}</span>
                            <strong>${dv.tenDichVu}</strong>
                            <span class="mini-note">${dv.soLuotDat} lượt đặt</span>
                        </article>
                    </c:forEach>
                    <c:if test="${topDichVuHot.size() == 0}">
                        <p class="panel-note">Chưa có dữ liệu dịch vụ hot.</p>
                    </c:if>
                </div>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>Lịch Đã Đặt Của Tôi</h2>
                <span class="meta-chip">${bookingCuaToi.size()} lich</span>
            </div>
            <div class="table-wrap">
                <c:if test="${bookingCuaToi != null}">
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Dịch vụ</th>
                            <th>Khuyến mãi</th>
                            <th>Nhân viên</th>
                            <th>Thời gian</th>
                            <th>Thanh toán</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${bookingCuaToi}" var="b">
                            <tr>
                                <td>${b.id}</td>
                                <td>${b.dichVuTen}</td>
                                <td>${b.khuyenMaiCode}</td>
                                <td>${b.nhanVienTen}</td>
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
                                    <div class="table-actions">
                                        <c:choose>
                                            <c:when test="${b.trangThaiBooking == 'Pending' || b.trangThaiBooking == 'Confirmed'}">
                                                <form action="${pageContext.request.contextPath}/khach-hang/booking-online/huy" method="post">
                                                    <input type="hidden" name="id" value="${b.id}">
                                                    <button type="submit" onclick="return confirm('Bạn có chắc muốn hủy lịch này?')">Hủy lịch</button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="mini-note">Đã khóa thao tác</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </c:if>
            </div>
        </article>
        </div>
    </section>
</div>
<script>
    (function () {
        const loaiSelect = document.getElementById('customerServiceTypeSelect');
        const dichVuSelect = document.getElementById('customerServiceSelect');
        const priceText = document.getElementById('customerServicePrice');
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
