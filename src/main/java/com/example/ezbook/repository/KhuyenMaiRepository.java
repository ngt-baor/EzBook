package com.example.ezbook.repository;

import com.example.ezbook.entity.KhuyenMai;
import com.example.ezbook.util.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class KhuyenMaiRepository {
    private Connection connection = null;

    public KhuyenMaiRepository() {
        connection = DBConnect.getConnection();
    }

    public List<KhuyenMai> getAll() {
        String sql = "SELECT * FROM KhuyenMai";
        List<KhuyenMai> danhSach = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                danhSach.add(new KhuyenMai(
                        rs.getString("id"),
                        rs.getString("ma_giam_gia"),
                        rs.getString("loai_giam"),
                        rs.getDouble("gia_tri"),
                        rs.getString("ngay_bat_dau"),
                        rs.getString("ngay_ket_thuc"),
                        rs.getInt("so_luong_gioi_han"),
                        rs.getBoolean("trang_thai")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    public void them(KhuyenMai km) {
        String sql = "INSERT INTO KhuyenMai (id, ma_giam_gia, loai_giam, gia_tri, ngay_bat_dau, ngay_ket_thuc, so_luong_gioi_han, trang_thai) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, km.getId());
            ps.setString(2, km.getMa_giam_gia());
            ps.setString(3, km.getLoai_giam());
            ps.setDouble(4, km.getGia_tri());
            ps.setString(5, km.getNgay_bat_dau());
            ps.setString(6, km.getNgay_ket_thuc());
            ps.setInt(7, km.getSo_luong_gioi_han());
            ps.setBoolean(8, km.isTrang_thai());
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public KhuyenMai findById(String id) {
        String sql = "SELECT * FROM KhuyenMai WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new KhuyenMai(
                        rs.getString("id"),
                        rs.getString("ma_giam_gia"),
                        rs.getString("loai_giam"),
                        rs.getDouble("gia_tri"),
                        rs.getString("ngay_bat_dau"),
                        rs.getString("ngay_ket_thuc"),
                        rs.getInt("so_luong_gioi_han"),
                        rs.getBoolean("trang_thai")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void update(KhuyenMai km) {
        String sql = "UPDATE KhuyenMai SET ma_giam_gia = ?, loai_giam = ?, gia_tri = ?, ngay_bat_dau = ?, ngay_ket_thuc = ?, so_luong_gioi_han = ?, trang_thai = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, km.getMa_giam_gia());
            ps.setString(2, km.getLoai_giam());
            ps.setDouble(3, km.getGia_tri());
            ps.setString(4, km.getNgay_bat_dau());
            ps.setString(5, km.getNgay_ket_thuc());
            ps.setInt(6, km.getSo_luong_gioi_han());
            ps.setBoolean(7, km.isTrang_thai());
            ps.setString(8, km.getId());
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void xoa(String id) {
        String sql = "DELETE FROM KhuyenMai WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}