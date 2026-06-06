package com.example.ezbook.controller;

import com.example.ezbook.entity.AuthUser;
import com.example.ezbook.repository.AccountRepository;
import com.example.ezbook.repository.LoginRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "khachHangAuthServlet", value = {
        "/khach-hang/dang-nhap",
        "/khach-hang/dang-ky",
        "/khach-hang/dang-xuat"
})
public class KhachHangAuthServlet extends HttpServlet {
    private final LoginRepository loginRepository = new LoginRepository();
    private final AccountRepository accountRepository = new AccountRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("/dang-xuat")) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-nhap.jsp?msg=logged-out");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-nhap.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("/dang-ky")) {
            dangKy(req, resp);
            return;
        }
        if (uri.contains("/dang-nhap")) {
            dangNhap(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-nhap.jsp");
    }

    private void dangKy(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String hoTen = trim(req.getParameter("ho_ten"));
        String sdt = trim(req.getParameter("sdt"));
        String matKhau = trim(req.getParameter("mat_khau"));
        String xacNhan = trim(req.getParameter("xac_nhan_mat_khau"));

        if (hoTen == null || sdt == null || matKhau == null || xacNhan == null) {
            resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-ky.jsp?error=missing-data");
            return;
        }
        if (!matKhau.equals(xacNhan)) {
            resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-ky.jsp?error=password-not-match");
            return;
        }

        boolean ok = accountRepository.registerUser(sdt, matKhau, hoTen);
        if (!ok) {
            resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-ky.jsp?error=register-failed");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-nhap.jsp?msg=register-success");
    }

    private void dangNhap(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = trim(req.getParameter("username"));
        String password = trim(req.getParameter("password"));

        if (username == null || password == null) {
            resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-nhap.jsp?error=missing-data");
            return;
        }

        AuthUser authUser = loginRepository.checkCustomerAuth(username, password);
        if (authUser == null) {
            resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-nhap.jsp?error=invalid");
            return;
        }
        if (!authUser.isActive()) {
            resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-nhap.jsp?error=blocked");
            return;
        }
        if (!"USER".equals(authUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-nhap.jsp?error=role-not-allowed");
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("username", authUser.getUsername());
        session.setAttribute("displayName", authUser.getDisplayName());
        session.setAttribute("role", "USER");

        session.setAttribute("customerUsername", authUser.getUsername());
        session.setAttribute("customerName", authUser.getDisplayName());
        session.setAttribute("customerPhone", authUser.getUsername());

        resp.sendRedirect(req.getContextPath() + "/pages/giao-dien-khach.jsp");
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String v = value.trim();
        return v.isEmpty() ? null : v;
    }
}
