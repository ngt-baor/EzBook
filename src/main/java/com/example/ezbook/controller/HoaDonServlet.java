package com.example.ezbook.controller;

import com.example.ezbook.entity.HoaDon;
import com.example.ezbook.repository.BookingRepository;
import com.example.ezbook.repository.HoaDonRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.Date;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "hoaDonServlet", value = {
        "/hoa-don/hien-thi",
        "/hoa-don/them",
        "/hoa-don/sua",
        "/hoa-don/xoa"
})
public class HoaDonServlet extends HttpServlet {
    private final HoaDonRepository hoaDonRepository = new HoaDonRepository();
    private final BookingRepository bookingRepository = new BookingRepository();
    private static final String PAID_STATUS = "Da thanh toan";
    private static final DateTimeFormatter DB_TIME_FORMAT = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = trim(req.getParameter("tuKhoa"));
        String paymentStatus = normalizePaymentStatus(trim(req.getParameter("trangThai")));
        String paymentMethod = normalizePaymentMethod(trim(req.getParameter("phuongThuc")));
        Date fromDate = parseSqlDate(trim(req.getParameter("ngayTu")));
        Date toDate = parseSqlDate(trim(req.getParameter("ngayDen")));

        String editId = trim(req.getParameter("editId"));
        if (editId != null) {
            HoaDon editing = hoaDonRepository.findById(editId);
            req.setAttribute("editingHoaDon", editing);
            req.setAttribute("editingHoaDonTimeInput", toDateTimeLocalInput(editing == null ? null : editing.getThoi_gian_thanh_toan()));
        }

        req.setAttribute("listHoaDon", hoaDonRepository.search(keyword, paymentStatus, paymentMethod, fromDate, toDate));
        req.setAttribute("listBooking", bookingRepository.getAll());
        req.getRequestDispatcher("/hoa-don/hien-thi.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("/them")) {
            themHoaDon(req, resp);
            return;
        }
        if (uri.contains("/sua")) {
            suaHoaDon(req, resp);
            return;
        }
        if (uri.contains("/xoa")) {
            xoaHoaDon(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/hoa-don/hien-thi");
    }

    private void themHoaDon(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HoaDon data = parseFromRequest(req);
        if (data == null) {
            redirectWithError(resp, req.getContextPath(), "invalid-data");
            return;
        }
        boolean ok = hoaDonRepository.them(data);
        redirectWithStatus(resp, req.getContextPath(), ok, "created-success", "create-failed");
    }

    private void suaHoaDon(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HoaDon data = parseFromRequest(req);
        if (data == null) {
            redirectWithError(resp, req.getContextPath(), "invalid-data");
            return;
        }
        boolean ok = hoaDonRepository.update(data);
        redirectWithStatus(resp, req.getContextPath(), ok, "updated-success", "update-failed");
    }

    private void xoaHoaDon(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = trim(req.getParameter("id"));
        if (id == null) {
            redirectWithError(resp, req.getContextPath(), "missing-id");
            return;
        }
        boolean ok = hoaDonRepository.xoa(id);
        redirectWithStatus(resp, req.getContextPath(), ok, "deleted-success", "delete-failed");
    }

    private HoaDon parseFromRequest(HttpServletRequest req) {
        String id = trim(req.getParameter("id"));
        String bookingId = trim(req.getParameter("booking_id"));
        String tongTienRaw = trim(req.getParameter("tong_tien_goc"));
        String tienGiamRaw = trim(req.getParameter("tien_giam_gia"));
        String phuongThuc = normalizePaymentMethod(trim(req.getParameter("phuong_thuc_thanh_toan")));
        String trangThai = trim(req.getParameter("trang_thai_thanh_toan"));
        String thoiGianThanhToan = trim(req.getParameter("thoi_gian_thanh_toan"));

        if (id == null || bookingId == null || tongTienRaw == null || tienGiamRaw == null || trangThai == null || phuongThuc == null) {
            return null;
        }

        Double tongTien = parseDouble(tongTienRaw);
        Double tienGiam = parseDouble(tienGiamRaw);
        if (tongTien == null || tienGiam == null || tongTien < 0 || tienGiam < 0) {
            return null;
        }

        double thanhTien = Math.max(0, tongTien - tienGiam);

        if (PAID_STATUS.equalsIgnoreCase(trangThai)) {
            if (thoiGianThanhToan == null) {
                thoiGianThanhToan = LocalDateTime.now().format(DB_TIME_FORMAT);
            } else {
                thoiGianThanhToan = normalizeDateTime(thoiGianThanhToan);
            }
        } else {
            thoiGianThanhToan = null;
        }

        return new HoaDon(
                id,
                bookingId,
                tongTien,
                tienGiam,
                thanhTien,
                phuongThuc,
                thoiGianThanhToan,
                trangThai
        );
    }

    private String normalizeDateTime(String raw) {
        String normalized = raw.replace("T", " ");
        if (normalized.length() == 16) {
            normalized += ":00";
        }
        return normalized;
    }

    private String toDateTimeLocalInput(String value) {
        if (value == null || value.trim().isEmpty()) {
            return "";
        }
        String normalized = value.trim().replace(" ", "T");
        if (normalized.length() >= 16) {
            return normalized.substring(0, 16);
        }
        return normalized;
    }

    private Double parseDouble(String raw) {
        try {
            return Double.parseDouble(raw);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String normalizePaymentMethod(String raw) {
        if (raw == null) {
            return null;
        }
        String value = raw.trim();
        if ("Tien mat".equalsIgnoreCase(value)) {
            return "Tien mat";
        }
        if ("Chuyen khoan".equalsIgnoreCase(value)) {
            return "Chuyen khoan";
        }
        return null;
    }

    private String normalizePaymentStatus(String raw) {
        if (raw == null) {
            return null;
        }
        String value = raw.trim();
        if ("Chua thanh toan".equalsIgnoreCase(value)) {
            return "Chua thanh toan";
        }
        if ("Da thanh toan".equalsIgnoreCase(value)) {
            return "Da thanh toan";
        }
        if ("Huy hoa don".equalsIgnoreCase(value)) {
            return "Huy hoa don";
        }
        return null;
    }

    private Date parseSqlDate(String raw) {
        if (raw == null) {
            return null;
        }
        try {
            return Date.valueOf(raw);
        } catch (IllegalArgumentException e) {
            return null;
        }
    }

    private void redirectWithStatus(HttpServletResponse resp, String contextPath, boolean ok, String msg, String error) throws IOException {
        if (ok) {
            resp.sendRedirect(contextPath + "/hoa-don/hien-thi?msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
            return;
        }
        redirectWithError(resp, contextPath, error);
    }

    private void redirectWithError(HttpServletResponse resp, String contextPath, String error) throws IOException {
        resp.sendRedirect(contextPath + "/hoa-don/hien-thi?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8));
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String v = value.trim();
        return v.isEmpty() ? null : v;
    }
}
