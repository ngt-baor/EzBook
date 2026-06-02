<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quan Ly Tai Khoan</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
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
            <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dich vu</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/logout">Dang xuat</a>
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
    <c:if test="${param.error != null}">
        <p class="alert error">Co loi: ${param.error}</p>
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
                                    <form action="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/trang-thai" method="post">
                                        <input type="hidden" name="username" value="${acc.username}">
                                        <input type="hidden" name="currentStatus" value="${acc.active}">
                                        <button type="submit">${acc.active ? 'Khoa' : 'Mo khoa'}</button>
                                    </form>
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
                                    <form action="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/trang-thai" method="post">
                                        <input type="hidden" name="username" value="${acc.username}">
                                        <input type="hidden" name="currentStatus" value="${acc.active}">
                                        <button type="submit">${acc.active ? 'Khoa' : 'Mo khoa'}</button>
                                    </form>
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
