<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quan Ly Hoa Don</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Billing Workspace</p>
            <h1 class="page-title">Quan Ly Hoa Don</h1>
            <p class="page-subtitle">Khong gian thao tac hoa don cho Admin va Staff, uu tien nhap lieu ro rang va scan nhanh trang thai thanh toan.</p>
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
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Dang xuat</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>So hoa don</span>
            <strong>${listHoaDon.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Booking lien ket</span>
            <strong>${listBooking.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Phuong thuc</span>
            <strong>Tien mat / Chuyen khoan</strong>
        </article>
    </section>

    <c:if test="${param.msg != null}">
        <p class="alert success">Thanh cong: ${param.msg}</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p class="alert error">Loi: ${param.error}. Neu trung booking_id, moi booking chi tao duoc 1 hoa don.</p>
    </c:if>

    <article class="panel">
        <div class="panel-head">
            <h2>Tim Kiem Va Loc Hoa Don</h2>
            <span class="meta-chip">Invoice filter</span>
        </div>
        <div class="panel-body">
            <form action="${pageContext.request.contextPath}/hoa-don/hien-thi" method="get">
                <div class="form-grid four-col">
                    <label class="field">
                        <span>Tu khoa</span>
                        <input type="text" name="tuKhoa" value="${param.tuKhoa}" placeholder="Ma HD hoac booking">
                    </label>
                    <label class="field">
                        <span>Trang thai</span>
                        <select name="trangThai">
                            <option value="">Tat ca trang thai</option>
                            <option value="Chua thanh toan" ${param.trangThai == 'Chua thanh toan' ? 'selected' : ''}>Chua thanh toan</option>
                            <option value="Da thanh toan" ${param.trangThai == 'Da thanh toan' ? 'selected' : ''}>Da thanh toan</option>
                            <option value="Huy hoa don" ${param.trangThai == 'Huy hoa don' ? 'selected' : ''}>Huy hoa don</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Phuong thuc</span>
                        <select name="phuongThuc">
                            <option value="">Tat ca phuong thuc</option>
                            <option value="Tien mat" ${param.phuongThuc == 'Tien mat' ? 'selected' : ''}>Tien mat</option>
                            <option value="Chuyen khoan" ${param.phuongThuc == 'Chuyen khoan' ? 'selected' : ''}>Chuyen khoan</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Tu ngay TT</span>
                        <input type="date" name="ngayTu" value="${param.ngayTu}">
                    </label>
                    <label class="field">
                        <span>Den ngay TT</span>
                        <input type="date" name="ngayDen" value="${param.ngayDen}">
                    </label>
                    <div class="field">
                        <span>Ket qua</span>
                        <p class="panel-note">Dang hien thi ${listHoaDon.size()} hoa don theo dieu kien loc.</p>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit">Loc hoa don</button>
                    <a class="btn btn-muted" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Xoa bo loc</a>
                </div>
            </form>
        </div>
    </article>

    <article class="panel">
        <div class="panel-head">
            <h2>${editingHoaDon != null ? 'Sua Hoa Don' : 'Them Hoa Don'}</h2>
            <span class="meta-chip">Billing form</span>
        </div>
        <div class="panel-body">
            <form action="${pageContext.request.contextPath}${editingHoaDon != null ? '/hoa-don/sua' : '/hoa-don/them'}" method="post">
                <div class="form-grid four-col">
                    <label class="field">
                        <span>Ma hoa don</span>
                        <input type="text" name="id" value="${editingHoaDon.id}" ${editingHoaDon != null ? 'readonly' : ''} required>
                    </label>
                    <label class="field">
                        <span>Booking</span>
                        <select name="booking_id" required>
                            <option value="">-- Chon booking --</option>
                            <c:forEach items="${listBooking}" var="b">
                                <option value="${b.id}" ${editingHoaDon != null && editingHoaDon.booking_id == b.id ? 'selected' : ''}>${b.id}</option>
                            </c:forEach>
                        </select>
                    </label>
                    <label class="field">
                        <span>Tong tien goc</span>
                        <input type="number" min="0" step="1000" name="tong_tien_goc" value="${editingHoaDon.tong_tien_goc}" required>
                    </label>
                    <label class="field">
                        <span>Tien giam gia</span>
                        <input type="number" min="0" step="1000" name="tien_giam_gia" value="${editingHoaDon.tien_giam_gia}" required>
                    </label>
                    <label class="field">
                        <span>Phuong thuc thanh toan</span>
                        <select name="phuong_thuc_thanh_toan" required>
                            <option value="Tien mat" ${editingHoaDon == null || editingHoaDon.phuong_thuc_thanh_toan == 'Tien mat' ? 'selected' : ''}>Tien mat</option>
                            <option value="Chuyen khoan" ${editingHoaDon != null && editingHoaDon.phuong_thuc_thanh_toan == 'Chuyen khoan' ? 'selected' : ''}>Chuyen khoan</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Trang thai thanh toan</span>
                        <select name="trang_thai_thanh_toan" required>
                            <option value="Chua thanh toan" ${editingHoaDon == null || editingHoaDon.trang_thai_thanh_toan == 'Chua thanh toan' ? 'selected' : ''}>Chua thanh toan</option>
                            <option value="Da thanh toan" ${editingHoaDon != null && editingHoaDon.trang_thai_thanh_toan == 'Da thanh toan' ? 'selected' : ''}>Da thanh toan</option>
                            <option value="Huy hoa don" ${editingHoaDon != null && editingHoaDon.trang_thai_thanh_toan == 'Huy hoa don' ? 'selected' : ''}>Huy hoa don</option>
                        </select>
                    </label>
                    <label class="field">
                        <span>Thoi gian thanh toan</span>
                        <input type="datetime-local" name="thoi_gian_thanh_toan" value="${editingHoaDonTimeInput}">
                    </label>
                    <div class="field">
                        <span>Ghi chu</span>
                        <p class="panel-note">Thanh tien duoc tinh tu dong = Tong tien goc - Tien giam gia.</p>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit">${editingHoaDon != null ? 'Cap nhat hoa don' : 'Them hoa don'}</button>
                    <c:if test="${editingHoaDon != null}">
                        <a class="btn btn-muted" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Huy sua</a>
                    </c:if>
                </div>
            </form>
        </div>
    </article>

    <article class="panel">
        <div class="panel-head">
            <h2>Danh Sach Hoa Don</h2>
            <span class="meta-chip">${listHoaDon.size()} muc</span>
        </div>
        <div class="table-wrap">
            <table class="data-table">
                <thead>
                <tr>
                    <th>Ma HD</th>
                    <th>Booking</th>
                    <th>Tong goc</th>
                    <th>Giam gia</th>
                    <th>Thanh tien</th>
                    <th>PTTT</th>
                    <th>Thoi gian TT</th>
                    <th>Trang thai TT</th>
                    <th>Hanh dong</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${listHoaDon}" var="hd">
                    <tr>
                        <td>${hd.id}</td>
                        <td>${hd.booking_id}</td>
                        <td>${hd.tong_tien_goc}</td>
                        <td>${hd.tien_giam_gia}</td>
                        <td>${hd.thanh_tien}</td>
                        <td>${hd.phuong_thuc_thanh_toan}</td>
                        <td>${hd.thoi_gian_thanh_toan}</td>
                        <td>
                            <c:choose>
                                <c:when test="${hd.trang_thai_thanh_toan == 'Chua thanh toan'}">
                                    <div class="payment-confirm-box" data-payment-confirm>
                                        <button class="btn btn-compact" type="button" data-show-payment-confirm
                                                style="height:42px; min-height:42px; padding:0 14px; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1.15; white-space:nowrap;"
                                                onclick="var box=this.closest('[data-payment-confirm]'); this.style.display='none'; box.querySelector('[data-payment-actions]').style.display='inline-flex';">
                                            Xac nhan da thanh toan
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
                                        ${hd.trang_thai_thanh_toan}
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="table-actions" style="display:flex; flex-wrap:nowrap; align-items:center; gap:8px; white-space:nowrap;">
                                <a class="btn btn-muted btn-compact table-link invoice-action-btn"
                                   style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1; text-decoration:none;"
                                   href="${pageContext.request.contextPath}/hoa-don/hien-thi?editId=${hd.id}">Sua</a>
                                <form action="${pageContext.request.contextPath}/hoa-don/xoa" method="post" style="display:inline-flex; margin:0;">
                                    <input type="hidden" name="id" value="${hd.id}">
                                    <button class="invoice-action-btn"
                                            style="width:64px; height:42px; min-width:64px; min-height:42px; padding:0; display:inline-flex; align-items:center; justify-content:center; border:2px solid #2b2520; border-radius:6px; box-shadow:4px 4px 0 rgba(31,26,23,0.16); line-height:1;"
                                            type="submit" onclick="return confirm('Xoa hoa don nay?')">Xoa</button>
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
