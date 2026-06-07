<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quan Ly Nhan Vien</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ezbook.css">
    <script>
        function deleteEmployee(id) {
            if (confirm('Ban chac chan muon xoa?')) {
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
            <h1 class="page-title">Quan Ly Nhan Vien</h1>
            <p class="page-subtitle">Quan ly danh sach nhan su, vai tro va trang thai lam viec trong mot man hinh desktop ro rang, de scan va thao tac nhanh.</p>
        </div>
        <nav class="toolbar">
            
            <a class="toolbar-link" href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Trang Chu</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Nhan vien</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Tai khoan</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Dich vu</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/booking/hien-thi">Booking</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/hoa-don/hien-thi">Hoa don</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/thong-ke/hien-thi">Thong ke</a>
            <a class="toolbar-link" href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
            <a class="toolbar-link" style="background:#f7d2bf; color:#a23923;" href="${pageContext.request.contextPath}/logout">Dang xuat</a>
        </nav>
    </header>

    <section class="stat-grid">
        <article class="stat-card">
            <span>Tong nhan vien</span>
            <strong>${listNhanVien.size()}</strong>
        </article>
        <article class="stat-card">
            <span>Phan he</span>
            <strong>Admin</strong>
        </article>
        <article class="stat-card">
            <span>Quyen truy cap</span>
            <strong>Admin only</strong>
        </article>
    </section>

    <section class="workspace-grid two-col">
        <article class="panel">
            <div class="panel-head">
                <h2>Them Nhan Vien Moi</h2>
                <span class="status-chip admin">Nhan su</span>
            </div>
            <div class="panel-body">
                <form action="${pageContext.request.contextPath}/nhan-vien/them" method="post">
                    <div class="form-grid">
                        <label class="field">
                            <span>Ma nhan vien</span>
                            <input type="text" name="id" required>
                        </label>
                        <label class="field">
                            <span>Ho ten</span>
                            <input type="text" name="ho_ten" required>
                        </label>
                        <label class="field">
                            <span>So dien thoai</span>
                            <input type="text" name="sdt">
                        </label>
                        <label class="field">
                            <span>Vai tro</span>
                            <select name="vai_tro">
                                <option value="Ky thuat vien Truong">Ky thuat vien Truong</option>
                                <option value="Nhan vien Ky thuat">Nhan vien Ky thuat</option>
                                <option value="Tiep tan">Tiep tan</option>
                            </select>
                        </label>
                        <div class="choice-group">
                            <span>Trang thai</span>
                            <div class="choice-row">
                                <label class="choice-pill">
                                    <input type="radio" name="trang_thai" value="true" checked>
                                    Dang lam viec
                                </label>
                                <label class="choice-pill">
                                    <input type="radio" name="trang_thai" value="false">
                                    Tam nghi
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-actions">
                        <button type="submit">Them nhan vien</button>
                    </div>
                </form>
            </div>
        </article>

        <article class="panel">
            <div class="panel-head">
                <h2>Danh Sach Nhan Vien</h2>
                <span class="meta-chip">${listNhanVien.size()} nhan vien</span>
            </div>
            <div class="table-wrap">
                <table class="data-table">
                    <thead>
                    <tr>
                        <th>Ma NV</th>
                        <th>Ho Ten</th>
                        <th>So Dien Thoai</th>
                        <th>Vai Tro</th>
                        <th>Trang Thai</th>
                        <th>Hanh Dong</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${listNhanVien}" var="nv">
                        <tr>
                            <td>${nv.id}</td>
                            <td>${nv.ho_ten}</td>
                            <td>${nv.sdt}</td>
                            <td>${nv.vai_tro}</td>
                            <td>${nv.trang_thai ? "Dang lam viec" : "Tam nghi"}</td>
                            <td>
                                <div class="table-actions">
                                    <a class="table-link" href="${pageContext.request.contextPath}/nhan-vien/view-update?id=${nv.id}">Sua</a>
                                    <a class="table-link" href="javascript:void(0);" onclick="deleteEmployee('${nv.id}')">Xoa</a>
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
