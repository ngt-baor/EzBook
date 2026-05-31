package com.example.ezbook.repository;

import com.example.ezbook.entity.KhachHang;
import com.example.ezbook.util.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class KhachHangRepository {
    private Connection connection = null;

    public KhachHangRepository() {
        connection = DBConnect.getConnection();
    }

    public List<KhachHang> getAll() {
        String sql = "SELECT * FROM KhachHang";
        List<KhachHang> danhSach = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                danhSach.add(new KhachHang(
                        rs.getString("id"),
                        rs.getString("ho_ten"),
                        rs.getString("sdt"),
                        rs.getString("ngay_sinh")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    public void them(KhachHang kh) {
        String sql = "INSERT INTO KhachHang (id, ho_ten, sdt, ngay_sinh) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, kh.getId());
            ps.setString(2, kh.getHo_ten());
            ps.setString(3, kh.getSdt());
            ps.setString(4, kh.getNgay_sinh());
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public KhachHang findById(String id) {
        String sql = "SELECT * FROM KhachHang WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new KhachHang(
                        rs.getString("id"),
                        rs.getString("ho_ten"),
                        rs.getString("sdt"),
                        rs.getString("ngay_sinh")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public KhachHang findBySdt(String sdt) {
        String sql = "SELECT * FROM KhachHang WHERE sdt = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, sdt);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new KhachHang(
                        rs.getString("id"),
                        rs.getString("ho_ten"),
                        rs.getString("sdt"),
                        rs.getString("ngay_sinh")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String taoKhachHangOnline(String hoTen, String sdt) {
        String id = "KH" + System.currentTimeMillis();
        String sql = "INSERT INTO KhachHang (id, ho_ten, sdt, ngay_sinh) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ps.setString(2, hoTen);
            ps.setString(3, sdt);
            ps.setNull(4, Types.DATE);
            int row = ps.executeUpdate();
            if (row > 0) {
                return id;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void update(KhachHang kh) {
        String sql = "UPDATE KhachHang SET ho_ten = ?, sdt = ?, ngay_sinh = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, kh.getHo_ten());
            ps.setString(2, kh.getSdt());
            ps.setString(3, kh.getNgay_sinh());
            ps.setString(4, kh.getId());
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void xoa(String id) {
        String sql = "DELETE FROM KhachHang WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
