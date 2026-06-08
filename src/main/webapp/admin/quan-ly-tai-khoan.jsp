<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quan Ly Tai Khoan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=font-20260608-2">
</head>
<body>
<c:set var="staffCount" value="0" />
<c:set var="customerCount" value="0" />
<c:forEach items="${accounts}" var="acc">
    <c:choose>
        <c:when test="${acc.role == 'ADMIN' || acc.role == 'STAFF'}">
            <c:set var="staffCount" value="${staffCount + 1}" />
        </c:when>
        <c:when test="${acc.role == 'USER'}">
            <c:set var="customerCount" value="${customerCount + 1}" />
        </c:when>
    </c:choose>
</c:forEach>

<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Admin Workspace</p>
            <h1 class="page-title">Quan Ly Tai Khoan</h1>
            <p class="page-subtitle">Theo doi tai khoan nhan vien va khach hang o hai bang rieng, thao tac khoa mo khoa nhanh ma khong bi roi bo cuc.</p>
        </div>
        <nav class="toolbar">
            
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
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Tai khoan nhan vien</span>
            <strong>${staffCount}</strong>
        </article>
        <article class="stat-card">
            <span>Tai khoan khach hang</span>
            <strong>${customerCount}</strong>
        </article>
        <article class="stat-card">
            <span>Tong so</span>
            <strong>${accounts.size()}</strong>
        </article>
    </section>

    <c:if test="${param.msg == 'status-updated'}">
        <p class="alert success">Cap nhat trang thai tai khoan thanh cong.</p>
    </c:if>
    <c:if test="${param.msg == 'account-deleted'}">
        <p class="alert success">Xoa tai khoan thanh cong.</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p class="alert error">Co loi: ${param.error}</p>
    </c:if>

    <c:if test="${detailAccount != null}">
        <div class="modal-overlay">
            <article class="modal-card">
                <div class="panel-head">
                    <h2>Thong Tin Tai Khoan</h2>
                    <span class="meta-chip">${detailAccount.username}</span>
                </div>
                <div class="table-wrap">
                    <table class="data-table">
                        <tbody>
                        <tr>
                            <th>Username</th>
                            <td>${detailAccount.username}</td>
                        </tr>
                        <tr>
                            <th>Password</th>
                            <td>${detailAccount.password}</td>
                        </tr>
                        <tr>
                            <th>Ho ten</th>
                            <td>${detailAccount.fullName}</td>
                        </tr>
                        <tr>
                            <th>So dien thoai</th>
                            <td>${detailAccount.phone}</td>
                        </tr>
                        <tr>
                            <th>Vai tro</th>
                            <td>${detailAccount.role}</td>
                        </tr>
                        <tr>
                            <th>Trang thai</th>
                            <td>${detailAccount.active ? 'Hoat dong' : 'Bi khoa'}</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div class="panel-body">
                    <a class="btn btn-muted" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Dong</a>
                </div>
            </article>
        </div>
    </c:if>

    <section class="content-stack">
        <article class="panel">
            <div class="panel-head">
                <h2>Tai Khoan Nhan Vien</h2>
                <span class="meta-chip">${staffCount} tai khoan</span>
            </div>
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Username</th>
                        <th>Ho ten</th>
                        <th>So dien thoai</th>
                        <th>Vai tro</th>
                        <th>Trang thai</th>
                        <th>Hanh dong</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${accounts}" var="acc">
                        <c:if test="${acc.role == 'ADMIN' || acc.role == 'STAFF'}">
                            <tr>
                                <td>${acc.username}</td>
                                <td>${acc.fullName}</td>
                                <td>${acc.phone}</td>
                                <td>${acc.role}</td>
                                <td>${acc.active ? 'Hoat dong' : 'Bi khoa'}</td>
                                <td>
                                    <div class="table-actions">
                                        <a class="btn btn-muted btn-compact" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/detail?username=${acc.username}">Info</a>
                                        <form action="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/trang-thai" method="post">
                                            <input type="hidden" name="username" value="${acc.username}">
                                            <input type="hidden" name="currentStatus" value="${acc.active}">
                                            <button type="submit">${acc.active ? 'Khoa' : 'Mo khoa'}</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/xoa" method="post">
                                            <input type="hidden" name="username" value="${acc.username}">
                                            <button type="submit" onclick="return confirm('Xoa tai khoan ${acc.username}? Ho so nhan vien/khach hang se duoc giu lai nhung khong con dang nhap bang tai khoan nay.')">Xoa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>Tai Khoan Khach Hang</h2>
                <span class="meta-chip">${customerCount} tai khoan</span>
            </div>
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Username</th>
                        <th>Ho ten</th>
                        <th>So dien thoai</th>
                        <th>Vai tro</th>
                        <th>Trang thai</th>
                        <th>Hanh dong</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${accounts}" var="acc">
                        <c:if test="${acc.role == 'USER'}">
                            <tr>
                                <td>${acc.username}</td>
                                <td>${acc.fullName}</td>
                                <td>${acc.phone}</td>
                                <td>${acc.role}</td>
                                <td>${acc.active ? 'Hoat dong' : 'Bi khoa'}</td>
                                <td>
                                    <div class="table-actions">
                                        <a class="btn btn-muted btn-compact" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/detail?username=${acc.username}">Info</a>
                                        <form action="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/trang-thai" method="post">
                                            <input type="hidden" name="username" value="${acc.username}">
                                            <input type="hidden" name="currentStatus" value="${acc.active}">
                                            <button type="submit">${acc.active ? 'Khoa' : 'Mo khoa'}</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/xoa" method="post">
                                            <input type="hidden" name="username" value="${acc.username}">
                                            <button type="submit" onclick="return confirm('Xoa tai khoan ${acc.username}? Ho so khach hang se duoc giu lai nhung khong con dang nhap bang tai khoan nay.')">Xoa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </article>
    </section>
</div>
</body>
</html>


