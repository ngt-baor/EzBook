package com.example.ezbook.repository;

import com.example.ezbook.entity.KhachHang;
import com.example.ezbook.entity.NhanVien;
import com.example.ezbook.util.DBConnect;

import java.sql.*;
import java.util.Objects;

public class LoginRepository {
    private final Connection connection;

    public LoginRepository() {
        this.connection = Objects.requireNonNull(DBConnect.getConnection(), "DB connection is null");
    }

    // 1. Kiểm tra tài khoản Nội bộ (Nhân viên hoặc Admin) kèm trạng thái khóa
    public NhanVien checkLoginNhanVien(String username, String password) {
        String sql = "SELECT nv.*, tk.trang_thai FROM NhanVien nv " +
                "JOIN TaiKhoan tk ON nv.username = tk.username " +
                "WHERE (nv.id = ? OR nv.sdt = ? OR tk.username = ?) AND tk.mat_khau = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, username);
            ps.setString(3, username);
            ps.setString(4, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                if (!rs.getBoolean("trang_thai")) {
                    NhanVien blockedStaff = new NhanVien(rs.getString("id"), null, null, null, false, null);
                    return blockedStaff;
                }
                return new NhanVien(
                        rs.getString("id"),
                        rs.getString("ho_ten"),
                        rs.getString("sdt"),
                        rs.getString("vai_tro"),
                        true,
                        rs.getString("mat_khau")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 2. Kiểm tra tài khoản Khách hàng kèm trạng thái khóa
    public KhachHang checkLoginKhachHang(String username, String password) {
        String sql = "SELECT kh.*, tk.trang_thai FROM KhachHang kh " +
                "JOIN TaiKhoan tk ON kh.username = tk.username " +
                "WHERE (kh.sdt = ? OR tk.username = ?) AND tk.mat_khau = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, username);
            ps.setString(3, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String ngaySinhValue = rs.getString("ngay_sinh");
                if (!rs.getBoolean("trang_thai")) {
                    return new KhachHang("BLOCKED", null, null, null);
                }
                return new KhachHang(
                        rs.getString("id"),
                        rs.getString("ho_ten"),
                        rs.getString("sdt"),
                        ngaySinhValue
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
