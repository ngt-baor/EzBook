package com.example.ezbook.controller;

import com.example.ezbook.entity.KhachHang;
import com.example.ezbook.entity.NhanVien;
import com.example.ezbook.repository.LoginRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "authServlet", value = {"/login", "/logout"})
public class AuthServlet extends HttpServlet {
    private LoginRepository loginRepository = new LoginRepository();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String taiKhoan = req.getParameter("username");
        String matKhau = req.getParameter("password");
        HttpSession session = req.getSession();

        // Bước 1: Quét tự động trong bảng Nhân viên trước
        NhanVien nv = loginRepository.checkLoginNhanVien(taiKhoan, matKhau);

        if (nv != null) {
            // Trường hợp tài khoản tồn tại nhưng đang bị khóa
            if (!nv.isTrang_thai() && nv.getHo_ten() == null) {
                resp.sendRedirect("/auth/login.jsp?error=blocked");
                return;
            }

            // Tài khoản hợp lệ -> Phân quyền dựa trên cột vai_tro trong Database
            session.setAttribute("userLogged", nv);
            session.setAttribute("username", taiKhoan);

            if ("Quản lý".equals(nv.getVai_tro())) {
                session.setAttribute("role", "ADMIN");
                resp.sendRedirect("/nhan-vien/hien-thi");
            } else {
                session.setAttribute("role", "STAFF");
                resp.sendRedirect("/pages/giao-dien-nhan-vien.jsp");
            }
            return; // Kết thúc xử lý thành công
        }

        // Bước 2: Nếu không phải nhân viên, tự động quét sang bảng Khách hàng
        KhachHang kh = loginRepository.checkLoginKhachHang(taiKhoan, matKhau);
        if (kh != null) {
            if ("BLOCKED".equals(kh.getId())) {
                resp.sendRedirect("/auth/login.jsp?error=blocked");
                return;
            }

            session.setAttribute("userLogged", kh);
            session.setAttribute("username", taiKhoan);
            session.setAttribute("role", "USER");
            resp.sendRedirect("/pages/giao-dien-khach.jsp");
            return;
        }

        // Bước 3: Hoàn toàn không tìm thấy thông tin khớp ở cả 2 bảng
        resp.sendRedirect("/auth/login.jsp?error=invalid");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        resp.sendRedirect("/auth/login.jsp?message=logout");
    }
}