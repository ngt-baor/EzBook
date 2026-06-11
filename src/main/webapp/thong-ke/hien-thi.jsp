<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<fmt:setLocale value="vi_VN"/>
<html>
<head>
    <title>Thống Kê</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Analytics Workspace</p>
            <h1 class="page-title">Thống Kê</h1>
            <p class="page-subtitle">Theo dõi doanh thu theo tháng từ các hóa đơn đã thanh toán, tách riêng khỏi màn hình booking để dễ quan sát.</p>
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
            <span>Năm thống kê</span>
            <strong>${year}</strong>
        </article>
        <article class="stat-card">
            <span>Tổng doanh thu</span>
            <strong><fmt:formatNumber value="${totalRevenue}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</strong>
        </article>
        <article class="stat-card">
            <span>Top dịch vụ</span>
            <strong>${topDichVu.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Lich hen hôm này</span>
            <strong>${lichHenHomNay.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Lich sắp diễn ra</span>
            <strong>${lichHenSapDienRa.size()}</strong>
        </article>
    </section>

    <section class="workspace-grid equal-col" style="margin-top:32px;">
        <article class="panel">
            <div class="panel-head">
                <h2>Lịch Hẹn Hôm Nay</h2>
                <span class="meta-chip">${lichHenHomNay.size()} lich</span>
            </div>
            <div class="panel-body" style="padding-bottom:0;">
                <p class="panel-note">${bookingScopeLabel}. Không tính lịch đã hủy.</p>
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
                        <th>Thời gian</th>
                        <th>Trạng thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${lichHenHomNay}" var="b">
                        <tr>
                            <td>${b.id}</td>
                            <td>${b.khachHangTen}</td>
                            <td>${b.khachHangSdt}</td>
                            <td>${b.nhanVienTen}</td>
                            <td>${b.dichVuTen}</td>
                            <td>${b.thoiGianHenText}</td>
                            <td>${b.trangThaiBooking}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${lichHenHomNay.size() == 0}">
                        <tr>
                            <td colspan="7">Hom này chưa có lịch hẹn.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>Lịch Hẹn Sắp Diễn Ra</h2>
                <span class="meta-chip">${lichHenSapDienRa.size()} lich</span>
            </div>
            <div class="panel-body" style="padding-bottom:0;">
                <p class="panel-note">${bookingScopeLabel}. Chỉ tính Pending và Confirmed từ hiện tại trở đi.</p>
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
                        <th>Thời gian</th>
                        <th>Trạng thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${lichHenSapDienRa}" var="b">
                        <tr>
                            <td>${b.id}</td>
                            <td>${b.khachHangTen}</td>
                            <td>${b.khachHangSdt}</td>
                            <td>${b.nhanVienTen}</td>
                            <td>${b.dichVuTen}</td>
                            <td>${b.thoiGianHenText}</td>
                            <td>${b.trangThaiBooking}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${lichHenSapDienRa.size() == 0}">
                        <tr>
                            <td colspan="7">Chưa có lich sắp diễn ra.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </article>
    </section>

    <article class="panel">
        <div class="panel-head">
            <h2>Bộ Lọc Thống Kê</h2>
            <span class="meta-chip">Revenue year</span>
        </div>
        <div class="panel-body">
            <form action="${pageContext.request.contextPath}/thong-ke/hien-thi" method="get">
                <div class="form-grid two-col">
                    <label class="field">
                        <span>Năm thống kê</span>
                        <input type="number" name="year" value="${year}" min="2000" max="2100">
                    </label>
                    <div class="field">
                        <span>Ghi chú</span>
                        <p class="panel-note">Chi tinh các hóa đơn có thời gian thanh toán và trạng thái đã thanh toán.</p>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit">Xem thống kê</button>
                </div>
            </form>
        </div>
    </article>

    <article class="panel" style="margin-top:32px;">
        <div class="panel-head">
            <h2>Biểu Đồ Doanh Thu Tháng (${year})</h2>
            <span class="meta-chip">Paid revenue</span>
        </div>
        <div class="panel-body">
            <c:if test="${!hasRevenueData}">
                <p class="panel-note">Năm này chưa có doanh thu đã thanh toán.</p>
            </c:if>
            <div class="chart-list">
                <c:forEach items="${doanhThuThang}" var="dt">
                    <div class="chart-row">
                        <div>Tháng ${dt.month}</div>
                        <div class="chart-track">
                            <div class="chart-bar" style="width:${dt.widthPercent}%"></div>
                        </div>
                        <div><fmt:formatNumber value="${dt.revenue}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </article>

    <article class="panel" style="margin-top:32px;">
        <div class="panel-head">
            <h2>Top Dịch Vụ Được Đặt Nhiều (${year})</h2>
            <span class="meta-chip">${topDichVu.size()} muc</span>
        </div>
        <div class="table-wrap">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Hạng</th>
                    <th>Mã DV</th>
                    <th>Tên dịch vụ</th>
                    <th>Số lượt đặt</th>
                    <th>Doanh thu dự kiến</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${topDichVu}" var="dv" varStatus="st">
                    <tr>
                        <td>${st.index + 1}</td>
                        <td>${dv.dichVuId}</td>
                        <td>${dv.tenDichVu}</td>
                        <td>${dv.soLuotDat}</td>
                        <td><fmt:formatNumber value="${dv.doanhThuDuKien}" type="number" groupingUsed="true" maxFractionDigits="0"/> đ</td>
                    </tr>
                </c:forEach>
                <c:if test="${topDichVu.size() == 0}">
                    <tr>
                        <td colspan="5">Chưa có dữ liệu booking dịch vụ trong năm này.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </article>
</div>
</body>
</html>

