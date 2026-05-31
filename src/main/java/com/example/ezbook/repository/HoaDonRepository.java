package com.example.ezbook.repository;

import com.example.ezbook.entity.HoaDon;
import com.example.ezbook.util.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HoaDonRepository {
    private Connection connection = null;

    public HoaDonRepository() {
        connection = DBConnect.getConnection();
    }

    public List<HoaDon> getAll() {
        String sql = "SELECT * FROM HoaDon";
        List<HoaDon> danhSach = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                danhSach.add(new HoaDon(
                        rs.getString("id"),
                        rs.getString("booking_id"),
                        rs.getDouble("tong_tien_goc"),
                        rs.getDouble("tien_giam_gia"),
                        rs.getDouble("thanh_tien"),
                        rs.getString("phuong_thuc_thanh_toan"),
                        rs.getString("thoi_gian_thanh_toan"),
                        rs.getString("trang_thai_thanh_toan")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    public void them(HoaDon hd) {
        String sql = "INSERT INTO HoaDon (id, booking_id, tong_tien_goc, tien_giam_gia, thanh_tien, phuong_thuc_thanh_toan, thoi_gian_thanh_toan, trang_thai_thanh_toan) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, hd.getId());
            ps.setString(2, hd.getBooking_id());
            ps.setDouble(3, hd.getTong_tien_goc());
            ps.setDouble(4, hd.getTien_giam_gia());
            ps.setDouble(5, hd.getThanh_tien());
            ps.setString(6, hd.getPhuong_thuc_thanh_toan());
            ps.setString(7, hd.getThoi_gian_thanh_toan());
            ps.setString(8, hd.getTrang_thai_thanh_toan());
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public HoaDon findById(String id) {
        String sql = "SELECT * FROM HoaDon WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new HoaDon(
                        rs.getString("id"),
                        rs.getString("booking_id"),
                        rs.getDouble("tong_tien_goc"),
                        rs.getDouble("tien_giam_gia"),
                        rs.getDouble("thanh_tien"),
                        rs.getString("phuong_thuc_thanh_toan"),
                        rs.getString("thoi_gian_thanh_toan"),
                        rs.getString("trang_thai_thanh_toan")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void update(HoaDon hd) {
        String sql = "UPDATE HoaDon SET booking_id = ?, tong_tien_goc = ?, tien_giam_gia = ?, thanh_tien = ?, phuong_thuc_thanh_toan = ?, thoi_gian_thanh_toan = ?, trang_thai_thanh_toan = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, hd.getBooking_id());
            ps.setDouble(2, hd.getTong_tien_goc());
            ps.setDouble(3, hd.getTien_giam_gia());
            ps.setDouble(4, hd.getThanh_tien());
            ps.setString(5, hd.getPhuong_thuc_thanh_toan());
            ps.setString(6, hd.getThoi_gian_thanh_toan());
            ps.setString(7, hd.getTrang_thai_thanh_toan());
            ps.setString(8, hd.getId());
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void xoa(String id) {
        String sql = "DELETE FROM HoaDon WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}