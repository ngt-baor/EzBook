package com.example.ezbook.repository;

import com.example.ezbook.entity.HoaDon;
import com.example.ezbook.entity.KhuyenMai;
import com.example.ezbook.entity.MonthlyRevenue;
import com.example.ezbook.util.DBConnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class HoaDonRepository {
    private Connection connection = null;
    private final KhuyenMaiRepository khuyenMaiRepository = new KhuyenMaiRepository();

    public HoaDonRepository() {
        connection = DBConnect.getConnection();
    }

    public List<HoaDon> getAll() {
        return search(null, null, null, null, null);
    }

    public List<HoaDon> search(String keyword, String paymentStatus, String paymentMethod, Date fromDate, Date toDate) {
        StringBuilder sql = new StringBuilder("SELECT * FROM HoaDon WHERE 1 = 1");
        List<Object> params = new ArrayList<>();

        if (!isBlank(keyword)) {
            sql.append(" AND (id LIKE ? OR booking_id LIKE ?)");
            String likeKeyword = "%" + keyword.trim() + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
        }

        if (!isBlank(paymentStatus)) {
            sql.append(" AND trang_thai_thanh_toan = ?");
            params.add(paymentStatus.trim());
        }

        if (!isBlank(paymentMethod)) {
            sql.append(" AND phuong_thuc_thanh_toan = ?");
            params.add(paymentMethod.trim());
        }

        if (fromDate != null) {
            sql.append(" AND CAST(thoi_gian_thanh_toan AS DATE) >= ?");
            params.add(fromDate);
        }

        if (toDate != null) {
            sql.append(" AND CAST(thoi_gian_thanh_toan AS DATE) <= ?");
            params.add(toDate);
        }

        sql.append(" ORDER BY CASE WHEN thoi_gian_thanh_toan IS NULL THEN 1 ELSE 0 END, thoi_gian_thanh_toan DESC, id DESC");
        List<HoaDon> danhSach = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object value = params.get(i);
                if (value instanceof Date) {
                    ps.setDate(i + 1, (Date) value);
                } else {
                    ps.setString(i + 1, String.valueOf(value));
                }
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    danhSach.add(mapHoaDon(rs));
                }
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
                return mapHoaDon(rs);
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

    public boolean xacNhanDaThanhToan(String id) {
        String sql = "UPDATE HoaDon SET trang_thai_thanh_toan = ?, thoi_gian_thanh_toan = CURRENT_TIMESTAMP " +
                "WHERE id = ? AND trang_thai_thanh_toan = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "Da thanh toan");
            ps.setString(2, id);
            ps.setString(3, "Chua thanh toan");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<MonthlyRevenue> thongKeDoanhThuTheoThang(int year) {
        String sql = "SELECT EXTRACT(MONTH FROM thoi_gian_thanh_toan) AS thang, SUM(thanh_tien) AS doanh_thu " +
                "FROM HoaDon " +
                "WHERE thoi_gian_thanh_toan IS NOT NULL " +
                "AND trang_thai_thanh_toan = 'Da thanh toan' " +
                "AND EXTRACT(YEAR FROM thoi_gian_thanh_toan) = ? " +
                "GROUP BY EXTRACT(MONTH FROM thoi_gian_thanh_toan)";

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

        String sqlGia = "SELECT dv.gia_tien, b.khuyen_mai_id, b.ghi_chu_khach_hang FROM Booking b " +
                "JOIN DichVu dv ON b.dich_vu_id = dv.id WHERE b.id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sqlGia)) {
            ps.setString(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return false;
                }
                double tongTienGoc = rs.getDouble("gia_tien");
                String khuyenMaiId = rs.getString("khuyen_mai_id");
                KhuyenMai khuyenMai = isBlank(khuyenMaiId) ? null : khuyenMaiRepository.findById(khuyenMaiId);
                double tienGiamGia = khuyenMaiRepository.tinhTienGiam(khuyenMai, tongTienGoc);
                double thanhTien = Math.max(0.0, tongTienGoc - tienGiamGia);
                String paymentMethod = extractPaymentMethod(rs.getString("ghi_chu_khach_hang"));
                HoaDon autoBill = new HoaDon(
                        generateHoaDonId(),
                        bookingId,
                        tongTienGoc,
                        tienGiamGia,
                        thanhTien,
                        paymentMethod,
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

    private HoaDon mapHoaDon(ResultSet rs) throws SQLException {
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

    private String extractPaymentMethod(String note) {
        if (note == null) {
            return "Tien mat";
        }
        String prefix = "[PTTT:";
        String suffix = "]";
        String trimmed = note.trim();
        if (!trimmed.startsWith(prefix)) {
            return "Tien mat";
        }
        int end = trimmed.indexOf(suffix, prefix.length());
        if (end < 0) {
            return "Tien mat";
        }
        String value = trimmed.substring(prefix.length(), end).trim();
        if ("Chuyen khoan".equalsIgnoreCase(value)) {
            return "Chuyen khoan";
        }
        return "Tien mat";
    }
}
