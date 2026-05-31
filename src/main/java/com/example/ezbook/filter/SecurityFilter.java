package com.example.ezbook.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/staff/*", "/nhan-vien/*"})
public class SecurityFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // Da tat toan bo co che dang nhap/phan quyen: cho phep di qua tat ca request.
        chain.doFilter(request, response);
    }
}
