package com.example.ezbook.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/staff/*", "/nhan-vien/*"})
public class SecurityFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String role = (session != null) ? (String) session.getAttribute("role") : null;
        String uri = req.getRequestURI();

        // 1. Kiểm tra nếu chưa đăng nhập
        if (role == null) {
            resp.sendRedirect("/auth/login.jsp?error=unauthorized");
            return;
        }

        // 2. Phân quyền Admin
        if (uri.contains("/admin/") && !"ADMIN".equals(role)) {
            resp.sendRedirect("/auth/login.jsp?error=no-access");
            return;
        }

        // 3. Phân quyền Staff (Staff hoặc Admin đều vào được vùng của Staff)
        if (uri.contains("/staff/") && !"STAFF".equals(role) && !"ADMIN".equals(role)) {
            resp.sendRedirect("/auth/login.jsp?error=no-access");
            return;
        }

        // Tài khoản hợp lệ, cho phép đi tiếp
        chain.doFilter(request, response);
    }
}