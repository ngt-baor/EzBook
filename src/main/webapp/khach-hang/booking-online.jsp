<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Dat Lich Online</title>
</head>
<body>
<div style="width: 1100px; margin: 24px auto; font-family: Arial, sans-serif;">
    <h2>Khach Hang Dat Lich Online</h2>
    <p>
        <a href="${pageContext.request.contextPath}/pages/giao-dien-khach.jsp">Quay lai giao dien khach hang</a>
        | <a href="${pageContext.request.contextPath}/account/ho-so">Ho so ca nhan</a>
        | <a href="${pageContext.request.contextPath}/khach-hang/dang-xuat">Dang xuat</a>
    </p>

    <c:if test="${param.msg == 'created-success'}">
        <p style="color: green;">Dat lich thanh cong. Booking dang o trang thai Pending.</p>
    </c:if>
    <c:if test="${param.error == 'staff-time-conflict'}">
        <p style="color: red;">Nhan vien da co lich o khung gio nay, vui long chon gio khac.</p>
    </c:if>
    <c:if test="${param.error == 'customer-not-found'}">
        <p style="color: red;">Khong tim thay ho so khach hang. Vui long dang nhap lai.</p>
    </c:if>
    <c:if test="${param.error != null && param.error != 'staff-time-conflict' && param.error != 'customer-not-found'}">
        <p style="color: red;">Co loi: ${param.error}</p>
    </c:if>

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
        <div style="border:1px solid #ddd; border-radius: 6px; padding: 16px;">
            <h3>Form Dat Lich</h3>
            <p>Xin chao: <strong>${customerName}</strong> (${sdtTimKiem})</p>
            <form action="${pageContext.request.contextPath}/khach-hang/booking-online/tao" method="post">
                <label>Dich vu</label><br>
                <select name="dich_vu_id" style="width:100%; padding:6px;" required>
                    <option value="">-- Chon dich vu --</option>
                    <c:forEach items="${listDichVu}" var="dv">
                        <option value="${dv.id}">${dv.ten_dich_vu}</option>
                    </c:forEach>
                </select>
                <br><br>

                <label>Nhan vien (khong bat buoc)</label><br>
                <select name="nhan_vien_id" style="width:100%; padding:6px;">
                    <option value="">-- He thong tu sap xep --</option>
                    <c:forEach items="${listNhanVien}" var="nv">
                        <option value="${nv.id}">${nv.ho_ten}</option>
                    </c:forEach>
                </select>
                <br><br>

                <label>Ngay hen</label><br>
                <input type="date" name="ngay_hen" style="width:100%; padding:6px;" required>
                <br><br>

                <label>Khung gio</label><br>
                <select name="khung_gio" style="width:100%; padding:6px;" required>
                    <option value="">-- Chon khung gio --</option>
                    <c:forEach items="${khungGio}" var="slot">
                        <option value="${slot}">${slot}</option>
                    </c:forEach>
                </select>
                <br><br>

                <label>Ghi chu</label><br>
                <textarea name="ghi_chu" rows="3" style="width:100%; padding:6px;"></textarea>
                <br><br>

                <button type="submit">Dat Lich</button>
            </form>
        </div>

        <div style="border:1px solid #ddd; border-radius: 6px; padding: 16px;">
            <h3>Lich Da Dat Cua Toi</h3>

            <c:if test="${bookingCuaToi != null}">
                <table border="1" cellpadding="6" cellspacing="0" style="width:100%; border-collapse: collapse;">
                    <thead>
                    <tr>
                        <th>ID</th>
                        <th>Dich vu</th>
                        <th>Nhan vien</th>
                        <th>Thoi gian</th>
                        <th>Trang thai</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${bookingCuaToi}" var="b">
                        <tr>
                            <td>${b.id}</td>
                            <td>${b.dichVuTen}</td>
                            <td>${b.nhanVienTen}</td>
                            <td>${b.thoiGianHenText}</td>
                            <td>${b.trangThaiBooking}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>
