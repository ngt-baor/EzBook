package com.example.ezbook.controller;

import com.example.ezbook.repository.AccountRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "accountServlet", value = {
        "/account/dang-ky",
        "/account/quen-mat-khau",
        "/account/doi-mat-khau",
        "/account/cap-nhat-ho-so",
        "/account/upload-avatar",
        "/admin/quan-ly-tai-khoan/trang-thai"
})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class AccountServlet extends HttpServlet {
    private AccountRepository accountRepo = new AccountRepository();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();

        if (uri.contains("dang-ky")) {
            xuLyDangKy(req, resp);
        } else if (uri.contains("quen-mat-khau")) {
            xuLyQuenMatKhau(req, resp);
        } else if (uri.contains("doi-mat-khau")) {
            xuLyDoiMatKhau(req, resp);
        } else if (uri.contains("cap-nhat-ho-so")) {
            xuLyCapNhatHoSo(req, resp);
        } else if (uri.contains("upload-avatar")) {
            xuLyUploadAvatar(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.contains("trang-thai")) {
            xuLyKhoaMoTaiKhoan(req, resp);
        }
    }

    // =========================================================================
    // 1. ĐĂNG KÝ (Mặc định vai trò USER - Khách hàng)
    // =========================================================================
    private void xuLyDangKy(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String sdt = req.getParameter("sdt");
        String hoTen = req.getParameter("ho_ten");
        String matKhau = req.getParameter("mat_khau");

        // Gọi Repository tạo đồng thời bản ghi ở bảng TaiKhoan và KhachHang
        boolean thanhCong = accountRepo.registerUser(sdt, matKhau, hoTen);
        if (thanhCong) {
            resp.sendRedirect("/auth/login.jsp?msg=register-success");
        } else {
            resp.sendRedirect("/auth/register.jsp?error=exist");
        }
    }

    // =========================================================================
    // 2. ĐỔI MẬT KHẨU (Khi đã đăng nhập)
    // =========================================================================
    private void xuLyDoiMatKhau(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        String username = req.getParameter("username");
        if ((username == null || username.trim().isEmpty()) && session != null) {
            username = (String) session.getAttribute("username");
        }
        if (username == null || username.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing username");
            return;
        }
        String mkCu = req.getParameter("mat_khau_cu");
        String mkMoi = req.getParameter("mat_khau_moi");

        if (accountRepo.validatePassword(username, mkCu)) {
            accountRepo.updatePassword(username, mkMoi);
            resp.sendRedirect("/account/profile.jsp?msg=change-pass-success");
        } else {
            resp.sendRedirect("/account/profile.jsp?error=wrong-old-pass");
        }
    }

    // =========================================================================
    // 3. QUÊN MẬT KHẨU
    // =========================================================================
    private void xuLyQuenMatKhau(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String username = req.getParameter("username");
        String usernameSafe = username == null ? "" : username.trim();
        String mkMoi = req.getParameter("mat_khau_moi");
        String mkMoiConfirm = req.getParameter("mat_khau_moi_xac_nhan");

        if (usernameSafe.isEmpty()) {
            resp.sendRedirect("/auth/forgot-password.jsp?error=missing-username");
            return;
        }
        if (mkMoi == null || mkMoi.trim().isEmpty() || mkMoiConfirm == null || mkMoiConfirm.trim().isEmpty()) {
            resp.sendRedirect("/auth/forgot-password.jsp?error=missing-data");
            return;
        }
        if (!mkMoi.equals(mkMoiConfirm)) {
            resp.sendRedirect("/auth/forgot-password.jsp?error=password-not-match");
            return;
        }
        if (!accountRepo.existsByUsername(usernameSafe)) {
            resp.sendRedirect("/auth/forgot-password.jsp?error=username-not-found");
            return;
        }

        accountRepo.updatePassword(usernameSafe, mkMoi);
        resp.sendRedirect("/auth/login.jsp?msg=reset-success");
    }

    // =========================================================================
    // 4. UPLOAD AVATAR
    // =========================================================================
    private void xuLyUploadAvatar(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String username = req.getParameter("username");
        if ((username == null || username.trim().isEmpty()) && session != null) {
            username = (String) session.getAttribute("username");
        }
        if (username == null || username.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing username");
            return;
        }

        // Đường dẫn đến thư mục chứa ảnh trong project
        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        Part part = req.getPart("fileAvatar");
        String fileName = UUID.randomUUID().toString() + "_" + getFileName(part);
        part.write(uploadPath + File.separator + fileName);

        // Lưu đường dẫn tương đối vào DB
        String avatarUrl = "/uploads/" + fileName;
        accountRepo.updateAvatar(username, avatarUrl);

        // Cập nhật lại ảnh hiển thị trong Session hiện tại
        if (session != null) {
            session.setAttribute("avatar", avatarUrl);
        }
        resp.sendRedirect("/account/profile.jsp?msg=upload-success");
    }

    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "default.png";
    }

    // =========================================================================
    // 5. CẬP NHẬT HỒ SƠ CÁ NHÂN
    // =========================================================================
    private void xuLyCapNhatHoSo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        String username = req.getParameter("username");
        if ((username == null || username.trim().isEmpty()) && session != null) {
            username = (String) session.getAttribute("username");
        }
        if (username == null || username.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing username");
            return;
        }
        String role = req.getParameter("role");
        if ((role == null || role.trim().isEmpty()) && session != null) {
            role = (String) session.getAttribute("role");
        }
        String hoTen = req.getParameter("ho_ten");
        String sdt = req.getParameter("sdt");

        if ("USER".equals(role)) {
            accountRepo.updateKhachHangProfile(username, hoTen, sdt);
        } else {
            accountRepo.updateNhanVienProfile(username, hoTen, sdt);
        }
        resp.sendRedirect("/account/profile.jsp?msg=update-profile-success");
    }

    // =========================================================================
    // 6. KHÓA / MỞ KHÓA TÀI KHOẢN (Chỉ Admin)
    // =========================================================================
    private void xuLyKhoaMoTaiKhoan(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String targetUsername = req.getParameter("username");
        boolean trangThaiHienTai = Boolean.parseBoolean(req.getParameter("currentStatus"));

        // Đảo ngược trạng thái hiện tại (1 thành 0, 0 thành 1)
        accountRepo.updateAccountStatus(targetUsername, !trangThaiHienTai);

        resp.sendRedirect("/admin/quan-ly-tai-khoan.jsp?msg=status-updated");
    }
}
