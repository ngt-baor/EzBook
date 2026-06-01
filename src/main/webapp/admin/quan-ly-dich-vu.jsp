<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quan Ly Dich Vu</title>
</head>
<body>
<div style="width: 1100px; margin: 24px auto; font-family: Arial, sans-serif;">
    <h2>Quan Ly Dich Vu (Admin)</h2>
    <p>
        <a href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Ve Trang Chu</a>
        | <a href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Quan ly tai khoan</a>
        | <a href="${pageContext.request.contextPath}/logout">Dang xuat</a>
    </p>

    <c:if test="${param.msg != null}">
        <p style="color: green;">Thanh cong: ${param.msg}</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p style="color: red;">Loi: ${param.error}</p>
    </c:if>

    <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 20px;">
        <div style="border:1px solid #ddd; border-radius: 6px; padding: 14px;">
            <h3>
                <c:choose>
                    <c:when test="${editingLoai != null}">Sua Loai Dich Vu</c:when>
                    <c:otherwise>Them Loai Dich Vu</c:otherwise>
                </c:choose>
            </h3>
            <form action="${pageContext.request.contextPath}${editingLoai != null ? '/admin/quan-ly-dich-vu/loai/sua' : '/admin/quan-ly-dich-vu/loai/them'}" method="post">
                <label>Ma loai</label><br>
                <input type="text" name="id" value="${editingLoai.id}" ${editingLoai != null ? 'readonly' : ''} style="width:100%; padding:6px;" required>
                <br><br>
                <label>Ten loai</label><br>
                <input type="text" name="ten_loai" value="${editingLoai.ten_loai}" style="width:100%; padding:6px;" required>
                <br><br>
                <label>Mo ta</label><br>
                <textarea name="mo_ta" rows="3" style="width:100%; padding:6px;">${editingLoai.mo_ta}</textarea>
                <br><br>
                <button type="submit">${editingLoai != null ? 'Cap nhat' : 'Them moi'}</button>
                <c:if test="${editingLoai != null}">
                    <a href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Huy sua</a>
                </c:if>
            </form>
        </div>

        <div style="border:1px solid #ddd; border-radius: 6px; padding: 14px;">
            <h3>
                <c:choose>
                    <c:when test="${editingDichVu != null}">Sua Dich Vu</c:when>
                    <c:otherwise>Them Dich Vu</c:otherwise>
                </c:choose>
            </h3>
            <form action="${pageContext.request.contextPath}${editingDichVu != null ? '/admin/quan-ly-dich-vu/dich-vu/sua' : '/admin/quan-ly-dich-vu/dich-vu/them'}" method="post">
                <label>Ma dich vu</label><br>
                <input type="text" name="id" value="${editingDichVu.id}" ${editingDichVu != null ? 'readonly' : ''} style="width:100%; padding:6px;" required>
                <br><br>

                <label>Loai dich vu</label><br>
                <select name="loai_dich_vu_id" style="width:100%; padding:6px;" required>
                    <option value="">-- Chon loai --</option>
                    <c:forEach items="${listLoaiDichVu}" var="ldv">
                        <option value="${ldv.id}" ${editingDichVu != null && editingDichVu.loai_dich_vu_id == ldv.id ? 'selected' : ''}>
                            ${ldv.id} - ${ldv.ten_loai}
                        </option>
                    </c:forEach>
                </select>
                <br><br>

                <label>Ten dich vu</label><br>
                <input type="text" name="ten_dich_vu" value="${editingDichVu.ten_dich_vu}" style="width:100%; padding:6px;" required>
                <br><br>

                <label>Gia tien</label><br>
                <input type="number" min="0" step="1000" name="gia_tien" value="${editingDichVu.gia_tien}" style="width:100%; padding:6px;" required>
                <br><br>

                <label>Trang thai</label><br>
                <select name="trang_thai" style="width:100%; padding:6px;">
                    <option value="true" ${editingDichVu == null || editingDichVu.trang_thai ? 'selected' : ''}>Hoat dong</option>
                    <option value="false" ${editingDichVu != null && !editingDichVu.trang_thai ? 'selected' : ''}>Ngung</option>
                </select>
                <br><br>

                <button type="submit">${editingDichVu != null ? 'Cap nhat' : 'Them moi'}</button>
                <c:if test="${editingDichVu != null}">
                    <a href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Huy sua</a>
                </c:if>
            </form>
        </div>
    </div>

    <h3 style="margin-top: 24px;">Danh Sach Loai Dich Vu</h3>
    <table border="1" cellpadding="8" cellspacing="0" style="width:100%; border-collapse: collapse;">
        <thead>
        <tr>
            <th>Ma loai</th>
            <th>Ten loai</th>
            <th>Mo ta</th>
            <th>Hanh dong</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${listLoaiDichVu}" var="ldv">
            <tr>
                <td>${ldv.id}</td>
                <td>${ldv.ten_loai}</td>
                <td>${ldv.mo_ta}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu?editLoaiId=${ldv.id}">Sua</a>
                    |
                    <form action="${pageContext.request.contextPath}/admin/quan-ly-dich-vu/loai/xoa" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="${ldv.id}">
                        <button type="submit" onclick="return confirm('Xoa loai dich vu nay?')">Xoa</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <h3 style="margin-top: 24px;">Danh Sach Dich Vu</h3>
    <table border="1" cellpadding="8" cellspacing="0" style="width:100%; border-collapse: collapse;">
        <thead>
        <tr>
            <th>Ma DV</th>
            <th>Ten dich vu</th>
            <th>Loai</th>
            <th>Gia tien</th>
            <th>Trang thai</th>
            <th>Hanh dong</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${listDichVu}" var="dv">
            <tr>
                <td>${dv.id}</td>
                <td>${dv.ten_dich_vu}</td>
                <td>
                    <c:forEach items="${listLoaiDichVu}" var="ldv">
                        <c:if test="${ldv.id == dv.loai_dich_vu_id}">
                            ${ldv.ten_loai}
                        </c:if>
                    </c:forEach>
                </td>
                <td>${dv.gia_tien}</td>
                <td>${dv.trang_thai ? 'Hoat dong' : 'Ngung'}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu?editDichVuId=${dv.id}">Sua</a>
                    |
                    <form action="${pageContext.request.contextPath}/admin/quan-ly-dich-vu/dich-vu/xoa" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="${dv.id}">
                        <button type="submit" onclick="return confirm('Xoa dich vu nay?')">Xoa</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
