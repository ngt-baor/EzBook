<%--
  Created by IntelliJ IDEA.
  User: Bao
  Date: 5/31/2026
  Time: 08:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Cập Nhật Nhân Viên</title>
</head>
<body>
<h2>Cập Nhật Thông Tin Nhân Viên</h2>
<form action="/nhan-vien/sua" method="post">
  Mã NV: <strong>${nv.id}</strong>
  <input type="hidden" name="id" value="${nv.id}"> <br><br>

  Họ tên: <input type="text" name="ho_ten" value="${nv.ho_ten}" required> <br><br>
  Số điện thoại: <input type="text" name="sdt" value="${nv.sdt}"> <br><br>

  Vai trò:
  <select name="vai_tro">
    <option value="Kỹ thuật viên Trưởng" ${nv.vai_tro == 'Kỹ thuật viên Trưởng' ? 'selected' : ''}>Kỹ thuật viên Trưởng</option>
    <option value="Nhân viên Kỹ thuật" ${nv.vai_tro == 'Nhân viên Kỹ thuật' ? 'selected' : ''}>Nhân viên Kỹ thuật</option>
    <option value="Tiếp tân" ${nv.vai_tro == 'Tiếp tân' ? 'selected' : ''}>Tiếp tân</option>
  </select> <br><br>

  Trạng thái:
  <input type="radio" name="trang_thai" value="true" ${nv.trang_thai ? 'checked' : ''}> Đang làm việc
  <input type="radio" name="trang_thai" value="false" ${!nv.trang_thai ? 'checked' : ''}> Tạm nghỉ
  <br><br>

  <button type="submit">Cập nhật</button>
  <a href="/nhan-vien/hien-thi">Quay lại</a>
</form>
</body>
</html>