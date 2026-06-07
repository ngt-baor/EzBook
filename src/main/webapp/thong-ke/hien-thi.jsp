<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Thong Ke</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Analytics Workspace</p>
            <h1 class="page-title">Thong Ke</h1>
            <p class="page-subtitle">Theo doi doanh thu theo thang tu cac hoa don da thanh toan, tach rieng khoi man hinh booking de de quan sat.</p>
        </div>
        <nav class="toolbar">
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chu</a>
            <c:if test="${sessionScope.role == 'ADMIN'}">
                <a class="toolbar-link" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Nhan vien</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Tai khoan</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dich vu</a>
            </c:if>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hoa don</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/thong-ke/hien-thi">Thong ke</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Dang xuat</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Nam thong ke</span>
            <strong>${year}</strong>
        </article>
        <article class="stat-card">
            <span>Tong doanh thu</span>
            <strong>${totalRevenue}</strong>
        </article>
        <article class="stat-card">
            <span>Top dich vu</span>
            <strong>${topDichVu.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Lich hen hom nay</span>
            <strong>${lichHenHomNay.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Lich sap dien ra</span>
            <strong>${lichHenSapDienRa.size()}</strong>
        </article>
    </section>

    <section class="workspace-grid equal-col" style="margin-top:32px;">
        <article class="panel">
            <div class="panel-head">
                <h2>Lich Hen Hom Nay</h2>
                <span class="meta-chip">${lichHenHomNay.size()} lich</span>
            </div>
            <div class="panel-body" style="padding-bottom:0;">
                <p class="panel-note">${bookingScopeLabel}. Khong tinh lich da huy.</p>
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
                        <th>Thoi gian</th>
                        <th>Trang thai</th>
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
                            <td colspan="7">Hom nay chua co lich hen.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>Lich Hen Sap Dien Ra</h2>
                <span class="meta-chip">${lichHenSapDienRa.size()} lich</span>
            </div>
            <div class="panel-body" style="padding-bottom:0;">
                <p class="panel-note">${bookingScopeLabel}. Chi tinh Pending va Confirmed tu hien tai tro di.</p>
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
                        <th>Thoi gian</th>
                        <th>Trang thai</th>
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
                            <td colspan="7">Chua co lich sap dien ra.</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </article>
    </section>

    <article class="panel">
        <div class="panel-head">
            <h2>Bo Loc Thong Ke</h2>
            <span class="meta-chip">Revenue year</span>
        </div>
        <div class="panel-body">
            <form action="${pageContext.request.contextPath}/thong-ke/hien-thi" method="get">
                <div class="form-grid two-col">
                    <label class="field">
                        <span>Nam thong ke</span>
                        <input type="number" name="year" value="${year}" min="2000" max="2100">
                    </label>
                    <div class="field">
                        <span>Ghi chu</span>
                        <p class="panel-note">Chi tinh cac hoa don co thoi gian thanh toan va trang thai da thanh toan.</p>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit">Xem thong ke</button>
                </div>
            </form>
        </div>
    </article>

    <article class="panel" style="margin-top:32px;">
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

    <article class="panel" style="margin-top:32px;">
        <div class="panel-head">
            <h2>Top Dich Vu Duoc Dat Nhieu (${year})</h2>
            <span class="meta-chip">${topDichVu.size()} muc</span>
        </div>
        <div class="table-wrap">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Hang</th>
                    <th>Ma DV</th>
                    <th>Ten dich vu</th>
                    <th>So luot dat</th>
                    <th>Doanh thu du kien</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${topDichVu}" var="dv" varStatus="st">
                    <tr>
                        <td>${st.index + 1}</td>
                        <td>${dv.dichVuId}</td>
                        <td>${dv.tenDichVu}</td>
                        <td>${dv.soLuotDat}</td>
                        <td>${dv.doanhThuDuKien}</td>
                    </tr>
                </c:forEach>
                <c:if test="${topDichVu.size() == 0}">
                    <tr>
                        <td colspan="5">Chua co du lieu booking dich vu trong nam nay.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </article>
</div>
</body>
</html>
