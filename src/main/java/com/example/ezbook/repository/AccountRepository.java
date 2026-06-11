package com.example.ezbook.repository;

import com.example.ezbook.entity.AccountInfo;
import com.example.ezbook.util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AccountRepository {
    private final Connection connection;

    public AccountRepository() {
        this.connection = DBConnect.getConnection();
    }

    public boolean registerUser(String sdt, String matKhau, String hoTen, String email) {
        String sqlTaiKhoan = "INSERT INTO TaiKhoan (username, mat_khau, vai_tro, trang_thai, email) VALUES (?, ?, 'USER', 1, ?)";
        String sqlKhachHang = "INSERT INTO KhachHang (id, ho_ten, sdt, username) VALUES (?, ?, ?, ?)";

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement psTK = connection.prepareStatement(sqlTaiKhoan)) {
                psTK.setString(1, sdt);
                psTK.setString(2, matKhau);
                psTK.setString(3, email);
                psTK.executeUpdate();
            }

            String idKhachHang = "KH" + System.currentTimeMillis();
            try (PreparedStatement psKH = connection.prepareStatement(sqlKhachHang)) {
                psKH.setString(1, idKhachHang);
                psKH.setString(2, hoTen);
                psKH.setString(3, sdt);
                psKH.setString(4, sdt);
                psKH.executeUpdate();
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ignored) {
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ignored) {
            }
        }
    }

    public boolean registerUser(String sdt, String matKhau, String hoTen) {
        return registerUser(sdt, matKhau, hoTen, null);
    }

    public boolean validatePassword(String username, String matKhauCu) {
        String sql = "SELECT 1 FROM TaiKhoan WHERE username = ? AND mat_khau = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, matKhauCu);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(String username, String matKhauMoi) {
        String sql = "UPDATE TaiKhoan SET mat_khau = ? WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, matKhauMoi);
            ps.setString(2, username);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePasswordByUsernameOrEmail(String usernameOrEmail, String matKhauMoi) {
        String sql = "UPDATE TaiKhoan SET mat_khau = ? WHERE username = ? OR email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, matKhauMoi);
            ps.setString(2, usernameOrEmail);
            ps.setString(3, usernameOrEmail);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean existsByUsername(String username) {
        String sql = "SELECT 1 FROM TaiKhoan WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean existsByUsernameOrEmail(String usernameOrEmail) {
        String sql = "SELECT 1 FROM TaiKhoan WHERE username = ? OR email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, usernameOrEmail);
            ps.setString(2, usernameOrEmail);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT 1 FROM TaiKhoan WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean emailBelongsToAccount(String email, String username) {
        String sql = "SELECT 1 FROM TaiKhoan WHERE email = ? AND username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean emailBelongsToOtherAccount(String email, String username) {
        String sql = "SELECT 1 FROM TaiKhoan WHERE email = ? AND username <> ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return true;
        }
    }

    public boolean saveVerificationCodeByEmail(String email, String code) {
        String sql = "UPDATE TaiKhoan SET ma_xac_nhan = ? WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean verifyCodeByEmail(String email, String code) {
        String sql = "SELECT 1 FROM TaiKhoan WHERE email = ? AND ma_xac_nhan = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, code);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public void clearVerificationCodeByEmail(String email) {
        String sql = "UPDATE TaiKhoan SET ma_xac_nhan = NULL WHERE email = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean updateAvatar(String username, String avatarUrl) {
        String sql = "UPDATE TaiKhoan SET avatar = ? WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, avatarUrl);
            ps.setString(2, username);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateKhachHangProfile(String username, String hoTen, String sdt, String email) {
        String updateTaiKhoan = "UPDATE TaiKhoan SET email = ? WHERE username = ?";
        String updateKhachHang = "UPDATE KhachHang SET ho_ten = ?, sdt = ? WHERE username = ?";
        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps = connection.prepareStatement(updateTaiKhoan)) {
                ps.setString(1, email);
                ps.setString(2, username);
                ps.executeUpdate();
            }

            int updated;
            try (PreparedStatement ps = connection.prepareStatement(updateKhachHang)) {
                ps.setString(1, hoTen);
                ps.setString(2, sdt);
                ps.setString(3, username);
                updated = ps.executeUpdate();
            }

            if (updated <= 0) {
                connection.rollback();
                return false;
            }
            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ignored) {
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ignored) {
            }
        }
    }

    public boolean updateKhachHangProfile(String username, String hoTen, String sdt) {
        return updateKhachHangProfile(username, hoTen, sdt, null);
    }

    public boolean updateNhanVienProfile(String username, String hoTen, String sdt, String email) {
        String updateTaiKhoan = "UPDATE TaiKhoan SET email = ? WHERE username = ?";
        String updateNhanVien = "UPDATE NhanVien SET ho_ten = ?, sdt = ? WHERE username = ?";
        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps = connection.prepareStatement(updateTaiKhoan)) {
                ps.setString(1, email);
                ps.setString(2, username);
                ps.executeUpdate();
            }

            int updated;
            try (PreparedStatement ps = connection.prepareStatement(updateNhanVien)) {
                ps.setString(1, hoTen);
                ps.setString(2, sdt);
                ps.setString(3, username);
                updated = ps.executeUpdate();
            }

            if (updated <= 0) {
                connection.rollback();
                return false;
            }
            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ignored) {
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ignored) {
            }
        }
    }

    public boolean updateNhanVienProfile(String username, String hoTen, String sdt) {
        return updateNhanVienProfile(username, hoTen, sdt, null);
    }

    public boolean updateAccountStatus(String username, boolean trangThaiMoi) {
        String sql = "UPDATE TaiKhoan SET trang_thai = ? WHERE username = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, trangThaiMoi);
            ps.setString(2, username);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteAccount(String username) {
        String unlinkKhachHang = "UPDATE KhachHang SET username = NULL WHERE username = ?";
        String unlinkNhanVien = "UPDATE NhanVien SET username = NULL WHERE username = ?";
        String deleteTaiKhoan = "DELETE FROM TaiKhoan WHERE username = ?";

        try {
            connection.setAutoCommit(false);

            try (PreparedStatement ps = connection.prepareStatement(unlinkKhachHang)) {
                ps.setString(1, username);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = connection.prepareStatement(unlinkNhanVien)) {
                ps.setString(1, username);
                ps.executeUpdate();
            }

            int deleted;
            try (PreparedStatement ps = connection.prepareStatement(deleteTaiKhoan)) {
                ps.setString(1, username);
                deleted = ps.executeUpdate();
            }

            if (deleted <= 0) {
                connection.rollback();
                return false;
            }

            connection.commit();
            return true;
        } catch (SQLException e) {
            try {
                connection.rollback();
            } catch (SQLException ignored) {
            }
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (SQLException ignored) {
            }
        }
    }

    public AccountInfo findAccountInfo(String username) {
        String sql = "SELECT tk.username, tk.email, tk.vai_tro, tk.trang_thai, " +
                "COALESCE(kh.ho_ten, nv.ho_ten) AS full_name, " +
                "COALESCE(kh.sdt, nv.sdt) AS phone " +
                "FROM TaiKhoan tk " +
                "LEFT JOIN KhachHang kh ON kh.username = tk.username " +
                "LEFT JOIN NhanVien nv ON nv.username = tk.username " +
                "WHERE tk.username = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new AccountInfo(
                            rs.getString("username"),
                            normalizeRole(rs.getString("vai_tro")),
                            rs.getBoolean("trang_thai"),
                            rs.getString("full_name"),
                            rs.getString("phone"),
                            rs.getString("email"),
                            null
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public AccountInfo findAccountDetail(String username) {
        String sql = "SELECT tk.username, tk.email, tk.mat_khau, tk.vai_tro, tk.trang_thai, " +
                "COALESCE(kh.ho_ten, nv.ho_ten) AS full_name, " +
                "COALESCE(kh.sdt, nv.sdt) AS phone " +
                "FROM TaiKhoan tk " +
                "LEFT JOIN KhachHang kh ON kh.username = tk.username " +
                "LEFT JOIN NhanVien nv ON nv.username = tk.username " +
                "WHERE tk.username = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new AccountInfo(
                            rs.getString("username"),
                            normalizeRole(rs.getString("vai_tro")),
                            rs.getBoolean("trang_thai"),
                            rs.getString("full_name"),
                            rs.getString("phone"),
                            rs.getString("email"),
                            rs.getString("mat_khau")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<AccountInfo> getAllAccountInfos() {
        String sql = "SELECT tk.username, tk.email, tk.vai_tro, tk.trang_thai, " +
                "COALESCE(kh.ho_ten, nv.ho_ten) AS full_name, " +
                "COALESCE(kh.sdt, nv.sdt) AS phone " +
                "FROM TaiKhoan tk " +
                "LEFT JOIN KhachHang kh ON kh.username = tk.username " +
                "LEFT JOIN NhanVien nv ON nv.username = tk.username " +
                "ORDER BY tk.vai_tro, tk.username";

        List<AccountInfo> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new AccountInfo(
                        rs.getString("username"),
                        normalizeRole(rs.getString("vai_tro")),
                        rs.getBoolean("trang_thai"),
                        rs.getString("full_name"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        null
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private String normalizeRole(String role) {
        if (role == null) {
            return "";
        }
        return role.trim().toUpperCase();
    }
}
