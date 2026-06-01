package com.example.ezbook.controller;

import com.example.ezbook.entity.Booking;
import com.example.ezbook.entity.MonthlyRevenue;
import com.example.ezbook.repository.BookingRepository;
import com.example.ezbook.repository.DichVuRepository;
import com.example.ezbook.repository.HoaDonRepository;
import com.example.ezbook.repository.KhachHangRepository;
import com.example.ezbook.repository.NhanVienRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.Year;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "bookingServlet", value = {
        "/booking/hien-thi",
        "/booking/them",
        "/booking/cap-nhat-trang-thai"
})
public class BookingServlet extends HttpServlet {
    private final BookingRepository bookingRepository = new BookingRepository();
    private final KhachHangRepository khachHangRepository = new KhachHangRepository();
    private final NhanVienRepository nhanVienRepository = new NhanVienRepository();
    private final DichVuRepository dichVuRepository = new DichVuRepository();
    private final HoaDonRepository hoaDonRepository = new HoaDonRepository();

    private static final List<String> KHUNG_GIO = Arrays.asList(
            "08:00", "09:00", "10:00", "11:00",
            "13:00", "14:00", "15:00", "16:00",
            "17:00", "18:00", "19:00", "20:00"
    );

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        hienThi(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("/them")) {
            taoBooking(req, resp);
            return;
        }
        if (uri.contains("/cap-nhat-trang-thai")) {
            capNhatTrangThai(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/booking/hien-thi");
    }

    private void hienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String tuKhoa = req.getParameter("tuKhoa");
        String trangThai = req.getParameter("trangThai");
        Date ngayTu = parseSqlDate(req.getParameter("ngayTu"));
        Date ngayDen = parseSqlDate(req.getParameter("ngayDen"));
        int year = parseYear(req.getParameter("year"));

        req.setAttribute("listBooking", bookingRepository.getAllForView(tuKhoa, trangThai, ngayTu, ngayDen));
        req.setAttribute("listKhachHang", khachHangRepository.getAll());
        req.setAttribute("listNhanVien", nhanVienRepository.getAll());
        req.setAttribute("listDichVu", dichVuRepository.getAll());
        req.setAttribute("khungGio", KHUNG_GIO);
        req.setAttribute("year", year);

        List<MonthlyRevenue> doanhThuThang = hoaDonRepository.thongKeDoanhThuTheoThang(year);
        double max = 0.0;
        for (MonthlyRevenue item : doanhThuThang) {
            if (item.getRevenue() > max) {
                max = item.getRevenue();
            }
        }
        double safeMax = max <= 0 ? 1.0 : max;
        for (MonthlyRevenue item : doanhThuThang) {
            item.setWidthPercent((item.getRevenue() / safeMax) * 100.0);
        }
        req.setAttribute("doanhThuThang", doanhThuThang);
        req.setAttribute("hasRevenueData", max > 0);
        req.setAttribute("maxDoanhThu", safeMax);

        req.getRequestDispatcher("/booking/hien-thi.jsp").forward(req, resp);
    }

    private void taoBooking(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String khachHangId = trim(req.getParameter("khach_hang_id"));
        String nhanVienId = trim(req.getParameter("nhan_vien_id"));
        String dichVuId = trim(req.getParameter("dich_vu_id"));
        String ngayHen = trim(req.getParameter("ngay_hen"));
        String khungGio = trim(req.getParameter("khung_gio"));
        String ghiChu = trim(req.getParameter("ghi_chu"));

        if (khachHangId == null || nhanVienId == null || dichVuId == null || ngayHen == null || khungGio == null) {
            redirectWithMessage(resp, req.getContextPath() + "/booking/hien-thi", "error", "missing-data");
            return;
        }

        Timestamp thoiGianHen;
        try {
            LocalDate date = LocalDate.parse(ngayHen);
            LocalTime time = LocalTime.parse(khungGio);
            thoiGianHen = Timestamp.valueOf(LocalDateTime.of(date, time));
        } catch (Exception e) {
            redirectWithMessage(resp, req.getContextPath() + "/booking/hien-thi", "error", "invalid-datetime");
            return;
        }

        if (bookingRepository.isNhanVienTrungLich(nhanVienId, thoiGianHen)) {
            redirectWithMessage(resp, req.getContextPath() + "/booking/hien-thi", "error", "staff-time-conflict");
            return;
        }

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
            redirectWithMessage(resp, req.getContextPath() + "/booking/hien-thi", "msg", "created-success");
        } else {
            redirectWithMessage(resp, req.getContextPath() + "/booking/hien-thi", "error", "create-failed");
        }
    }

    private void capNhatTrangThai(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String bookingId = trim(req.getParameter("id"));
        String nextStatus = bookingRepository.normalizeStatus(trim(req.getParameter("nextStatus")));

        if (bookingId == null || nextStatus == null) {
            redirectWithMessage(resp, req.getContextPath() + "/booking/hien-thi", "error", "missing-status-data");
            return;
        }

        String currentStatus = bookingRepository.findStatusById(bookingId);
        if (currentStatus == null) {
            redirectWithMessage(resp, req.getContextPath() + "/booking/hien-thi", "error", "booking-not-found");
            return;
        }

        if (!bookingRepository.isValidStatusTransition(currentStatus, nextStatus)) {
            redirectWithMessage(resp, req.getContextPath() + "/booking/hien-thi", "error", "invalid-status-transition");
            return;
        }

        boolean ok = bookingRepository.updateStatus(bookingId, nextStatus);
        if (ok) {
            redirectWithMessage(resp, req.getContextPath() + "/booking/hien-thi", "msg", "status-updated");
        } else {
            redirectWithMessage(resp, req.getContextPath() + "/booking/hien-thi", "error", "status-update-failed");
        }
    }

    private Date parseSqlDate(String value) {
        try {
            if (value == null || value.isBlank()) return null;
            return Date.valueOf(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private int parseYear(String yearRaw) {
        try {
            if (yearRaw == null || yearRaw.isBlank()) return Year.now().getValue();
            return Integer.parseInt(yearRaw.trim());
        } catch (NumberFormatException e) {
            return Year.now().getValue();
        }
    }

    private void redirectWithMessage(HttpServletResponse resp, String baseUrl, String key, String value) throws IOException {
        String encodedValue = URLEncoder.encode(value, StandardCharsets.UTF_8);
        resp.sendRedirect(baseUrl + "?" + key + "=" + encodedValue);
    }

    private String trim(String value) {
        if (value == null) return null;
        String v = value.trim();
        return v.isEmpty() ? null : v;
    }
}
