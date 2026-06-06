<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quan Ly Booking</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Operations Workspace</p>
            <h1 class="page-title">Quan Ly Booking</h1>
            <p class="page-subtitle">Dieu phoi lich hen theo khung gio, kiem tra trung lich nhan vien, theo doi workflow Pending -> Confirmed -> Completed -> Cancelled va xem doanh thu thang tren cung mot man hinh.</p>
        </div>
        <nav class="toolbar">
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chu</a>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dich vu</a>
            </c:if>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hoa don</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/logout">Dang xuat</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Tong booking</span>
            <strong>${listBooking.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Khung gio</span>
            <strong>${khungGio.size()} slot</strong>
        </article>
        <article class="stat-card">
            <span>Nam thong ke</span>
            <strong>${year}</strong>
        </article>
    </section>

    <c:if test="${param.msg == 'created-success'}">
        <p class="alert success">Tao booking thanh cong.</p>
    </c:if>
    <c:if test="${param.msg == 'status-updated'}">
        <p class="alert success">Cap nhat trang thai thanh cong.</p>
    </c:if>
    <c:if test="${param.msg == 'status-updated-invoice-created'}">
        <p class="alert success">Da chuyen Completed va san sang hoa don o trang thai Chua thanh toan.</p>
    </c:if>
    <c:if test="${param.error == 'staff-time-conflict'}">
        <p class="alert error">Nhan vien da co lich o khung gio nay.</p>
    </c:if>
    <c:if test="${param.error == 'invalid-status-transition'}">
        <p class="alert error">Khong hop le workflow: Pending -> Confirmed -> Completed -> Cancelled.</p>
    </c:if>
    <c:if test="${param.error == 'invoice-auto-create-failed'}">
        <p class="alert error">Da chuyen Completed nhung tao hoa don tu dong that bai.</p>
    </c:if>
    <c:if test="${param.error != null && param.error != 'staff-time-conflict' && param.error != 'invalid-status-transition' && param.error != 'invoice-auto-create-failed'}">
        <p class="alert error">Co loi: ${param.error}</p>
    </c:if>

    <section class="workspace-grid equal-col">
        <article class="panel">
            <div class="panel-head">
                <h2>Tao Booking Moi</h2>
                <span class="meta-chip">Pending default</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}/booking/them" method="post">
                    <div class="form-grid two-col">
                        <label class="field">
                            <span>Khach hang</span>
                            <select name="khach_hang_id" required>
                                <option value="">-- Chon khach hang --</option>
                                <c:forEach items="${listKhachHang}" var="kh">
                                    <option value="${kh.id}">${kh.ho_ten} - ${kh.sdt}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Nhan vien</span>
                            <select name="nhan_vien_id" required>
                                <option value="">-- Chon nhan vien --</option>
                                <c:forEach items="${listNhanVien}" var="nv">
                                    <option value="${nv.id}">${nv.id} - ${nv.ho_ten}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Dich vu</span>
                            <select name="dich_vu_id" required>
                                <option value="">-- Chon dich vu --</option>
                                <c:forEach items="${listDichVu}" var="dv">
                                    <option value="${dv.id}">${dv.ten_dich_vu}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Ngay hen</span>
                            <input type="date" name="ngay_hen" required>
                        </label>
                        <label class="field">
                            <span>Khung gio</span>
                            <select name="khung_gio" required>
                                <option value="">-- Chon khung gio --</option>
                                <c:forEach items="${khungGio}" var="slot">
                                    <option value="${slot}">${slot}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Ghi chu</span>
                            <textarea name="ghi_chu" rows="4"></textarea>
                        </label>
                        <div class="field">
                            <span>Phuong thuc thanh toan</span>
                            <p class="panel-note">Tien mat</p>
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Dat lich</button>
                    </div>
                </form>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>Bo Loc Va Tim Kiem</h2>
                <span class="meta-chip">Realtime query</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}/booking/hien-thi" method="get">
                    <div class="form-grid two-col">
                        <label class="field">
                            <span>Ten khach / so dien thoai</span>
                            <input type="text" name="tuKhoa" value="${param.tuKhoa}">
                        </label>
                        <label class="field">
                            <span>Trang thai</span>
                            <select name="trangThai">
                                <option value="">-- Tat ca --</option>
                                <option value="Pending" ${param.trangThai == 'Pending' ? 'selected' : ''}>Pending</option>
                                <option value="Confirmed" ${param.trangThai == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                                <option value="Completed" ${param.trangThai == 'Completed' ? 'selected' : ''}>Completed</option>
                                <option value="Cancelled" ${param.trangThai == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                            </select>
                        </label>
                        <label class="field">
                            <span>Tu ngay</span>
                            <input type="date" name="ngayTu" value="${param.ngayTu}">
                        </label>
                        <label class="field">
                            <span>Den ngay</span>
                            <input type="date" name="ngayDen" value="${param.ngayDen}">
                        </label>
                        <label class="field">
                            <span>Nam thong ke doanh thu</span>
                            <input type="number" name="year" value="${year}" min="2000" max="2100">
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Ap dung bo loc</button>
                    </div>
                </form>
            </div>
        </article>
    </section>

    <article class="panel">
        <div class="panel-head">
            <h2>Danh Sach Booking</h2>
            <span class="meta-chip">${listBooking.size()} lich</span>
        </div>
        <div class="table-wrap">
            <table class="data-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Khach hang</th>
                    <th>SDT</th>
                    <th>Nhan vien</th>
                    <th>Dich vu</th>
                    <th>Thoi gian hen</th>
                    <th>Thanh toan</th>
                    <th>Trang thai</th>
                    <th>Workflow</th>
                    <th>Ghi chu</th>
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
                        <td>${b.thoiGianHenText}</td>
                        <td>${b.phuongThucThanhToan}</td>
                        <td>${b.trangThaiBooking}</td>
                        <td>
                            <div class="table-actions">
                                <c:choose>
                                    <c:when test="${b.trangThaiBooking == 'Pending'}">
                                        <form action="${pageContext.request.contextPath}/booking/cap-nhat-trang-thai" method="post">
                                            <input type="hidden" name="id" value="${b.id}">
                                            <input type="hidden" name="nextStatus" value="Confirmed">
                                            <button type="submit">Confirm</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/booking/cap-nhat-trang-thai" method="post">
                                            <input type="hidden" name="id" value="${b.id}">
                                            <input type="hidden" name="nextStatus" value="Cancelled">
                                            <button type="submit">Cancel</button>
                                        </form>
                                    </c:when>
                                    <c:when test="${b.trangThaiBooking == 'Confirmed'}">
                                        <form action="${pageContext.request.contextPath}/booking/cap-nhat-trang-thai" method="post">
                                            <input type="hidden" name="id" value="${b.id}">
                                            <input type="hidden" name="nextStatus" value="Completed">
                                            <button type="submit">Complete</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/booking/cap-nhat-trang-thai" method="post">
                                            <input type="hidden" name="id" value="${b.id}">
                                            <input type="hidden" name="nextStatus" value="Cancelled">
                                            <button type="submit">Cancel</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="mini-note">Khong co thao tac</span>
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

    <article class="panel">
        <div class="panel-head">
            <h2>Bieu Do Doanh Thu Thang (${year})</h2>
            <span class="meta-chip">Paid revenue</span>
        </div>
        <div class="panel-body">
            <c:if test="${!hasRevenueData}">
                <p class="panel-note">Nam nay chua co doanh thu da thanh toan.</p>
            </c:if>
            <div class="chart-list">
                <c:forEach items="${doanhThuThang}" var="dt">
                    <div class="chart-row">
                        <div>Thang ${dt.month}</div>
                        <div class="chart-track">
                            <div class="chart-bar" style="width:${dt.widthPercent}%"></div>
                        </div>
                        <div>${dt.revenue}</div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </article>
</div>
</body>
</html>
