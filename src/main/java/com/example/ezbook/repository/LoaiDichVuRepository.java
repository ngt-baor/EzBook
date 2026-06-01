package com.example.ezbook.repository;

import com.example.ezbook.entity.LoaiDichVu;
import com.example.ezbook.util.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LoaiDichVuRepository {
    private Connection connection = null;

    public LoaiDichVuRepository() {
        connection = DBConnect.getConnection();
    }

    public List<LoaiDichVu> getAll() {
        String sql = "SELECT * FROM LoaiDichVu";
        List<LoaiDichVu> danhSach = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                danhSach.add(new LoaiDichVu(
                        rs.getString("id"),
                        rs.getString("ten_loai"),
                        rs.getString("mo_ta")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    public boolean them(LoaiDichVu ldv) {
        String sql = "INSERT INTO LoaiDichVu (id, ten_loai, mo_ta) VALUES (?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, ldv.getId());
            ps.setString(2, ldv.getTen_loai());
            ps.setString(3, ldv.getMo_ta());
            ps.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public LoaiDichVu findById(String id) {
        String sql = "SELECT * FROM LoaiDichVu WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new LoaiDichVu(
                        rs.getString("id"),
                        rs.getString("ten_loai"),
                        rs.getString("mo_ta")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(LoaiDichVu ldv) {
        String sql = "UPDATE LoaiDichVu SET ten_loai = ?, mo_ta = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, ldv.getTen_loai());
            ps.setString(2, ldv.getMo_ta());
            ps.setString(3, ldv.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean xoa(String id) {
        String sql = "DELETE FROM LoaiDichVu WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
