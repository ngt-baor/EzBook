package com.example.ezbook.controller;

import com.example.ezbook.entity.Booking;
import com.example.ezbook.entity.KhachHang;
import com.example.ezbook.repository.BookingRepository;
import com.example.ezbook.repository.DichVuRepository;
import com.example.ezbook.repository.KhachHangRepository;
import com.example.ezbook.repository.NhanVienRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "khachHangOnlineBookingServlet", value = {
        "/khach-hang/booking-online",
        "/khach-hang/booking-online/tao"
})
public class KhachHangOnlineBookingServlet extends HttpServlet {
    private final KhachHangRepository khachHangRepository = new KhachHangRepository();
    private final BookingRepository bookingRepository = new BookingRepository();
    private final DichVuRepository dichVuRepository = new DichVuRepository();
    private final NhanVienRepository nhanVienRepository = new NhanVienRepository();

    private static final List<String> KHUNG_GIO = Arrays.asList(
            "08:00", "09:00", "10:00", "11:00",
            "13:00", "14:00", "15:00", "16:00",
            "17:00", "18:00", "19:00", "20:00"
    );

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String customerUsername = session == null ? null : (String) session.getAttribute("customerUsername");
        String sdt = session == null ? null : (String) session.getAttribute("customerPhone");
        if (sdt == null || sdt.isBlank()) {
            sdt = customerUsername;
        }

        req.setAttribute("listDichVu", dichVuRepository.getAll());
        req.setAttribute("listNhanVien", nhanVienRepository.getAll());
        req.setAttribute("khungGio", KHUNG_GIO);
        if (sdt != null && !sdt.isBlank()) {
            req.setAttribute("bookingCuaToi", bookingRepository.getByKhachHangSdt(sdt));
            req.setAttribute("sdtTimKiem", sdt);
            req.setAttribute("customerName", session == null ? null : session.getAttribute("customerName"));
        }
        req.getRequestDispatcher("/khach-hang/booking-online.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String sdt = session == null ? null : (String) session.getAttribute("customerPhone");
        if (sdt == null || sdt.isBlank()) {
            sdt = session == null ? null : (String) session.getAttribute("customerUsername");
        }
        String dichVuId = trim(req.getParameter("dich_vu_id"));
        String nhanVienId = trim(req.getParameter("nhan_vien_id"));
        String ngayHen = trim(req.getParameter("ngay_hen"));
        String khungGio = trim(req.getParameter("khung_gio"));
        String ghiChu = trim(req.getParameter("ghi_chu"));

        if (sdt == null || dichVuId == null || ngayHen == null || khungGio == null) {
            redirectWithMessage(resp, req.getContextPath() + "/khach-hang/booking-online", "error", "missing-data", sdt);
            return;
        }

        Timestamp thoiGianHen;
        try {
            thoiGianHen = Timestamp.valueOf(LocalDateTime.of(LocalDate.parse(ngayHen), LocalTime.parse(khungGio)));
        } catch (Exception e) {
            redirectWithMessage(resp, req.getContextPath() + "/khach-hang/booking-online", "error", "invalid-datetime", sdt);
            return;
        }

        if (nhanVienId != null && bookingRepository.isNhanVienTrungLich(nhanVienId, thoiGianHen)) {
            redirectWithMessage(resp, req.getContextPath() + "/khach-hang/booking-online", "error", "staff-time-conflict", sdt);
            return;
        }

        KhachHang khachHang = khachHangRepository.findBySdt(sdt);
        if (khachHang == null) {
            redirectWithMessage(resp, req.getContextPath() + "/khach-hang/booking-online", "error", "customer-not-found", sdt);
            return;
        }
        String khachHangId = khachHang.getId();

        String bookingId = "BK" + System.currentTimeMillis();
        Booking booking = new Booking(
                bookingId,
                khachHangId,
                nhanVienId,
                dichVuId,
                null,
                thoiGianHen.toString(),
                "Pending",
                ghiChu == null ? "" : ghiChu
        );

        boolean ok = bookingRepository.them(booking, thoiGianHen);
        if (ok) {
            redirectWithMessage(resp, req.getContextPath() + "/khach-hang/booking-online", "msg", "created-success", sdt);
        } else {
            redirectWithMessage(resp, req.getContextPath() + "/khach-hang/booking-online", "error", "create-booking-failed", sdt);
        }
    }

    private void redirectWithMessage(HttpServletResponse resp, String baseUrl, String key, String value, String sdt) throws IOException {
        String encodedValue = URLEncoder.encode(value, StandardCharsets.UTF_8);
        StringBuilder url = new StringBuilder(baseUrl).append("?").append(key).append("=").append(encodedValue);
        if (sdt != null && !sdt.isBlank()) {
            url.append("&sdt=").append(URLEncoder.encode(sdt, StandardCharsets.UTF_8));
        }
        resp.sendRedirect(url.toString());
    }

    private String trim(String value) {
        if (value == null) return null;
        String v = value.trim();
        return v.isEmpty() ? null : v;
    }
}
