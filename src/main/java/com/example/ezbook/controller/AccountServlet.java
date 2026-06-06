package com.example.ezbook.controller;

import com.example.ezbook.entity.AccountInfo;
import com.example.ezbook.repository.AccountRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "accountServlet", value = {
        "/account/dang-ky",
        "/account/quen-mat-khau",
        "/account/doi-mat-khau",
        "/account/cap-nhat-ho-so",
        "/account/upload-avatar",
        "/account/ho-so",
        "/admin/quan-ly-tai-khoan",
        "/admin/quan-ly-tai-khoan/detail",
        "/admin/quan-ly-tai-khoan/trang-thai",
        "/admin/quan-ly-tai-khoan/xoa"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AccountServlet extends HttpServlet {
    private final AccountRepository accountRepo = new AccountRepository();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("/account/ho-so")) {
            hienThiHoSo(req, resp);
            return;
        }
        if (uri.contains("/admin/quan-ly-tai-khoan/trang-thai")) {
            xuLyKhoaMoTaiKhoan(req, resp);
            return;
        }
        if (uri.contains("/admin/quan-ly-tai-khoan/detail")) {
            hienThiChiTietTaiKhoan(req, resp);
            return;
        }
        if (uri.contains("/admin/quan-ly-tai-khoan")) {
            hienThiQuanLyTaiKhoan(req, resp);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.contains("dang-ky")) {
            xuLyDangKy(req, resp);
            return;
        }
        if (uri.contains("quen-mat-khau")) {
            xuLyQuenMatKhau(req, resp);
            return;
        }
        if (uri.contains("doi-mat-khau")) {
            xuLyDoiMatKhau(req, resp);
            return;
        }
        if (uri.contains("cap-nhat-ho-so")) {
            xuLyCapNhatHoSo(req, resp);
            return;
        }
        if (uri.contains("upload-avatar")) {
            xuLyUploadAvatar(req, resp);
            return;
        }
        if (uri.contains("/admin/quan-ly-tai-khoan/trang-thai")) {
            xuLyKhoaMoTaiKhoan(req, resp);
            return;
        }
        if (uri.contains("/admin/quan-ly-tai-khoan/xoa")) {
            xuLyXoaTaiKhoan(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/auth/login.jsp");
    }

    private void xuLyDangKy(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String sdt = trim(req.getParameter("sdt"));
        String hoTen = trim(req.getParameter("ho_ten"));
        String matKhau = trim(req.getParameter("mat_khau"));

        if (sdt == null || hoTen == null || matKhau == null) {
            resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-ky.jsp?error=missing-data");
            return;
        }

        boolean thanhCong = accountRepo.registerUser(sdt, matKhau, hoTen);
        if (thanhCong) {
            resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-nhap.jsp?msg=register-success");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/khach-hang/dang-ky.jsp?error=register-failed");
    }

    private void xuLyQuenMatKhau(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = trim(req.getParameter("username"));
        String mkMoi = trim(req.getParameter("mat_khau_moi"));
        String mkMoiConfirm = trim(req.getParameter("mat_khau_moi_xac_nhan"));

        if (username == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password.jsp?error=missing-username");
            return;
        }
        if (mkMoi == null || mkMoiConfirm == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password.jsp?error=missing-data");
            return;
        }
        if (!mkMoi.equals(mkMoiConfirm)) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password.jsp?error=password-not-match");
            return;
        }
        if (!accountRepo.existsByUsername(username)) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password.jsp?error=username-not-found");
            return;
        }

        boolean ok = accountRepo.updatePassword(username, mkMoi);
        if (!ok) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password.jsp?error=system");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?msg=reset-success");
    }

    private void xuLyDoiMatKhau(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        String username = resolveUsername(req, session);
        if (username == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=login-required");
            return;
        }

        String mkCu = trim(req.getParameter("mat_khau_cu"));
        String mkMoi = trim(req.getParameter("mat_khau_moi"));
        String mkMoiXacNhan = trim(req.getParameter("mat_khau_moi_xac_nhan"));

        if (mkCu == null || mkMoi == null || mkMoiXacNhan == null) {
            resp.sendRedirect(req.getContextPath() + "/account/ho-so?error=missing-data");
            return;
        }
        if (!mkMoi.equals(mkMoiXacNhan)) {
            resp.sendRedirect(req.getContextPath() + "/account/ho-so?error=password-not-match");
            return;
        }

        if (!accountRepo.validatePassword(username, mkCu)) {
            resp.sendRedirect(req.getContextPath() + "/account/ho-so?error=wrong-old-pass");
            return;
        }

        boolean ok = accountRepo.updatePassword(username, mkMoi);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/account/ho-so?msg=change-pass-success");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/account/ho-so?error=change-pass-failed");
    }

    private void xuLyUploadAvatar(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String username = resolveUsername(req, session);
        if (username == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=login-required");
            return;
        }

        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }

        Part part = req.getPart("fileAvatar");
        String fileName = UUID.randomUUID() + "_" + getFileName(part);
        part.write(uploadPath + File.separator + fileName);

        String avatarUrl = "/uploads/" + fileName;
        boolean ok = accountRepo.updateAvatar(username, avatarUrl);

        if (ok && session != null) {
            session.setAttribute("avatar", avatarUrl);
        }

        resp.sendRedirect(req.getContextPath() + "/account/ho-so" + (ok ? "?msg=upload-success" : "?error=upload-failed"));
    }

    private void xuLyCapNhatHoSo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        String username = resolveUsername(req, session);
        if (username == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=login-required");
            return;
        }

        String role = session == null ? null : (String) session.getAttribute("role");
        String hoTen = trim(req.getParameter("ho_ten"));
        String sdt = trim(req.getParameter("sdt"));

        if (hoTen == null || sdt == null) {
            resp.sendRedirect(req.getContextPath() + "/account/ho-so?error=missing-data");
            return;
        }

        boolean ok;
        if ("USER".equals(role)) {
            ok = accountRepo.updateKhachHangProfile(username, hoTen, sdt);
            if (ok) {
                session.setAttribute("customerName", hoTen);
                session.setAttribute("customerPhone", sdt);
            }
        } else {
            ok = accountRepo.updateNhanVienProfile(username, hoTen, sdt);
        }

        if (ok) {
            session.setAttribute("displayName", hoTen);
            resp.sendRedirect(req.getContextPath() + "/account/ho-so?msg=update-profile-success");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/account/ho-so?error=update-profile-failed");
    }

    private void hienThiHoSo(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String username = session == null ? null : (String) session.getAttribute("username");
        if (username == null || username.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=login-required");
            return;
        }

        AccountInfo accountInfo = accountRepo.findAccountInfo(username);
        req.setAttribute("accountInfo", accountInfo);
        req.getRequestDispatcher("/account/profile.jsp").forward(req, resp);
    }

    private void hienThiQuanLyTaiKhoan(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<AccountInfo> accounts = accountRepo.getAllAccountInfos();
        req.setAttribute("accounts", accounts);
        req.getRequestDispatcher("/admin/quan-ly-tai-khoan.jsp").forward(req, resp);
    }

    private void hienThiChiTietTaiKhoan(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = trim(req.getParameter("username"));
        if (username == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/quan-ly-tai-khoan?error=missing-user");
            return;
        }

        AccountInfo detailAccount = accountRepo.findAccountDetail(username);
        if (detailAccount == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/quan-ly-tai-khoan?error=account-not-found");
            return;
        }

        List<AccountInfo> accounts = accountRepo.getAllAccountInfos();
        req.setAttribute("accounts", accounts);
        req.setAttribute("detailAccount", detailAccount);
        req.getRequestDispatcher("/admin/quan-ly-tai-khoan.jsp").forward(req, resp);
    }

    private void xuLyKhoaMoTaiKhoan(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        String currentRole = session == null ? null : (String) session.getAttribute("role");
        if (!"ADMIN".equals(currentRole)) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=forbidden");
            return;
        }

        String targetUsername = trim(req.getParameter("username"));
        boolean currentStatus = Boolean.parseBoolean(req.getParameter("currentStatus"));
        String currentUsername = (String) session.getAttribute("username");

        if (targetUsername == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/quan-ly-tai-khoan?error=missing-user");
            return;
        }

        if (targetUsername.equals(currentUsername) && currentStatus) {
            resp.sendRedirect(req.getContextPath() + "/admin/quan-ly-tai-khoan?error=cannot-lock-self");
            return;
        }

        boolean ok = accountRepo.updateAccountStatus(targetUsername, !currentStatus);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/admin/quan-ly-tai-khoan?msg=status-updated");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quan-ly-tai-khoan?error=status-update-failed");
    }

    private void xuLyXoaTaiKhoan(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        String currentRole = session == null ? null : (String) session.getAttribute("role");
        if (!"ADMIN".equals(currentRole)) {
            resp.sendRedirect(req.getContextPath() + "/auth/login.jsp?error=forbidden");
            return;
        }

        String targetUsername = trim(req.getParameter("username"));
        String currentUsername = (String) session.getAttribute("username");

        if (targetUsername == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/quan-ly-tai-khoan?error=missing-user");
            return;
        }

        if (targetUsername.equals(currentUsername)) {
            resp.sendRedirect(req.getContextPath() + "/admin/quan-ly-tai-khoan?error=cannot-delete-self");
            return;
        }

        boolean ok = accountRepo.deleteAccount(targetUsername);
        if (ok) {
            resp.sendRedirect(req.getContextPath() + "/admin/quan-ly-tai-khoan?msg=account-deleted");
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/admin/quan-ly-tai-khoan?error=delete-account-failed");
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "default.png";
    }

    private String resolveUsername(HttpServletRequest req, HttpSession session) {
        String username = trim(req.getParameter("username"));
        if (username == null && session != null) {
            username = trim((String) session.getAttribute("username"));
        }
        return username;
    }

    private String trim(String value) {
        if (value == null) {
            return null;
        }
        String v = value.trim();
        return v.isEmpty() ? null : v;
    }
}
