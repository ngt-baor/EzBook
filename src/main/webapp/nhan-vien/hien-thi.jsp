<%--
  Created by IntelliJ IDEA.
  User: Bao
  Date: 5/31/2026
  Time: 08:41
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quản Lý Nhân Viên</title>
    <script>
        function deleteEmployee(id) {
            if (confirm('Bạn chắc chắn muốn xóa?')) {
                document.getElementById('deleteForm_' + id).submit();
            }
        }
    </script>
</head>
<body>
<h2>Thêm Nhân Viên Mới</h2>
<form action="/nhan-vien/them" method="post">
    Mã NV: <input type="text" name="id" required> <br><br>
    Họ tên: <input type="text" name="ho_ten" required> <br><br>
    Số điện thoại: <input type="text" name="sdt"> <br><br>
    Vai trò:
    <select name="vai_tro">
        <option value="Kỹ thuật viên Trưởng">Kỹ thuật viên Trưởng</option>
        <option value="Nhân viên Kỹ thuật">Nhân viên Kỹ thuật</option>
        <option value="Tiếp tân">Tiếp tân</option>
    </select> <br><br>
    Trạng thái:
    <input type="radio" name="trang_thai" value="true" checked> Đang làm việc
    <input type="radio" name="trang_thai" value="false"> Tạm nghỉ
    <br><br>
    <button type="submit">Thêm nhân viên</button>
</form>

<hr>

<h2>Danh Sách Nhân Viên</h2>
<table border="1" cellpadding="8" cellspacing="0">
    <thead>
    <tr>
        <th>Mã NV</th>
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
                <a href="/nhan-vien/view-update?id=${nv.id}">Sửa</a> |
                <a href="javascript:void(0);" onclick="deleteEmployee('${nv.id}')">Xóa</a>

                <!-- Hidden delete form for CSRF protection -->
                <form id="deleteForm_${nv.id}" action="${pageContext.request.contextPath}/nhan-vien/xoa" method="post" style="display:none;">
                    <input type="hidden" name="id" value="${nv.id}">
                </form>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>