package com.example.ezbook.repository;

import com.example.ezbook.entity.Booking;
import com.example.ezbook.util.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingRepository {
    private Connection connection = null;

    public BookingRepository() {
        connection = DBConnect.getConnection();
    }

    public List<Booking> getAll() {
        String sql = "SELECT * FROM Booking";
        List<Booking> danhSach = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                danhSach.add(new Booking(
                        rs.getString("id"),
                        rs.getString("khach_hang_id"),
                        rs.getString("nhan_vien_id"),
                        rs.getString("dich_vu_id"),
                        rs.getString("khuyen_mai_id"),
                        rs.getString("thoi_gian_hen"),
                        rs.getString("trang_thai_booking"),
                        rs.getString("ghi_chu_khach_hang")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    public void them(Booking bk) {
        String sql = "INSERT INTO Booking (id, khach_hang_id, nhan_vien_id, dich_vu_id, khuyen_mai_id, thoi_gian_hen, trang_thai_booking, ghi_chu_khach_hang) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, bk.getId());
            ps.setString(2, bk.getKhach_hang_id());
            ps.setString(3, bk.getNhan_vien_id());
            ps.setString(4, bk.getDich_vu_id());
            ps.setString(5, bk.getKhuyen_mai_id());
            ps.setString(6, bk.getThoi_gian_hen());
            ps.setString(7, bk.getTrang_thai_booking());
            ps.setString(8, bk.getGhi_chu_khach_hang());
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Booking findById(String id) {
        String sql = "SELECT * FROM Booking WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Booking(
                        rs.getString("id"),
                        rs.getString("khach_hang_id"),
                        rs.getString("nhan_vien_id"),
                        rs.getString("dich_vu_id"),
                        rs.getString("khuyen_mai_id"),
                        rs.getString("thoi_gian_hen"),
                        rs.getString("trang_thai_booking"),
                        rs.getString("ghi_chu_khach_hang")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void update(Booking bk) {
        String sql = "UPDATE Booking SET khach_hang_id = ?, nhan_vien_id = ?, dich_vu_id = ?, khuyen_mai_id = ?, thoi_gian_hen = ?, trang_thai_booking = ?, ghi_chu_khach_hang = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, bk.getKhach_hang_id());
            ps.setString(2, bk.getNhan_vien_id());
            ps.setString(3, bk.getDich_vu_id());
            ps.setString(4, bk.getKhuyen_mai_id());
            ps.setString(5, bk.getThoi_gian_hen());
            ps.setString(6, bk.getTrang_thai_booking());
            ps.setString(7, bk.getGhi_chu_khach_hang());
            ps.setString(8, bk.getId());
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void xoa(String id) {
        String sql = "DELETE FROM Booking WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}