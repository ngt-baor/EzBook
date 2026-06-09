package com.example.ezbook.controller;

import com.example.ezbook.entity.KhuyenMai;
import com.example.ezbook.repository.KhuyenMaiRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "adminKhuyenMaiServlet", value = {
        "/admin/quan-ly-khuyen-mai",
        "/admin/quan-ly-khuyen-mai/them",
        "/admin/quan-ly-khuyen-mai/sua",
        "/admin/quan-ly-khuyen-mai/xoa"
})
public class AdminKhuyenMaiServlet extends HttpServlet {
    private final KhuyenMaiRepository khuyenMaiRepository = new KhuyenMaiRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        boolean isAdmin = isAdmin(req);
        String editId = trim(req.getParameter("editId"));
        if (isAdmin && editId != null) {
            KhuyenMai editing = khuyenMaiRepository.findById(editId);
            req.setAttribute("editingKhuyenMai", editing);
            req.setAttribute("editingNgayBatDau", toDateTimeLocalInput(editing == null ? null : editing.getNgay_bat_dau()));
            req.setAttribute("editingNgayKetThuc", toDateTimeLocalInput(editing == null ? null : editing.getNgay_ket_thuc()));
        }
        String keyword = trim(req.getParameter("tuKhoa"));
        String loaiGiam = trim(req.getParameter("loaiGiam"));
        String trangThai = trim(req.getParameter("trangThai"));
        String hieuLuc = trim(req.getParameter("hieuLuc"));

        req.setAttribute("canManageKhuyenMai", isAdmin);
        req.setAttribute("listKhuyenMai", khuyenMaiRepository.search(keyword, loaiGiam, trangThai, hieuLuc));
        req.getRequestDispatcher("/admin/quan-ly-khuyen-mai.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if (!isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/admin/quan-ly-khuyen-mai?error=forbidden");
            return;
        }
        String uri = req.getRequestURI();
        if (uri.contains("/them")) {
            themKhuyenMai(req, resp);
            return;
        }
        if (uri.contains("/sua")) {
            suaKhuyenMai(req, resp);
            return;
        }
        if (uri.contains("/xoa")) {
            xoaKhuyenMai(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quan-ly-khuyen-mai");
    }

    private void themKhuyenMai(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        KhuyenMai khuyenMai = parseFromRequest(req);
        if (khuyenMai == null) {
            redirectWithError(resp, req.getContextPath(), "invalid-data");
            return;
        }
        boolean ok = khuyenMaiRepository.them(khuyenMai);
        redirectWithStatus(resp, req.getContextPath(), ok, "created-success", "create-failed");
    }

    private void suaKhuyenMai(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        KhuyenMai khuyenMai = parseFromRequest(req);
        if (khuyenMai == null) {
            redirectWithError(resp, req.getContextPath(), "invalid-data");
            return;
        }
        boolean ok = khuyenMaiRepository.update(khuyenMai);
        redirectWithStatus(resp, req.getContextPath(), ok, "updated-success", "update-failed");
    }

    private void xoaKhuyenMai(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = trim(req.getParameter("id"));
        if (id == null) {
            redirectWithError(resp, req.getContextPath(), "missing-id");
            return;
        }
        boolean ok = khuyenMaiRepository.xoa(id);
        redirectWithStatus(resp, req.getContextPath(), ok, "deleted-success", "delete-failed");
    }

    private KhuyenMai parseFromRequest(HttpServletRequest req) {
        String id = trim(req.getParameter("id"));
        String maGiamGia = trim(req.getParameter("ma_giam_gia"));
        String loaiGiam = trim(req.getParameter("loai_giam"));
        String giaTriRaw = trim(req.getParameter("gia_tri"));
        String ngayBatDau = normalizeDateTime(trim(req.getParameter("ngay_bat_dau")));
        String ngayKetThuc = normalizeDateTime(trim(req.getParameter("ngay_ket_thuc")));
        String soLuongRaw = trim(req.getParameter("so_luong_gioi_han"));
        String trangThaiRaw = trim(req.getParameter("trang_thai"));

        if (id == null || maGiamGia == null || loaiGiam == null || giaTriRaw == null
                || ngayBatDau == null || ngayKetThuc == null || soLuongRaw == null) {
            return null;
        }

        Double giaTri = parseDouble(giaTriRaw);
        Integer soLuong = parseInteger(soLuongRaw);
        if (giaTri == null || giaTri < 0 || isPercentDiscount(loaiGiam) && giaTri > 100
                || soLuong == null || soLuong < 0) {
            return null;
        }

        return new KhuyenMai(
                id,
                maGiamGia.toUpperCase(),
                loaiGiam,
                giaTri,
                ngayBatDau,
                ngayKetThuc,
                soLuong,
                Boolean.parseBoolean(trangThaiRaw)
        );
    }

    private String normalizeDateTime(String value) {
        if (value == null) {
            return null;
        }
        String normalized = value.replace("T", " ");
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

    private Integer parseInteger(String raw) {
        try {
            return Integer.parseInt(raw);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private boolean isPercentDiscount(String loaiGiam) {
        return loaiGiam != null && "Phan tram".equalsIgnoreCase(loaiGiam.trim());
    }

    private void redirectWithMessage(HttpServletResponse resp, String contextPath, String msg) throws IOException {
        resp.sendRedirect(contextPath + "/admin/quan-ly-khuyen-mai?msg=" + URLEncoder.encode(msg, StandardCharsets.UTF_8));
    }

    private void redirectWithStatus(HttpServletResponse resp, String contextPath, boolean ok, String msg, String error) throws IOException {
        if (ok) {
            redirectWithMessage(resp, contextPath, msg);
            return;
        }
        redirectWithError(resp, contextPath, error);
    }

    private void redirectWithError(HttpServletResponse resp, String contextPath, String error) throws IOException {
        resp.sendRedirect(contextPath + "/admin/quan-ly-khuyen-mai?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8));
    }

    private boolean isAdmin(HttpServletRequest req) {
        Object role = req.getSession(false) == null ? null : req.getSession(false).getAttribute("role");
        return "ADMIN".equals(role);
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String v = value.trim();
        return v.isEmpty() ? null : v;
    }
}
