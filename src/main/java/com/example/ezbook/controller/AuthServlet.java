package com.example.ezbook.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "authServlet", value = {"/login", "/logout"})
public class AuthServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Da bo tinh nang dang nhap: moi request login se vao thang trang chinh.
        resp.sendRedirect(req.getContextPath() + "/nhan-vien/hien-thi");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Da bo tinh nang dang xuat/session.
        resp.sendRedirect(req.getContextPath() + "/nhan-vien/hien-thi");
    }
}
