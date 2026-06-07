<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Dat Lich Online</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Customer Booking</p>
            <h1 class="page-title">Dat Lich Online</h1>
            <p class="page-subtitle">Khach hang co the dat lich theo khung gio, xem lich da dat va huy lich neu trang thai con Pending hoac Confirmed.</p>
        </div>
        <nav class="toolbar">
            
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-khach.jsp">Trang khach hang</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/khach-hang/booking-online">Dat lich</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/khach-hang/dang-xuat">Dang xuat</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Khach hang</span>
            <strong>${customerName}</strong>
        </article>
        <article class="stat-card">
            <span>So dien thoai</span>
            <strong>${sdtTimKiem}</strong>
        </article>
        <article class="stat-card">
            <span>Lich cua toi</span>
            <strong>${bookingCuaToi.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Lich hom nay</span>
            <strong>${lichHomNayCount}</strong>
        </article>
        <article class="stat-card">
            <span>Lich sap toi</span>
            <strong>${lichSapToiCount}</strong>
        </article>
    </section>

    <c:if test="${param.msg == 'created-success'}">
        <p class="alert success">Dat lich thanh cong. Booking dang o trang thai Pending.</p>
    </c:if>
    <c:if test="${param.msg == 'cancel-success'}">
        <p class="alert success">Huy lich thanh cong.</p>
    </c:if>
    <c:if test="${param.error == 'staff-time-conflict'}">
        <p class="alert error">Nhan vien da co lich o khung gio nay, vui long chon gio khac.</p>
    </c:if>
    <c:if test="${param.error == 'staff-not-bookable'}">
        <p class="alert error">Khong the dat lich cho tai khoan admin. Vui long chon nhan vien khac.</p>
    </c:if>
    <c:if test="${param.error == 'past-booking-not-allowed'}">
        <p class="alert error">Khach hang chi duoc dat lich tu thoi diem hien tai tro di.</p>
    </c:if>
    <c:if test="${param.error == 'customer-not-found'}">
        <p class="alert error">Khong tim thay ho so khach hang. Vui long dang nhap lai.</p>
    </c:if>
    <c:if test="${param.error == 'cancel-not-allowed'}">
        <p class="alert error">Chi duoc huy lich o trang thai Pending hoac Confirmed.</p>
    </c:if>
    <c:if test="${param.error == 'cancel-missing-data'}">
        <p class="alert error">Khong du thong tin de huy lich.</p>
    </c:if>
    <c:if test="${param.error != null && param.error != 'staff-time-conflict' && param.error != 'staff-not-bookable' && param.error != 'past-booking-not-allowed' && param.error != 'customer-not-found' && param.error != 'cancel-not-allowed' && param.error != 'cancel-missing-data'}">
        <p class="alert error">Co loi: ${param.error}</p>
    </c:if>

    <section class="workspace-grid equal-col">
        <article class="panel">
            <div class="panel-head">
                <h2>Form Dat Lich</h2>
                <span class="meta-chip">Online booking</span>
            </div>
            <div class="panel-body">
                <p class="panel-note">Xin chao ${customerName}. Ban co the de trong nhan vien de he thong tu sap xep.</p>
                <form action="${pageContext.request.contextPath}/khach-hang/booking-online/tao" method="post">
                    <div class="form-grid">
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
                            <span>Nhan vien</span>
                            <select name="nhan_vien_id">
                                <option value="">-- He thong tu sap xep --</option>
                                <c:forEach items="${listNhanVien}" var="nv">
                                    <option value="${nv.id}">${nv.ho_ten}</option>
                                </c:forEach>
                            </select>
                        </label>
                        <label class="field">
                            <span>Ngay hen</span>
                            <input type="date" name="ngay_hen" min="${todayDate}" required>
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
                            <span>Phuong thuc thanh toan</span>
                            <select name="phuong_thuc_thanh_toan" required>
                                <option value="Tien mat">Tien mat</option>
                                <option value="Chuyen khoan">Chuyen khoan</option>
                            </select>
                        </label>
                        <label class="field">
                            <span>Ghi chu</span>
                            <textarea name="ghi_chu" rows="4"></textarea>
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Dat lich</button>
                    </div>
                </form>
            </div>
        </article>

        <div class="content-stack">
        <article class="panel">
            <div class="panel-head">
                <h2>Top Dich Vu Duoc Dat Nhieu Nhat</h2>
                <span class="meta-chip">Hot services</span>
            </div>
            <div class="panel-body" style="padding-bottom:16px;">
                <div style="display:grid; grid-template-columns:repeat(3, minmax(0, 1fr)); gap:10px; margin-bottom:16px;">
                    <c:forEach items="${topDichVuHot}" var="dv" varStatus="st">
                        <article style="min-height:118px; padding:12px; border:2px solid #2b2520; border-radius:6px; background:#fff8e6; box-shadow:4px 4px 0 rgba(31,26,23,0.16);">
                            <div style="display:flex; align-items:center; justify-content:space-between; gap:8px; margin-bottom:10px;">
                                <span style="font-size:22px;">&#128293;</span>
                                <span class="meta-chip">Top ${st.index + 1}</span>
                            </div>
                            <strong style="display:block; margin-bottom:6px;">${dv.tenDichVu}</strong>
                            <span class="mini-note">${dv.soLuotDat} luot dat</span>
                        </article>
                    </c:forEach>
                    <c:if test="${topDichVuHot.size() == 0}">
                        <p class="panel-note" style="grid-column:1 / -1;">Chua co du lieu dich vu hot.</p>
                    </c:if>
                </div>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>Lich Da Dat Cua Toi</h2>
                <span class="meta-chip">${bookingCuaToi.size()} lich</span>
            </div>
            <div class="table-wrap">
                <c:if test="${bookingCuaToi != null}">
                    <table class="data-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Dich vu</th>
                            <th>Nhan vien</th>
                            <th>Thoi gian</th>
                            <th>Thanh toan</th>
                            <th>Trang thai</th>
                            <th>Hanh dong</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${bookingCuaToi}" var="b">
                            <tr>
                                <td>${b.id}</td>
                                <td>${b.dichVuTen}</td>
                                <td>${b.nhanVienTen}</td>
                                <td>${b.thoiGianHenText}</td>
                                <td>${b.phuongThucThanhToan}</td>
                                <td>${b.trangThaiBooking}</td>
                                <td>
                                    <div class="table-actions">
                                        <c:choose>
                                            <c:when test="${b.trangThaiBooking == 'Pending' || b.trangThaiBooking == 'Confirmed'}">
                                                <form action="${pageContext.request.contextPath}/khach-hang/booking-online/huy" method="post">
                                                    <input type="hidden" name="id" value="${b.id}">
                                                    <button type="submit" onclick="return confirm('Ban co chac muon huy lich nay?')">Huy lich</button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="mini-note">Da khoa thao tac</span>
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
</body>
</html>
