<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quan Ly Booking</title>
</head>
<body>
<div style="width: 1200px; margin: 24px auto; font-family: Arial, sans-serif;">
    <h2>Quan Ly Booking</h2>
    <p>
        <a href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Ve Trang Chu</a>
        <c:if test="${sessionScope.role == 'ADMIN'}">
            | <a href="${pageContext.request.contextPath}/admin/quan-ly-dich-vu">Quan ly dich vu</a>
        </c:if>
        | <a href="${pageContext.request.contextPath}/hoa-don/hien-thi">Quan ly hoa don</a>
        | <a href="${pageContext.request.contextPath}/account/ho-so">Ho so ca nhan</a>
        | <a href="${pageContext.request.contextPath}/logout">Dang xuat</a>
    </p>

    <c:if test="${param.msg == 'created-success'}">
        <p style="color: green;">Tao booking thanh cong.</p>
    </c:if>
    <c:if test="${param.msg == 'status-updated'}">
        <p style="color: green;">Cap nhat trang thai thanh cong.</p>
    </c:if>
    <c:if test="${param.msg == 'status-updated-invoice-created'}">
        <p style="color: green;">Da chuyen Completed va san sang hoa don o trang thai Chua thanh toan.</p>
    </c:if>
    <c:if test="${param.error == 'staff-time-conflict'}">
        <p style="color: red;">Nhan vien da co lich o khung gio nay.</p>
    </c:if>
    <c:if test="${param.error == 'invalid-status-transition'}">
        <p style="color: red;">Khong hop le workflow: Pending -> Confirmed -> Completed -> Cancelled.</p>
    </c:if>
    <c:if test="${param.error == 'invoice-auto-create-failed'}">
        <p style="color: red;">Da chuyen Completed nhung tao hoa don tu dong that bai.</p>
    </c:if>
    <c:if test="${param.error != null && param.error != 'staff-time-conflict' && param.error != 'invalid-status-transition' && param.error != 'invoice-auto-create-failed'}">
        <p style="color: red;">Co loi: ${param.error}</p>
    </c:if>

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-top: 20px;">
        <div style="border: 1px solid #ddd; padding: 16px; border-radius: 6px;">
            <h3>Tao Booking Moi</h3>
            <form action="${pageContext.request.contextPath}/booking/them" method="post">
                <label>Khach hang</label><br>
                <select name="khach_hang_id" style="width: 100%; padding: 6px;" required>
                    <option value="">-- Chon khach hang --</option>
                    <c:forEach items="${listKhachHang}" var="kh">
                        <option value="${kh.id}">${kh.ho_ten} - ${kh.sdt}</option>
                    </c:forEach>
                </select>
                <br><br>

                <label>Nhan vien</label><br>
                <select name="nhan_vien_id" style="width: 100%; padding: 6px;" required>
                    <option value="">-- Chon nhan vien --</option>
                    <c:forEach items="${listNhanVien}" var="nv">
                        <option value="${nv.id}">${nv.id} - ${nv.ho_ten}</option>
                    </c:forEach>
                </select>
                <br><br>

                <label>Dich vu</label><br>
                <select name="dich_vu_id" style="width: 100%; padding: 6px;" required>
                    <option value="">-- Chon dich vu --</option>
                    <c:forEach items="${listDichVu}" var="dv">
                        <option value="${dv.id}">${dv.ten_dich_vu}</option>
                    </c:forEach>
                </select>
                <br><br>

                <label>Ngay hen</label><br>
                <input type="date" name="ngay_hen" style="width: 100%; padding: 6px;" required>
                <br><br>

                <label>Khung gio</label><br>
                <select name="khung_gio" style="width: 100%; padding: 6px;" required>
                    <option value="">-- Chon khung gio --</option>
                    <c:forEach items="${khungGio}" var="slot">
                        <option value="${slot}">${slot}</option>
                    </c:forEach>
                </select>
                <br><br>

                <label>Ghi chu</label><br>
                <textarea name="ghi_chu" style="width: 100%; padding: 6px;" rows="3"></textarea>
                <br><br>

                <button type="submit">Dat lich (Pending)</button>
            </form>
        </div>

        <div style="border: 1px solid #ddd; padding: 16px; border-radius: 6px;">
            <h3>Bo Loc + Tim Kiem</h3>
            <form action="${pageContext.request.contextPath}/booking/hien-thi" method="get">
                <label>Tim theo ten khach / so dien thoai</label><br>
                <input type="text" name="tuKhoa" value="${param.tuKhoa}" style="width: 100%; padding: 6px;">
                <br><br>

                <label>Trang thai</label><br>
                <select name="trangThai" style="width: 100%; padding: 6px;">
                    <option value="">-- Tat ca --</option>
                    <option value="Pending" ${param.trangThai == 'Pending' ? 'selected' : ''}>Pending</option>
                    <option value="Confirmed" ${param.trangThai == 'Confirmed' ? 'selected' : ''}>Confirmed</option>
                    <option value="Completed" ${param.trangThai == 'Completed' ? 'selected' : ''}>Completed</option>
                    <option value="Cancelled" ${param.trangThai == 'Cancelled' ? 'selected' : ''}>Cancelled</option>
                </select>
                <br><br>

                <label>Tu ngay</label><br>
                <input type="date" name="ngayTu" value="${param.ngayTu}" style="width: 100%; padding: 6px;">
                <br><br>

                <label>Den ngay</label><br>
                <input type="date" name="ngayDen" value="${param.ngayDen}" style="width: 100%; padding: 6px;">
                <br><br>

                <label>Nam thong ke doanh thu</label><br>
                <input type="number" name="year" value="${year}" min="2000" max="2100" style="width: 100%; padding: 6px;">
                <br><br>

                <button type="submit">Ap dung bo loc</button>
            </form>
        </div>
    </div>

    <h3 style="margin-top: 24px;">Danh Sach Booking</h3>
    <table border="1" cellpadding="8" cellspacing="0" style="width: 100%; border-collapse: collapse;">
        <thead>
        <tr>
            <th>ID</th>
            <th>Khach hang</th>
            <th>SDT</th>
            <th>Nhan vien</th>
            <th>Dich vu</th>
            <th>Thoi gian hen</th>
            <th>Trang thai</th>
            <th>Workflow</th>
            <th>Ghi chu</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${listBooking}" var="b">
            <tr>
                <td>${b.id}</td>
                <td>${b.khachHangTen}</td>
                <td>${b.khachHangSdt}</td>
                <td>${b.nhanVienTen}</td>
                <td>${b.dichVuTen}</td>
                <td>${b.thoiGianHenText}</td>
                <td>${b.trangThaiBooking}</td>
                <td>
                    <c:choose>
                        <c:when test="${b.trangThaiBooking == 'Pending'}">
                            <form action="${pageContext.request.contextPath}/booking/cap-nhat-trang-thai" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${b.id}">
                                <input type="hidden" name="nextStatus" value="Confirmed">
                                <button type="submit">Confirm</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/booking/cap-nhat-trang-thai" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${b.id}">
                                <input type="hidden" name="nextStatus" value="Cancelled">
                                <button type="submit">Cancel</button>
                            </form>
                        </c:when>
                        <c:when test="${b.trangThaiBooking == 'Confirmed'}">
                            <form action="${pageContext.request.contextPath}/booking/cap-nhat-trang-thai" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${b.id}">
                                <input type="hidden" name="nextStatus" value="Completed">
                                <button type="submit">Complete</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/booking/cap-nhat-trang-thai" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${b.id}">
                                <input type="hidden" name="nextStatus" value="Cancelled">
                                <button type="submit">Cancel</button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            -
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>${b.ghiChuKhachHang}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <h3 style="margin-top: 24px;">Bieu Do Doanh Thu Thang (${year})</h3>
    <div style="border: 1px solid #ddd; padding: 16px; border-radius: 6px;">
        <c:if test="${!hasRevenueData}">
            <p style="color:#666;">Nam nay chua co doanh thu da thanh toan.</p>
        </c:if>
        <c:forEach items="${doanhThuThang}" var="dt">
            <div style="display:flex; align-items:center; gap: 10px; margin-bottom: 8px;">
                <div style="width: 70px;">Thang ${dt.month}</div>
                <div style="background:#eee; height:18px; width: 70%;">
                    <div style="height:18px; background:#2a7ade; width:${dt.widthPercent}%"></div>
                </div>
                <div>${dt.revenue}</div>
            </div>
        </c:forEach>
    </div>
</div>
</body>
</html>
