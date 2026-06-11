package com.example.ezbook.repository;

import com.example.ezbook.entity.AuthUser;
import com.example.ezbook.entity.KhachHang;
import com.example.ezbook.entity.NhanVien;
import com.example.ezbook.util.DBConnect;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Objects;

public class LoginRepository {
    private final Connection connection;

    public LoginRepository() {
        this.connection = Objects.requireNonNull(DBConnect.getConnection(), "DB connection is null");
    }

    public AuthUser checkInternalAuth(String usernameOrSdtOrId, String password) {
        String sql = "SELECT tk.username, tk.vai_tro, tk.trang_thai, nv.ho_ten " +
                "FROM TaiKhoan tk " +
                "JOIN NhanVien nv ON nv.username = tk.username " +
                "WHERE (tk.username = ? OR tk.email = ? OR nv.sdt = ? OR nv.id = ?) AND tk.mat_khau = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, usernameOrSdtOrId);
            ps.setString(2, usernameOrSdtOrId);
            ps.setString(3, usernameOrSdtOrId);
            ps.setString(4, usernameOrSdtOrId);
            ps.setString(5, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                return new AuthUser(
                        rs.getString("username"),
                        rs.getString("ho_ten"),
                        normalizeRole(rs.getString("vai_tro")),
                        rs.getBoolean("trang_thai")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public AuthUser checkCustomerAuth(String usernameOrPhone, String password) {
        String sql = "SELECT tk.username, tk.vai_tro, tk.trang_thai, kh.ho_ten " +
                "FROM TaiKhoan tk " +
                "JOIN KhachHang kh ON kh.username = tk.username " +
                "WHERE (tk.username = ? OR tk.email = ? OR kh.sdt = ?) AND tk.mat_khau = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, usernameOrPhone);
            ps.setString(2, usernameOrPhone);
            ps.setString(3, usernameOrPhone);
            ps.setString(4, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                return new AuthUser(
                        rs.getString("username"),
                        rs.getString("ho_ten"),
                        normalizeRole(rs.getString("vai_tro")),
                        rs.getBoolean("trang_thai")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // Legacy method kept for compatibility with older code paths.
    public NhanVien checkLoginNhanVien(String username, String password) {
        String sql = "SELECT nv.id, nv.ho_ten, nv.sdt, nv.vai_tro, tk.trang_thai " +
                "FROM NhanVien nv " +
                "JOIN TaiKhoan tk ON nv.username = tk.username " +
                "WHERE (nv.id = ? OR nv.sdt = ? OR tk.username = ? OR tk.email = ?) AND tk.mat_khau = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, username);
            ps.setString(3, username);
            ps.setString(4, username);
            ps.setString(5, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new NhanVien(
                            rs.getString("id"),
                            rs.getString("ho_ten"),
                            rs.getString("sdt"),
                            rs.getString("vai_tro"),
                            rs.getBoolean("trang_thai"),
                            null
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Legacy method kept for compatibility with older code paths.
    public KhachHang checkLoginKhachHang(String username, String password) {
        String sql = "SELECT kh.id, kh.ho_ten, kh.sdt, kh.ngay_sinh, tk.trang_thai " +
                "FROM KhachHang kh " +
                "JOIN TaiKhoan tk ON kh.username = tk.username " +
                "WHERE (kh.sdt = ? OR tk.username = ? OR tk.email = ?) AND tk.mat_khau = ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, username);
            ps.setString(3, username);
            ps.setString(4, password);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    if (!rs.getBoolean("trang_thai")) {
                        return new KhachHang("BLOCKED", null, null, null);
                    }
                    return new KhachHang(
                            rs.getString("id"),
                            rs.getString("ho_ten"),
                            rs.getString("sdt"),
                            rs.getString("ngay_sinh")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private String normalizeRole(String dbRole) {
        if (dbRole == null) {
            return "";
        }
        return dbRole.trim().toUpperCase();
    }
}
