<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
  <title>Cap Nhat Nhan Vien</title>
</head>
<body>
<div style="width: 640px; margin: 24px auto; font-family: Arial, sans-serif;">
  <h2>Cap Nhat Thong Tin Nhan Vien</h2>
  <form action="${pageContext.request.contextPath}/nhan-vien/sua" method="post">
    Ma NV: <strong>${nv.id}</strong>
    <input type="hidden" name="id" value="${nv.id}"> <br><br>

    Ho ten: <input type="text" name="ho_ten" value="${nv.ho_ten}" required> <br><br>
    So dien thoai: <input type="text" name="sdt" value="${nv.sdt}"> <br><br>

    Vai tro:
    <select name="vai_tro">
      <option value="Ky thuat vien Truong" ${nv.vai_tro == 'Ky thuat vien Truong' ? 'selected' : ''}>Ky thuat vien Truong</option>
      <option value="Nhan vien Ky thuat" ${nv.vai_tro == 'Nhan vien Ky thuat' ? 'selected' : ''}>Nhan vien Ky thuat</option>
      <option value="Tiep tan" ${nv.vai_tro == 'Tiep tan' ? 'selected' : ''}>Tiep tan</option>
    </select> <br><br>

    Trang thai:
    <input type="radio" name="trang_thai" value="true" ${nv.trang_thai ? 'checked' : ''}> Dang lam viec
    <input type="radio" name="trang_thai" value="false" ${!nv.trang_thai ? 'checked' : ''}> Tam nghi
    <br><br>

    <button type="submit">Cap nhat</button>
    <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi">Quay lai</a>
  </form>
</div>
</body>
</html>
