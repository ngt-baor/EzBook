<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quan Ly Hoa Don</title>
</head>
<body>
<div style="width: 1180px; margin: 24px auto; font-family: Arial, sans-serif;">
    <h2>Quan Ly Hoa Don (Admin/Staff)</h2>
    <p>
        <a href="${pageContext.request.contextPath}/pages/giao-dien-nhan-vien.jsp">Ve Trang Chu</a>
        | <a href="${pageContext.request.contextPath}/booking/hien-thi">Quan ly booking</a>
        | <a href="${pageContext.request.contextPath}/logout">Dang xuat</a>
    </p>

    <c:if test="${param.msg != null}">
        <p style="color: green;">Thanh cong: ${param.msg}</p>
    </c:if>
    <c:if test="${param.error != null}">
        <p style="color: red;">Loi: ${param.error}</p>
        <p style="color: #666;">Neu loi do trung booking_id, moi booking chi tao duoc 1 hoa don.</p>
    </c:if>

    <div style="border:1px solid #ddd; border-radius: 6px; padding: 16px;">
        <h3>
            <c:choose>
                <c:when test="${editingHoaDon != null}">Sua Hoa Don</c:when>
                <c:otherwise>Them Hoa Don</c:otherwise>
            </c:choose>
        </h3>

        <form action="${pageContext.request.contextPath}${editingHoaDon != null ? '/hoa-don/sua' : '/hoa-don/them'}" method="post">
            <div style="display:grid; grid-template-columns: repeat(4, 1fr); gap: 12px;">
                <div>
                    <label>Ma hoa don</label><br>
                    <input type="text" name="id" value="${editingHoaDon.id}" ${editingHoaDon != null ? 'readonly' : ''} style="width:100%; padding:6px;" required>
                </div>
                <div>
                    <label>Booking</label><br>
                    <select name="booking_id" style="width:100%; padding:6px;" required>
                        <option value="">-- Chon booking --</option>
                        <c:forEach items="${listBooking}" var="b">
                            <option value="${b.id}" ${editingHoaDon != null && editingHoaDon.booking_id == b.id ? 'selected' : ''}>${b.id}</option>
                        </c:forEach>
                    </select>
                </div>
                <div>
                    <label>Tong tien goc</label><br>
                    <input type="number" min="0" step="1000" name="tong_tien_goc" value="${editingHoaDon.tong_tien_goc}" style="width:100%; padding:6px;" required>
                </div>
                <div>
                    <label>Tien giam gia</label><br>
                    <input type="number" min="0" step="1000" name="tien_giam_gia" value="${editingHoaDon.tien_giam_gia}" style="width:100%; padding:6px;" required>
                </div>
                <div>
                    <label>Phuong thuc thanh toan</label><br>
                    <select name="phuong_thuc_thanh_toan" style="width:100%; padding:6px;" required>
                        <option value="Tien mat" ${editingHoaDon == null || editingHoaDon.phuong_thuc_thanh_toan == 'Tien mat' ? 'selected' : ''}>Tien mat</option>
                        <option value="Chuyen khoan" ${editingHoaDon != null && editingHoaDon.phuong_thuc_thanh_toan == 'Chuyen khoan' ? 'selected' : ''}>Chuyen khoan</option>
                    </select>
                </div>
                <div>
                    <label>Trang thai thanh toan</label><br>
                    <select name="trang_thai_thanh_toan" style="width:100%; padding:6px;" required>
                        <option value="Chua thanh toan" ${editingHoaDon == null || editingHoaDon.trang_thai_thanh_toan == 'Chua thanh toan' ? 'selected' : ''}>Chua thanh toan</option>
                        <option value="Da thanh toan" ${editingHoaDon != null && editingHoaDon.trang_thai_thanh_toan == 'Da thanh toan' ? 'selected' : ''}>Da thanh toan</option>
                        <option value="Huy hoa don" ${editingHoaDon != null && editingHoaDon.trang_thai_thanh_toan == 'Huy hoa don' ? 'selected' : ''}>Huy hoa don</option>
                    </select>
                </div>
                <div>
                    <label>Thoi gian thanh toan</label><br>
                    <input type="datetime-local" name="thoi_gian_thanh_toan" value="${editingHoaDonTimeInput}" style="width:100%; padding:6px;">
                </div>
                <div style="display:flex; align-items:flex-end;">
                    <small style="color:#666;">Thanh tien se duoc tinh = Tong tien goc - Tien giam gia.</small>
                </div>
            </div>
            <br>
            <button type="submit">${editingHoaDon != null ? 'Cap nhat hoa don' : 'Them hoa don'}</button>
            <c:if test="${editingHoaDon != null}">
                <a href="${pageContext.request.contextPath}/hoa-don/hien-thi">Huy sua</a>
            </c:if>
        </form>
    </div>

    <h3 style="margin-top: 24px;">Danh Sach Hoa Don</h3>
    <table border="1" cellpadding="8" cellspacing="0" style="width:100%; border-collapse: collapse;">
        <thead>
        <tr>
            <th>Ma HD</th>
            <th>Booking</th>
            <th>Tong goc</th>
            <th>Giam gia</th>
            <th>Thanh tien</th>
            <th>PTTT</th>
            <th>Thoi gian TT</th>
            <th>Trang thai TT</th>
            <th>Hanh dong</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${listHoaDon}" var="hd">
            <tr>
                <td>${hd.id}</td>
                <td>${hd.booking_id}</td>
                <td>${hd.tong_tien_goc}</td>
                <td>${hd.tien_giam_gia}</td>
                <td>${hd.thanh_tien}</td>
                <td>${hd.phuong_thuc_thanh_toan}</td>
                <td>${hd.thoi_gian_thanh_toan}</td>
                <td>${hd.trang_thai_thanh_toan}</td>
                <td>
                    <a href="${pageContext.request.contextPath}/hoa-don/hien-thi?editId=${hd.id}">Sua</a>
                    |
                    <form action="${pageContext.request.contextPath}/hoa-don/xoa" method="post" style="display:inline;">
                        <input type="hidden" name="id" value="${hd.id}">
                        <button type="submit" onclick="return confirm('Xoa hoa don nay?')">Xoa</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>
</body>
</html>
