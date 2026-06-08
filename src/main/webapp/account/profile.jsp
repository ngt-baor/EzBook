<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Ho So Ca Nhan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Account Center</p>
            <h1 class="page-title">Ho So Ca Nhan</h1>
            <p class="page-subtitle">Cap nhat thong tin lien he va doi mat khau tren cung mot man hinh, giu bo cuc on dinh cho ca Admin, Staff va Khach hang.</p>
        </div>
        <nav class="toolbar">
            <c:choose>
                <c:when test="${sessionScope.role == 'USER'}">
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-khach.jsp">Trang khach hang</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/khach-hang/booking-online">Dat lich</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
                    <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/khach-hang/dang-xuat">Dang xuat</a>
                </c:when>
                <c:when test="${sessionScope.role == 'ADMIN'}">
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chu</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Nhan vien</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Tai khoan</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dich vu</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Khuyen mai</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hoa don</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/thong-ke/hien-thi">Thong ke</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
                    <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Dang xuat</a>
                </c:when>
                <c:otherwise>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chu</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hoa don</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Khuyen mai</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/thong-ke/hien-thi">Thong ke</a>
                    <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
                    <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Dang xuat</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Tai khoan</span>
            <strong>${accountInfo.username}</strong>
        </article>
        <article class="stat-card">
            <span>Vai tro</span>
            <strong>${accountInfo.role}</strong>
        </article>
        <article class="stat-card">
            <span>Trang thai</span>
            <strong>${accountInfo.active ? 'Dang hoat dong' : 'Bi khoa'}</strong>
        </article>
    </section>

    <c:if test="${param.msg == 'update-profile-success'}">
        <p class="alert success">Cap nhat ho so thanh cong.</p>
    </c:if>
    <c:if test="${param.msg == 'change-pass-success'}">
        <p class="alert success">Doi mat khau thanh cong.</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p class="alert error">Co loi: ${param.error}</p>
    </c:if>

    <section class="workspace-grid equal-col">
        <article class="panel">
            <div class="panel-head">
                <h2>Cap Nhat Ho So</h2>
                <span class="meta-chip">Profile</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}/account/cap-nhat-ho-so" method="post">
                    <div class="form-grid">
                        <label class="field">
                            <span>Ho ten</span>
                            <input type="text" name="ho_ten" value="${accountInfo.fullName}" required>
                        </label>
                        <label class="field">
                            <span>So dien thoai</span>
                            <input type="text" name="sdt" value="${accountInfo.phone}" required>
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Luu thay doi</button>
                    </div>
                </form>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>Doi Mat Khau</h2>
                <span class="meta-chip">Security</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}/account/doi-mat-khau" method="post">
                    <div class="form-grid">
                        <label class="field">
                            <span>Mat khau cu</span>
                            <input type="password" name="mat_khau_cu" required>
                        </label>
                        <label class="field">
                            <span>Mat khau moi</span>
                            <input type="password" name="mat_khau_moi" required>
                        </label>
                        <label class="field">
                            <span>Xac nhan mat khau moi</span>
                            <input type="password" name="mat_khau_moi_xac_nhan" required>
                        </label>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Doi mat khau</button>
                    </div>
                </form>
            </div>
        </article>
    </section>
</div>
</body>
</html>

