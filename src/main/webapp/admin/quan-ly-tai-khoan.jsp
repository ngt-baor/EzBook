<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quản Lý Tài Khoản</title>
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
            <h1 class="page-title">Quản Lý Tài Khoản</h1>
            <p class="page-subtitle">Theo dõi tài khoản nhân viên và khách hàng o hai bảng riêng, thao tác khóa mở khóa nhanh mà không bị rời bố cục.</p>
        </div>
        <nav class="toolbar">
            
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chủ</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Nhân viên</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Tài khoản</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dịch vụ</a>
                <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-khuyen-mai">Khuyến mãi</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hóa đơn</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/thong-ke/hien-thi">Thống kê</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Hồ sơ</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Đăng xuất</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Tài khoản nhân viên</span>
            <strong>${staffCount}</strong>
        </article>
        <article class="stat-card">
            <span>Tài khoản khách hàng</span>
            <strong>${customerCount}</strong>
        </article>
        <article class="stat-card">
            <span>Tổng số</span>
            <strong>${accounts.size()}</strong>
        </article>
    </section>

    <c:if test="${param.msg == 'status-updated'}">
        <p class="alert success">Cập nhật trạng thái tài khoản thành công.</p>
    </c:if>
    <c:if test="${param.msg == 'account-deleted'}">
        <p class="alert success">Xóa tài khoản thành công.</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p class="alert error">Có lỗi: ${param.error}</p>
    </c:if>

    <c:if test="${detailAccount != null}">
        <div class="modal-overlay">
            <article class="modal-card">
                <div class="panel-head">
                    <h2>Thông Tin Tài Khoản</h2>
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
                            <th>Họ tên</th>
                            <td>${detailAccount.fullName}</td>
                        </tr>
                        <tr>
                            <th>Số điện thoại</th>
                            <td>${detailAccount.phone}</td>
                        </tr>
                        <tr>
                            <th>Vai trò</th>
                            <td>${detailAccount.role}</td>
                        </tr>
                        <tr>
                            <th>Trạng thái</th>
                            <td>${detailAccount.active ? 'Hoạt động' : 'Bị khóa'}</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <div class="panel-body">
                    <a class="btn btn-muted" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Đóng</a>
                </div>
            </article>
        </div>
    </c:if>

    <section class="content-stack">
        <article class="panel">
            <div class="panel-head">
                <h2>Tài Khoản Nhân Viên</h2>
                <span class="meta-chip">${staffCount} tài khoản</span>
            </div>
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Username</th>
                        <th>Họ tên</th>
                        <th>Số điện thoại</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
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
                                <td>${acc.active ? 'Hoạt động' : 'Bị khóa'}</td>
                                <td>
                                    <div class="table-actions">
                                        <a class="btn btn-muted btn-compact" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/detail?username=${acc.username}">Info</a>
                                        <form action="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/trang-thai" method="post">
                                            <input type="hidden" name="username" value="${acc.username}">
                                            <input type="hidden" name="currentStatus" value="${acc.active}">
                                            <button type="submit">${acc.active ? 'Khóa' : 'Mở khóa'}</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/xoa" method="post">
                                            <input type="hidden" name="username" value="${acc.username}">
                                            <button type="submit" onclick="return confirm('Xóa tài khoản ${acc.username}? Hồ sơ nhân viên/khách hàng sẽ được giữ lại nhưng không còn đăng nhập bảng tài khoản này.')">Xóa</button>
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
                <h2>Tài Khoản Khách Hàng</h2>
                <span class="meta-chip">${customerCount} tài khoản</span>
            </div>
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Username</th>
                        <th>Họ tên</th>
                        <th>Số điện thoại</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
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
                                <td>${acc.active ? 'Hoạt động' : 'Bị khóa'}</td>
                                <td>
                                    <div class="table-actions">
                                        <a class="btn btn-muted btn-compact" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/detail?username=${acc.username}">Info</a>
                                        <form action="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/trang-thai" method="post">
                                            <input type="hidden" name="username" value="${acc.username}">
                                            <input type="hidden" name="currentStatus" value="${acc.active}">
                                            <button type="submit">${acc.active ? 'Khóa' : 'Mở khóa'}</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan/xoa" method="post">
                                            <input type="hidden" name="username" value="${acc.username}">
                                            <button type="submit" onclick="return confirm('Xóa tài khoản ${acc.username}? Hồ sơ khách hàng sẽ được giữ lại nhưng không còn đăng nhập bảng tài khoản này.')">Xóa</button>
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

