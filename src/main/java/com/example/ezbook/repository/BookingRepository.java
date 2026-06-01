package com.example.ezbook.repository;

import com.example.ezbook.entity.Booking;
import com.example.ezbook.entity.BookingView;
import com.example.ezbook.util.DBConnect;

import java.sql.*;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class BookingRepository {
    private final Connection connection;

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

    public boolean them(Booking bk, Timestamp thoiGianHen) {
        String sql = "INSERT INTO Booking (id, khach_hang_id, nhan_vien_id, dich_vu_id, khuyen_mai_id, thoi_gian_hen, trang_thai_booking, ghi_chu_khach_hang) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, bk.getId());
            ps.setString(2, bk.getKhach_hang_id());
            ps.setString(3, bk.getNhan_vien_id());
            ps.setString(4, bk.getDich_vu_id());
            if (bk.getKhuyen_mai_id() == null || bk.getKhuyen_mai_id().isBlank()) {
                ps.setNull(5, Types.VARCHAR);
            } else {
                ps.setString(5, bk.getKhuyen_mai_id());
            }
            ps.setTimestamp(6, thoiGianHen);
            ps.setString(7, bk.getTrang_thai_booking());
            ps.setString(8, bk.getGhi_chu_khach_hang());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
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

    public boolean isNhanVienTrungLich(String nhanVienId, Timestamp thoiGianHen) {
        String sql = "SELECT COUNT(1) FROM Booking WHERE nhan_vien_id = ? AND thoi_gian_hen = ? " +
                "AND trang_thai_booking NOT IN ('Cancelled', N'Da huy')";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, nhanVienId);
            ps.setTimestamp(2, thoiGianHen);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public String findStatusById(String bookingId) {
        String sql = "SELECT trang_thai_booking FROM Booking WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("trang_thai_booking");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateStatus(String bookingId, String newStatus) {
        String sql = "UPDATE Booking SET trang_thai_booking = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setString(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isValidStatusTransition(String currentStatusRaw, String nextStatusRaw) {
        String currentStatus = normalizeStatus(currentStatusRaw);
        String nextStatus = normalizeStatus(nextStatusRaw);

        if (currentStatus == null || nextStatus == null) {
            return false;
        }
        if ("Pending".equals(currentStatus)) {
            return Arrays.asList("Confirmed", "Cancelled").contains(nextStatus);
        }
        if ("Confirmed".equals(currentStatus)) {
            return Arrays.asList("Completed", "Cancelled").contains(nextStatus);
        }
        return false;
    }

    public String normalizeStatus(String status) {
        if (status == null) return null;
        String ascii = Normalizer.normalize(status.trim(), Normalizer.Form.NFD)
                .replaceAll("\\p{M}+", "")
                .toLowerCase();
        if (ascii.equals("pending") || ascii.equals("cho xac nhan")) return "Pending";
        if (ascii.equals("confirmed") || ascii.equals("da xac nhan")) return "Confirmed";
        if (ascii.equals("completed") || ascii.equals("da hoan thanh")) return "Completed";
        if (ascii.equals("cancelled") || ascii.equals("da huy")) return "Cancelled";
        return status;
    }

    public List<BookingView> getAllForView(String keyword, String status, Date fromDate, Date toDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT b.id, b.khach_hang_id, kh.ho_ten AS khach_hang_ten, kh.sdt AS khach_hang_sdt, " +
                        "b.nhan_vien_id, nv.ho_ten AS nhan_vien_ten, b.dich_vu_id, dv.ten_dich_vu, " +
                        "b.thoi_gian_hen, b.trang_thai_booking, b.ghi_chu_khach_hang " +
                        "FROM Booking b " +
                        "JOIN KhachHang kh ON b.khach_hang_id = kh.id " +
                        "LEFT JOIN NhanVien nv ON b.nhan_vien_id = nv.id " +
                        "JOIN DichVu dv ON b.dich_vu_id = dv.id " +
                        "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.isBlank()) {
            sql.append("AND (kh.ho_ten LIKE ? OR kh.sdt LIKE ?) ");
            String key = "%" + keyword.trim() + "%";
            params.add(key);
            params.add(key);
        }
        if (status != null && !status.isBlank()) {
            String normalized = normalizeStatus(status.trim());
            if ("Pending".equals(normalized)) {
                sql.append("AND b.trang_thai_booking IN (?, ?) ");
                params.add("Pending");
                params.add("Cho xac nhan");
            } else if ("Confirmed".equals(normalized)) {
                sql.append("AND b.trang_thai_booking IN (?, ?) ");
                params.add("Confirmed");
                params.add("Da xac nhan");
            } else if ("Completed".equals(normalized)) {
                sql.append("AND b.trang_thai_booking IN (?, ?) ");
                params.add("Completed");
                params.add("Da hoan thanh");
            } else if ("Cancelled".equals(normalized)) {
                sql.append("AND b.trang_thai_booking IN (?, ?) ");
                params.add("Cancelled");
                params.add("Da huy");
            } else {
                sql.append("AND b.trang_thai_booking = ? ");
                params.add(status.trim());
            }
        }
        if (fromDate != null) {
            sql.append("AND CAST(b.thoi_gian_hen AS DATE) >= ? ");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append("AND CAST(b.thoi_gian_hen AS DATE) <= ? ");
            params.add(toDate);
        }
        sql.append("ORDER BY b.thoi_gian_hen DESC");

        List<BookingView> result = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                Object value = params.get(i);
                if (value instanceof Date) {
                    ps.setDate(i + 1, (Date) value);
                } else {
                    ps.setString(i + 1, String.valueOf(value));
                }
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                result.add(new BookingView(
                        rs.getString("id"),
                        rs.getString("khach_hang_id"),
                        rs.getString("khach_hang_ten"),
                        rs.getString("khach_hang_sdt"),
                        rs.getString("nhan_vien_id"),
                        rs.getString("nhan_vien_ten"),
                        rs.getString("dich_vu_id"),
                        rs.getString("ten_dich_vu"),
                        rs.getTimestamp("thoi_gian_hen"),
                        normalizeStatus(rs.getString("trang_thai_booking")),
                        rs.getString("ghi_chu_khach_hang")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<BookingView> getByKhachHangSdt(String sdt) {
        String sql = "SELECT b.id, b.khach_hang_id, kh.ho_ten AS khach_hang_ten, kh.sdt AS khach_hang_sdt, " +
                "b.nhan_vien_id, nv.ho_ten AS nhan_vien_ten, b.dich_vu_id, dv.ten_dich_vu, " +
                "b.thoi_gian_hen, b.trang_thai_booking, b.ghi_chu_khach_hang " +
                "FROM Booking b " +
                "JOIN KhachHang kh ON b.khach_hang_id = kh.id " +
                "LEFT JOIN NhanVien nv ON b.nhan_vien_id = nv.id " +
                "JOIN DichVu dv ON b.dich_vu_id = dv.id " +
                "WHERE kh.sdt = ? " +
                "ORDER BY b.thoi_gian_hen DESC";

        List<BookingView> result = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, sdt);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                result.add(new BookingView(
                        rs.getString("id"),
                        rs.getString("khach_hang_id"),
                        rs.getString("khach_hang_ten"),
                        rs.getString("khach_hang_sdt"),
                        rs.getString("nhan_vien_id"),
                        rs.getString("nhan_vien_ten"),
                        rs.getString("dich_vu_id"),
                        rs.getString("ten_dich_vu"),
                        rs.getTimestamp("thoi_gian_hen"),
                        normalizeStatus(rs.getString("trang_thai_booking")),
                        rs.getString("ghi_chu_khach_hang")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public boolean huyBookingChoKhachHang(String bookingId, String sdt) {
        String sql = "UPDATE b SET b.trang_thai_booking = 'Cancelled' " +
                "FROM Booking b " +
                "JOIN KhachHang kh ON b.khach_hang_id = kh.id " +
                "WHERE b.id = ? AND kh.sdt = ? " +
                "AND b.trang_thai_booking IN ('Pending', N'Cho xac nhan', 'Confirmed', N'Da xac nhan')";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, bookingId);
            ps.setString(2, sdt);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
