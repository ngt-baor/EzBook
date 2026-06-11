package com.example.ezbook.repository;

import com.example.ezbook.entity.DichVu;
import com.example.ezbook.util.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DichVuRepository {
    private Connection connection = null;

    public DichVuRepository() {
        connection = DBConnect.getConnection();
    }

    public List<DichVu> getAll() {
        String sql = "SELECT * FROM DichVu";
        List<DichVu> danhSach = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                danhSach.add(new DichVu(
                        rs.getString("id"),
                        rs.getString("loai_dich_vu_id"),
                        rs.getString("ten_dich_vu"),
                        rs.getDouble("gia_tien"),
                        rs.getBoolean("trang_thai")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    public List<DichVu> getDangHoatDong() {
        String sql = "SELECT * FROM DichVu WHERE trang_thai = 1 ORDER BY ten_dich_vu ASC";
        List<DichVu> danhSach = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                danhSach.add(new DichVu(
                        rs.getString("id"),
                        rs.getString("loai_dich_vu_id"),
                        rs.getString("ten_dich_vu"),
                        rs.getDouble("gia_tien"),
                        rs.getBoolean("trang_thai")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    public boolean dangHoatDong(String id) {
        String sql = "SELECT trang_thai FROM DichVu WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            return rs.next() && rs.getBoolean("trang_thai");
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean them(DichVu dv) {
        String sql = "INSERT INTO DichVu (id, loai_dich_vu_id, ten_dich_vu, gia_tien, trang_thai) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, dv.getId());
            ps.setString(2, dv.getLoai_dich_vu_id());
            ps.setString(3, dv.getTen_dich_vu());
            ps.setDouble(4, dv.getGia_tien());
            ps.setBoolean(5, dv.isTrang_thai());
            ps.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public DichVu findById(String id) {
        String sql = "SELECT * FROM DichVu WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new DichVu(
                        rs.getString("id"),
                        rs.getString("loai_dich_vu_id"),
                        rs.getString("ten_dich_vu"),
                        rs.getDouble("gia_tien"),
                        rs.getBoolean("trang_thai")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(DichVu dv) {
        String sql = "UPDATE DichVu SET loai_dich_vu_id = ?, ten_dich_vu = ?, gia_tien = ?, trang_thai = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, dv.getLoai_dich_vu_id());
            ps.setString(2, dv.getTen_dich_vu());
            ps.setDouble(3, dv.getGia_tien());
            ps.setBoolean(4, dv.isTrang_thai());
            ps.setString(5, dv.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean xoa(String id) {
        String sql = "DELETE FROM DichVu WHERE id = ?";
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
