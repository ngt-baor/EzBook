package com.example.ezbook.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(urlPatterns = {"/*"})
public class SecurityFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        String role = session == null ? null : (String) session.getAttribute("role");

        if (requiresCustomer(path)) {
            if (isBlank(role)) {
                resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-nhap.jsp?error=login-required");
                return;
            }
            if (!"USER".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-nhap.jsp?error=forbidden");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        if (requiresAdmin(path)) {
            if (isBlank(role)) {
                resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=login-required");
                return;
            }
            if (!"ADMIN".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=forbidden");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        if (requiresStaffOrAdmin(path)) {
            if (isBlank(role)) {
                resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=login-required");
                return;
            }
            if (!"ADMIN".equals(role) && !"STAFF".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=forbidden");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        if (path.startsWith("/account/")) {
            if (isBlank(role)) {
                resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=login-required");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        return path.equals("/")
                || path.equals("/index.jsp")
                || path.equals("/auth/login.jsp")
                || path.equals("/auth/forgot-password.jsp")
                || path.equals("/login")
                || path.equals("/logout")
                || path.equals("/khach-hang/dang-nhap.jsp")
                || path.equals("/khach-hang/dang-ky.jsp")
                || path.equals("/khach-hang/dang-nhap")
                || path.equals("/khach-hang/dang-ky")
                || path.equals("/khach-hang/dang-xuat")
                || path.equals("/account/dang-ky")
                || path.equals("/account/quen-mat-khau")
                || path.startsWith("/uploads/");
    }

    private boolean requiresAdmin(String path) {
        return path.startsWith("/nhan-vien/")
                || path.startsWith("/admin/");
    }

    private boolean requiresStaffOrAdmin(String path) {
        return path.startsWith("/booking/")
                || path.startsWith("/hoa-don/")
                || path.startsWith("/thong-ke/")
                || path.equals("/pages/giao-dien-nhan-vien.jsp");
    }

    private boolean requiresCustomer(String path) {
        return path.startsWith("/khach-hang/booking-online")
                || path.equals("/pages/giao-dien-khach.jsp");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
