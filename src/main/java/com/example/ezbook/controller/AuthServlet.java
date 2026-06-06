package com.example.ezbook.controller;

import com.example.ezbook.entity.AuthUser;
import com.example.ezbook.repository.LoginRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "authServlet", value = {"/login", "/logout"})
public class AuthServlet extends HttpServlet {
    private final LoginRepository loginRepository = new LoginRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.endsWith("/logout")) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?msg=logged-out");
            return;
        }

        HttpSession session = req.getSession(false);
        String role = session == null ? null : (String) session.getAttribute("role");
        if (role != null && !role.trim().isEmpty()) {
            redirectByRole(req, resp, role);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = trim(req.getParameter("username"));
        String password = trim(req.getParameter("password"));

        if (username == null || password == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=missing-data");
            return;
        }

        AuthUser authUser = loginRepository.checkInternalAuth(username, password);
        if (authUser == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=invalid");
            return;
        }

        if (!authUser.isActive()) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=blocked");
            return;
        }

        String role = authUser.getRole();
        if (!"ADMIN".equals(role) && !"STAFF".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=role-not-allowed");
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("username", authUser.getUsername());
        session.setAttribute("displayName", authUser.getDisplayName());
        session.setAttribute("role", role);

        redirectByRole(req, resp, role);
    }

    private void redirectByRole(HttpServletRequest req, HttpServletResponse resp, String role) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/pages/giao-dien-nhan-vien.jsp");
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String v = value.trim();
        return v.isEmpty() ? null : v;
    }
}
