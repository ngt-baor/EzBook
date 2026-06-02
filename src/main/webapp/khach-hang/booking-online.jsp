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
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/khach-hang/dang-xuat">Dang xuat</a>
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
    <c:if test="${param.error == 'customer-not-found'}">
        <p class="alert error">Khong tim thay ho so khach hang. Vui long dang nhap lai.</p>
    </c:if>
    <c:if test="${param.error == 'cancel-not-allowed'}">
        <p class="alert error">Chi duoc huy lich o trang thai Pending hoac Confirmed.</p>
    </c:if>
    <c:if test="${param.error == 'cancel-missing-data'}">
        <p class="alert error">Khong du thong tin de huy lich.</p>
    </c:if>
    <c:if test="${param.error != null && param.error != 'staff-time-conflict' && param.error != 'customer-not-found' && param.error != 'cancel-not-allowed' && param.error != 'cancel-missing-data'}">
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
                    </div>
                    <div class="form-actions">
                        <button type="submit">Dat lich</button>
                    </div>
                </form>
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
    </section>
</div>
</body>
</html>
