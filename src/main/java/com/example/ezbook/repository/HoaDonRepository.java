package com.example.ezbook.repository;

import com.example.ezbook.entity.HoaDon;
import com.example.ezbook.entity.MonthlyRevenue;
import com.example.ezbook.util.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    public boolean them(HoaDon hd) {
        String sql = "INSERT INTO HoaDon (id, booking_id, tong_tien_goc, tien_giam_gia, thanh_tien, phuong_thuc_thanh_toan, thoi_gian_thanh_toan, trang_thai_thanh_toan) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, hd.getId());
            ps.setString(2, hd.getBooking_id());
            ps.setDouble(3, hd.getTong_tien_goc());
            ps.setDouble(4, hd.getTien_giam_gia());
            ps.setDouble(5, hd.getThanh_tien());
            ps.setString(6, hd.getPhuong_thuc_thanh_toan());
            bindPaymentTime(ps, 7, hd.getThoi_gian_thanh_toan());
            ps.setString(8, hd.getTrang_thai_thanh_toan());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
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

    public boolean update(HoaDon hd) {
        String sql = "UPDATE HoaDon SET booking_id = ?, tong_tien_goc = ?, tien_giam_gia = ?, thanh_tien = ?, phuong_thuc_thanh_toan = ?, thoi_gian_thanh_toan = ?, trang_thai_thanh_toan = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, hd.getBooking_id());
            ps.setDouble(2, hd.getTong_tien_goc());
            ps.setDouble(3, hd.getTien_giam_gia());
            ps.setDouble(4, hd.getThanh_tien());
            ps.setString(5, hd.getPhuong_thuc_thanh_toan());
            bindPaymentTime(ps, 6, hd.getThoi_gian_thanh_toan());
            ps.setString(7, hd.getTrang_thai_thanh_toan());
            ps.setString(8, hd.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean xoa(String id) {
        String sql = "DELETE FROM HoaDon WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<MonthlyRevenue> thongKeDoanhThuTheoThang(int year) {
        String sql = "SELECT MONTH(thoi_gian_thanh_toan) AS thang, SUM(thanh_tien) AS doanh_thu " +
                "FROM HoaDon " +
                "WHERE thoi_gian_thanh_toan IS NOT NULL " +
                "AND YEAR(thoi_gian_thanh_toan) = ? " +
                "GROUP BY MONTH(thoi_gian_thanh_toan)";

        Map<Integer, Double> monthRevenueMap = new HashMap<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, year);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                monthRevenueMap.put(rs.getInt("thang"), rs.getDouble("doanh_thu"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        List<MonthlyRevenue> result = new ArrayList<>();
        for (int month = 1; month <= 12; month++) {
            result.add(new MonthlyRevenue(month, monthRevenueMap.getOrDefault(month, 0.0)));
        }
        return result;
    }

    public boolean taoHoaDonChoBookingHoanThanh(String bookingId) {
        if (isBlank(bookingId)) {
            return false;
        }
        if (existsByBookingId(bookingId)) {
            return true;
        }

        String sqlGia = "SELECT dv.gia_tien FROM Booking b " +
                "JOIN DichVu dv ON b.dich_vu_id = dv.id WHERE b.id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sqlGia)) {
            ps.setString(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }
                double tongTienGoc = rs.getDouble("gia_tien");
                HoaDon autoBill = new HoaDon(
                        generateHoaDonId(),
                        bookingId,
                        tongTienGoc,
                        0.0,
                        tongTienGoc,
                        "",
                        null,
                        "Chua thanh toan"
                );
                return them(autoBill);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void bindPaymentTime(PreparedStatement ps, int index, String timeValue) throws SQLException {
        if (isBlank(timeValue)) {
            ps.setNull(index, Types.TIMESTAMP);
            return;
        }
        String normalized = timeValue.trim().replace("T", " ");
        if (normalized.length() == 16) {
            normalized = normalized + ":00";
        }
        ps.setTimestamp(index, Timestamp.valueOf(normalized));
    }

    private boolean existsByBookingId(String bookingId) {
        String sql = "SELECT 1 FROM HoaDon WHERE booking_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean existsById(String id) {
        String sql = "SELECT 1 FROM HoaDon WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private String generateHoaDonId() {
        String id = "HD" + System.currentTimeMillis();
        while (existsById(id)) {
            id = "HD" + System.currentTimeMillis() + (int) (Math.random() * 1000);
        }
        return id;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
