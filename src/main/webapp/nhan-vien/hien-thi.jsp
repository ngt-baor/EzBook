<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quan Ly Nhan Vien</title>
    <script>
        function deleteEmployee(id) {
            if (confirm('Ban chac chan muon xoa?')) {
                document.getElementById('deleteForm_' + id).submit();
            }
        }
    </script>
</head>
<body>
<div style="width: 980px; margin: 24px auto; font-family: Arial, sans-serif;">
    <h2>Quan Ly Nhan Vien (Admin)</h2>
    <p>
        <a href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Ve giao dien nhan vien</a>
        | <a href="${pageContext.request.contextPath}/admin/quan-ly-tai-khoan">Quan ly tai khoan</a>
        | <a href="${pageContext.request.contextPath}/account/ho-so">Ho so</a>
        | <a href="${pageContext.request.contextPath}/logout">Dang xuat</a>
    </p>

    <h3>Them Nhan Vien Moi</h3>
    <form action="${pageContext.request.contextPath}/nhan-vien/them" method="post">
        Ma NV: <input type="text" name="id" required> <br><br>
        Ho ten: <input type="text" name="ho_ten" required> <br><br>
        So dien thoai: <input type="text" name="sdt"> <br><br>
        Vai tro:
        <select name="vai_tro">
            <option value="Ky thuat vien Truong">Ky thuat vien Truong</option>
            <option value="Nhan vien Ky thuat">Nhan vien Ky thuat</option>
            <option value="Tiep tan">Tiep tan</option>
        </select> <br><br>
        Trang thai:
        <input type="radio" name="trang_thai" value="true" checked> Dang lam viec
        <input type="radio" name="trang_thai" value="false"> Tam nghi
        <br><br>
        <button type="submit">Them nhan vien</button>
    </form>

    <hr>

    <h3>Danh Sach Nhan Vien</h3>
    <table border="1" cellpadding="8" cellspacing="0" style="border-collapse: collapse; width: 100%;">
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
                    <a href="${pageContext.request.contextPath}/nhan-vien/view-update?id=${nv.id}">Sua</a> |
                    <a href="javascript:void(0);" onclick="deleteEmployee('${nv.id}')">Xoa</a>

                    <form id="deleteForm_${nv.id}" action="${pageContext.request.contextPath}/nhan-vien/xoa" method="post" style="display:none;">
                        <input type="hidden" name="id" value="${nv.id}">
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
