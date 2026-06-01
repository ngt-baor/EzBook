package com.example.ezbook.controller;

import com.example.ezbook.entity.DichVu;
import com.example.ezbook.entity.LoaiDichVu;
import com.example.ezbook.repository.DichVuRepository;
import com.example.ezbook.repository.LoaiDichVuRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "adminDichVuServlet", value = {
        "/admin/quan-ly-dich-vu",
        "/admin/quan-ly-dich-vu/loai/them",
        "/admin/quan-ly-dich-vu/loai/sua",
        "/admin/quan-ly-dich-vu/loai/xoa",
        "/admin/quan-ly-dich-vu/dich-vu/them",
        "/admin/quan-ly-dich-vu/dich-vu/sua",
        "/admin/quan-ly-dich-vu/dich-vu/xoa"
})
public class AdminDichVuServlet extends HttpServlet {
    private final LoaiDichVuRepository loaiDichVuRepository = new LoaiDichVuRepository();
    private final DichVuRepository dichVuRepository = new DichVuRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String editLoaiId = trim(req.getParameter("editLoaiId"));
        String editDichVuId = trim(req.getParameter("editDichVuId"));

        if (editLoaiId != null) {
            req.setAttribute("editingLoai", loaiDichVuRepository.findById(editLoaiId));
        }
        if (editDichVuId != null) {
            req.setAttribute("editingDichVu", dichVuRepository.findById(editDichVuId));
        }

        req.setAttribute("listLoaiDichVu", loaiDichVuRepository.getAll());
        req.setAttribute("listDichVu", dichVuRepository.getAll());
        req.getRequestDispatcher("/admin/quan-ly-dich-vu.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("/loai/them")) {
            themLoaiDichVu(req, resp);
            return;
        }
        if (uri.contains("/loai/sua")) {
            suaLoaiDichVu(req, resp);
            return;
        }
        if (uri.contains("/loai/xoa")) {
            xoaLoaiDichVu(req, resp);
            return;
        }
        if (uri.contains("/dich-vu/them")) {
            themDichVu(req, resp);
            return;
        }
        if (uri.contains("/dich-vu/sua")) {
            suaDichVu(req, resp);
            return;
        }
        if (uri.contains("/dich-vu/xoa")) {
            xoaDichVu(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quan-ly-dich-vu");
    }

    private void themLoaiDichVu(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = trim(req.getParameter("id"));
        String tenLoai = trim(req.getParameter("ten_loai"));
        String moTa = trim(req.getParameter("mo_ta"));

        if (id == null || tenLoai == null) {
            redirectWithError(resp, req.getContextPath(), "loai-missing-data");
            return;
        }

        boolean ok = loaiDichVuRepository.them(new LoaiDichVu(id, tenLoai, moTa));
        redirectWithStatus(resp, req.getContextPath(), ok, "loai-created", "loai-create-failed");
    }

    private void suaLoaiDichVu(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = trim(req.getParameter("id"));
        String tenLoai = trim(req.getParameter("ten_loai"));
        String moTa = trim(req.getParameter("mo_ta"));

        if (id == null || tenLoai == null) {
            redirectWithError(resp, req.getContextPath(), "loai-missing-data");
            return;
        }

        boolean ok = loaiDichVuRepository.update(new LoaiDichVu(id, tenLoai, moTa));
        redirectWithStatus(resp, req.getContextPath(), ok, "loai-updated", "loai-update-failed");
    }

    private void xoaLoaiDichVu(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = trim(req.getParameter("id"));
        if (id == null) {
            redirectWithError(resp, req.getContextPath(), "loai-missing-id");
            return;
        }

        boolean ok = loaiDichVuRepository.xoa(id);
        redirectWithStatus(resp, req.getContextPath(), ok, "loai-deleted", "loai-delete-failed");
    }

    private void themDichVu(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = trim(req.getParameter("id"));
        String loaiDichVuId = trim(req.getParameter("loai_dich_vu_id"));
        String tenDichVu = trim(req.getParameter("ten_dich_vu"));
        String giaTienRaw = trim(req.getParameter("gia_tien"));
        String trangThaiRaw = trim(req.getParameter("trang_thai"));

        if (id == null || loaiDichVuId == null || tenDichVu == null || giaTienRaw == null) {
            redirectWithError(resp, req.getContextPath(), "dich-vu-missing-data");
            return;
        }

        Double giaTien = parseDouble(giaTienRaw);
        if (giaTien == null) {
            redirectWithError(resp, req.getContextPath(), "dich-vu-invalid-price");
            return;
        }
        boolean trangThai = Boolean.parseBoolean(trangThaiRaw);

        boolean ok = dichVuRepository.them(new DichVu(id, loaiDichVuId, tenDichVu, giaTien, trangThai));
        redirectWithStatus(resp, req.getContextPath(), ok, "dich-vu-created", "dich-vu-create-failed");
    }

    private void suaDichVu(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = trim(req.getParameter("id"));
        String loaiDichVuId = trim(req.getParameter("loai_dich_vu_id"));
        String tenDichVu = trim(req.getParameter("ten_dich_vu"));
        String giaTienRaw = trim(req.getParameter("gia_tien"));
        String trangThaiRaw = trim(req.getParameter("trang_thai"));

        if (id == null || loaiDichVuId == null || tenDichVu == null || giaTienRaw == null) {
            redirectWithError(resp, req.getContextPath(), "dich-vu-missing-data");
            return;
        }

        Double giaTien = parseDouble(giaTienRaw);
        if (giaTien == null) {
            redirectWithError(resp, req.getContextPath(), "dich-vu-invalid-price");
            return;
        }
        boolean trangThai = Boolean.parseBoolean(trangThaiRaw);

        boolean ok = dichVuRepository.update(new DichVu(id, loaiDichVuId, tenDichVu, giaTien, trangThai));
        redirectWithStatus(resp, req.getContextPath(), ok, "dich-vu-updated", "dich-vu-update-failed");
    }

    private void xoaDichVu(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = trim(req.getParameter("id"));
        if (id == null) {
            redirectWithError(resp, req.getContextPath(), "dich-vu-missing-id");
            return;
        }

        boolean ok = dichVuRepository.xoa(id);
        redirectWithStatus(resp, req.getContextPath(), ok, "dich-vu-deleted", "dich-vu-delete-failed");
    }

    private void redirectWithStatus(HttpServletResponse resp, String contextPath, boolean ok, String successMsg, String failError) throws IOException {
        if (ok) {
            resp.sendRedirect(contextPath + "/admin/quan-ly-dich-vu?msg=" + URLEncoder.encode(successMsg, StandardCharsets.UTF_8));
            return;
        }
        redirectWithError(resp, contextPath, failError);
    }

    private void redirectWithError(HttpServletResponse resp, String contextPath, String error) throws IOException {
        resp.sendRedirect(contextPath + "/admin/quan-ly-dich-vu?error=" + URLEncoder.encode(error, StandardCharsets.UTF_8));
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String v = value.trim();
        return v.isEmpty() ? null : v;
    }

    private Double parseDouble(String raw) {
        try {
            return Double.parseDouble(raw);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
