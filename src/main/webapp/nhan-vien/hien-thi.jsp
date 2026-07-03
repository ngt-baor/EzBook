<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quản Lý Nhân Viên</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css?v=ui-20260703">
    <script>
        function deleteEmployee(id) {
            if (confirm('Bạn chắc chắn muốn xóa?')) {
                document.getElementById('deleteForm_' + id).submit();
            }
        }
    </script>
</head>
<body>
<div class="app-shell">
    <header class="page-header">
        <div class="page-heading">
            <p class="eyebrow">Admin Workspace</p>
            <h1 class="page-title">Quản Lý Nhân Viên</h1>
            <p class="page-subtitle">Quản lý danh sách nhân sự, vai trò và trạng thái làm việc trong một màn hình desktop rõ ràng, để scan và thao tác nhanh.</p>
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
            <span>Tổng nhân viên</span>
            <strong>${listNhanVien.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Phân hệ</span>
            <strong>Admin</strong>
        </article>
        <article class="stat-card">
            <span>Quyền truy cập</span>
            <strong>Admin only</strong>
        </article>
    </section>

    <section class="workspace-grid two-col">
        <article class="panel">
            <div class="panel-head">
                <h2>Thêm Nhân Viên Mới</h2>
                <span class="status-chip admin">Nhan su</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}/nhan-vien/them" method="post">
                    <div class="form-grid">
                        <label class="field">
                            <span>Mã nhân viên</span>
                            <input type="text" name="id" required>
                        </label>
                        <label class="field">
                            <span>Họ tên</span>
                            <input type="text" name="ho_ten" required>
                        </label>
                        <label class="field">
                            <span>Số điện thoại</span>
                            <input type="text" name="sdt">
                        </label>
                        <label class="field">
                            <span>Vai trò</span>
                            <select name="vai_tro">
                                <option value="Ky thuat vien Truong">Kỹ thuật viên Trưởng</option>
                                <option value="Nhan vien Ky thuat">Nhân viên Kỹ thuật</option>
                                <option value="Tiep tan">Tiếp tân</option>
                            </select>
                        </label>
                        <div class="choice-group">
                            <span>Trạng thái</span>
                            <div class="choice-row">
                                <label class="choice-pill">
                                    <input type="radio" name="trang_thai" value="true" checked>
                                    Đang làm việc
                                </label>
                                <label class="choice-pill">
                                    <input type="radio" name="trang_thai" value="false">
                                    Tạm nghỉ
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Thêm nhân viên</button>
                    </div>
                </form>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>Danh Sách Nhân Viên</h2>
                <span class="meta-chip">${listNhanVien.size()} nhân viên</span>
            </div>
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Ma NV</th>
                        <th>Họ Tên</th>
                        <th>Số Điện Thoại</th>
                        <th>Vai Trò</th>
                        <th>Trạng Thái</th>
                        <th>Hành Động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${listNhanVien}" var="nv">
                        <tr>
                            <td>${nv.id}</td>
                            <td>${nv.ho_ten}</td>
                            <td>${nv.sdt}</td>
                            <td>${nv.vai_tro}</td>
                            <td>${nv.trang_thai ? "Đang làm việc" : "Tạm nghỉ"}</td>
                            <td>
                                <div class="table-actions">
                                    <a class="table-link" href="${pageContext.request.contextPath}/nhan-vien/view-update?id=${nv.id}">Sửa</a>
                                    <a class="table-link" href="javascript:void(0);" onclick="deleteEmployee('${nv.id}')">Xóa</a>
                                </div>
                                <form id="deleteForm_${nv.id}" action="${pageContext.request.contextPath}/nhan-vien/xoa" method="post" style="display:none;">
                                    <input type="hidden" name="id" value="${nv.id}">
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </article>
    </section>
</div>
</body>
</html>
