<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Ho So Ca Nhan</title>
</head>
<body>
<div style="width: 760px; margin: 24px auto; font-family: Arial, sans-serif;">
    <h2>Ho So Ca Nhan</h2>

    <p>
        <strong>Tai khoan:</strong> ${accountInfo.username} |
        <strong>Vai tro:</strong> ${accountInfo.role} |
        <strong>Trang thai:</strong>
        <c:choose>
            <c:when test="${accountInfo.active}">Dang hoat dong</c:when>
            <c:otherwise>Bi khoa</c:otherwise>
        </c:choose>
    </p>

    <p>
        <c:choose>
            <c:when test="${sessionScope.role == 'USER'}">
                <a href="${pageContext.request.contextPath}/khach-hang/booking-online">Ve trang khach hang</a>
            </c:when>
            <c:when test="${sessionScope.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Ve trang quan tri</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/booking/hien-thi">Ve trang booking</a>
            </c:otherwise>
        </c:choose>
        | <a href="${pageContext.request.contextPath}/logout">Dang xuat</a>
    </p>

    <c:if test="${param.msg == 'update-profile-success'}">
        <p style="color: green;">Cap nhat ho so thanh cong.</p>
    </c:if>
    <c:if test="${param.msg == 'change-pass-success'}">
        <p style="color: green;">Doi mat khau thanh cong.</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p style="color: red;">Co loi: ${param.error}</p>
    </c:if>

    <div style="display:grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-top: 16px;">
        <div style="border:1px solid #ddd; border-radius:6px; padding:14px;">
            <h3>Cap Nhat Ho So</h3>
            <form action="${pageContext.request.contextPath}/account/cap-nhat-ho-so" method="post">
                <label>Ho ten</label><br>
                <input type="text" name="ho_ten" value="${accountInfo.fullName}" style="width:100%; padding:6px;" required>
                <br><br>

                <label>So dien thoai</label><br>
                <input type="text" name="sdt" value="${accountInfo.phone}" style="width:100%; padding:6px;" required>
                <br><br>

                <button type="submit">Luu thay doi</button>
            </form>
        </div>

        <div style="border:1px solid #ddd; border-radius:6px; padding:14px;">
            <h3>Doi Mat Khau</h3>
            <form action="${pageContext.request.contextPath}/account/doi-mat-khau" method="post">
                <label>Mat khau cu</label><br>
                <input type="password" name="mat_khau_cu" style="width:100%; padding:6px;" required>
                <br><br>

                <label>Mat khau moi</label><br>
                <input type="password" name="mat_khau_moi" style="width:100%; padding:6px;" required>
                <br><br>

                <label>Xac nhan mat khau moi</label><br>
                <input type="password" name="mat_khau_moi_xac_nhan" style="width:100%; padding:6px;" required>
                <br><br>

                <button type="submit">Doi mat khau</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
