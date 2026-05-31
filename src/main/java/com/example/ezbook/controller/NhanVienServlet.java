package com.example.ezbook.controller;

import com.example.ezbook.entity.NhanVien;
import com.example.ezbook.repository.NhanVienRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "nhanVienServlet", value = {
        "/nhan-vien/hien-thi",
        "/nhan-vien/view-update",
        "/nhan-vien/xoa",
        "/nhan-vien/them",
        "/nhan-vien/sua"
})
public class NhanVienServlet extends HttpServlet {
    private final NhanVienRepository nhanVienRepository = new NhanVienRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("hien-thi")) {
            hienThi(req, resp);
            return;
        }
        if (uri.contains("view-update")) {
            viewUpdate(req, resp);
            return;
        }
        if (uri.contains("xoa")) {
            xoaNhanVien(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/nhan-vien/hien-thi");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("them")) {
            themNhanVien(req, resp);
            return;
        }
        if (uri.contains("sua")) {
            suaNhanVien(req, resp);
            return;
        }
        if (uri.contains("xoa")) {
            xoaNhanVien(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/nhan-vien/hien-thi");
    }

    private void hienThi(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("listNhanVien", nhanVienRepository.getAll());
        req.getRequestDispatcher("/nhan-vien/hien-thi.jsp").forward(req, resp);
    }

    private void viewUpdate(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String id = req.getParameter("id");
        req.setAttribute("nv", nhanVienRepository.findById(id));
        req.getRequestDispatcher("/nhan-vien/view-update.jsp").forward(req, resp);
    }

    private void xoaNhanVien(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        nhanVienRepository.xoa(id);
        resp.sendRedirect(req.getContextPath() + "/nhan-vien/hien-thi");
    }

    private void themNhanVien(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        String hoTen = req.getParameter("ho_ten");
        String sdt = req.getParameter("sdt");
        String vaiTro = req.getParameter("vai_tro");
        Boolean trangThai = Boolean.valueOf(req.getParameter("trang_thai"));

        NhanVien nv = new NhanVien(id, hoTen, sdt, vaiTro, trangThai, null);
        nhanVienRepository.them(nv);

        resp.sendRedirect(req.getContextPath() + "/nhan-vien/hien-thi");
    }

    private void suaNhanVien(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String id = req.getParameter("id");
        String hoTen = req.getParameter("ho_ten");
        String sdt = req.getParameter("sdt");
        String vaiTro = req.getParameter("vai_tro");
        Boolean trangThai = Boolean.valueOf(req.getParameter("trang_thai"));

        NhanVien nv = new NhanVien(id, hoTen, sdt, vaiTro, trangThai, null);
        nhanVienRepository.update(nv);

        resp.sendRedirect(req.getContextPath() + "/nhan-vien/hien-thi");
    }
}
