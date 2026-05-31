package com.example.ezbook.repository;

import com.example.ezbook.util.DBConnect;
import java.sql.*;

public class AccountRepository {
    private Connection connection = null;

    public AccountRepository() {
        connection = DBConnect.getConnection();
    }

    // =========================================================================
    // 1. ĐĂNG KÝ TÀI KHOẢN (Mặc định vai trò 'USER' cho khách hàng)
    // =========================================================================
    public boolean registerUser(String sdt, String matKhau, String hoTen) {
        String sqlTaiKhoan = "INSERT INTO TaiKhoan (username, mat_khau, vai_tro, trang_thai) VALUES (?, ?, 'USER', 1)";
        String sqlKhachHang = "INSERT INTO KhachHang (id, ho_ten, sdt, username) VALUES (?, ?, ?, ?)";

        try {
            // Tắt tự động commit để chạy giao dịch (Transaction) song song cả 2 bảng
            connection.setAutoCommit(false);

            // Bước A: Thêm vào bảng TaiKhoan
            PreparedStatement psTK = connection.prepareStatement(sqlTaiKhoan);
            psTK.setString(1, sdt);
            psTK.setString(2, matKhau);
            psTK.executeUpdate();

            // Bước B: Thêm vào bảng KhachHang (Tự sinh mã ID ngẫu nhiên KH + chuỗi số)
            String idKhachHang = "KH" + (int)((Math.random() * 90000) + 10000);
            PreparedStatement psKH = connection.prepareStatement(sqlKhachHang);
            psKH.setString(1, idKhachHang);
            psKH.setString(2, hoTen);
            psKH.setString(3, sdt);
            psKH.setString(4, sdt); // username liên kết chính là sdt
            psKH.executeUpdate();

            // Hoàn tất mọi lệnh thành công thì commit dữ liệu xuống DB
            connection.commit();
            connection.setAutoCommit(true);
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback(); // Có lỗi xảy ra, hủy bỏ toàn bộ tiến trình
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
        }
        return false;
    }

    // =========================================================================
    // 2. XÁC THỰC MẬT KHẨU CŨ (Để phục vụ Đổi mật khẩu)
    // =========================================================================
    public boolean validatePassword(String username, String matKhauCu) {
        String sql = "SELECT * FROM TaiKhoan WHERE username = ? AND mat_khau = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, matKhauCu);
            ResultSet rs = ps.executeQuery();
            return rs.next(); // Trả về true nếu khớp thông tin
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================================================================
    // 3. CẬP NHẬT MẬT KHẨU MỚI (Dùng cho cả Đổi và Reset mật khẩu)
    // =========================================================================
    public void updatePassword(String username, String matKhauMoi) {
        String sql = "UPDATE TaiKhoan SET mat_khau = ? WHERE username = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, matKhauMoi);
            ps.setString(2, username);
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =========================================================================
    // 4. QUÊN MẬT KHẨU: KIỂM TRA TÀI KHOẢN TỒN TẠI
    // =========================================================================
    public boolean existsByUsername(String username) {
        String sql = "SELECT 1 FROM TaiKhoan WHERE username = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // =========================================================================
    // 5. CẬP NHẬT ĐƯỜNG DẪN ẢNH ĐẠI DIỆN (AVATAR)
    // =========================================================================
    public void updateAvatar(String username, String avatarUrl) {
        String sql = "UPDATE TaiKhoan SET avatar = ? WHERE username = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, avatarUrl);
            ps.setString(2, username);
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =========================================================================
    // 6. CẬP NHẬT HỒ SƠ KHÁCH HÀNG (USER)
    // =========================================================================
    public void updateKhachHangProfile(String username, String hoTen, String sdt) {
        String sql = "UPDATE KhachHang SET ho_ten = ?, sdt = ? WHERE username = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, hoTen);
            ps.setString(2, sdt);
            ps.setString(3, username);
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // CẬP NHẬT HỒ SƠ NHÂN VIÊN / ADMIN (STAFF/ADMIN)
    public void updateNhanVienProfile(String username, String hoTen, String sdt) {
        String sql = "UPDATE NhanVien SET ho_ten = ?, sdt = ? WHERE username = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, hoTen);
            ps.setString(2, sdt);
            ps.setString(3, username);
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =========================================================================
    // 7. KHÓA / MỞ KHÓA TÀI KHOẢN (Thay đổi trạng thái)
    // =========================================================================
    public void updateAccountStatus(String username, boolean trangThaiMoi) {
        String sql = "UPDATE TaiKhoan SET trang_thai = ? WHERE username = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setBoolean(1, trangThaiMoi);
            ps.setString(2, username);
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}