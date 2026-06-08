package com.example.ezbook.repository;

import com.example.ezbook.entity.KhuyenMai;
import com.example.ezbook.util.DBConnect;

import java.text.Normalizer;
import java.sql.*;
import java.util.ArrayList;
import java.util.Locale;
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

    public List<KhuyenMai> search(String keyword, String loaiGiam, String trangThai, String hieuLuc) {
        StringBuilder sql = new StringBuilder("SELECT * FROM KhuyenMai WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (!isBlank(keyword)) {
            sql.append("AND (id LIKE ? OR ma_giam_gia LIKE ?) ");
            String likeKeyword = "%" + keyword.trim() + "%";
            params.add(likeKeyword);
            params.add(likeKeyword);
        }

        if (!isBlank(loaiGiam)) {
            sql.append("AND loai_giam = ? ");
            params.add(loaiGiam.trim());
        }

        if ("active".equalsIgnoreCase(trangThai)) {
            sql.append("AND trang_thai = 1 ");
        } else if ("inactive".equalsIgnoreCase(trangThai)) {
            sql.append("AND trang_thai = 0 ");
        }

        if ("usable".equalsIgnoreCase(hieuLuc)) {
            sql.append("AND trang_thai = 1 AND so_luong_gioi_han > 0 AND CURRENT_TIMESTAMP BETWEEN ngay_bat_dau AND ngay_ket_thuc ");
        } else if ("upcoming".equalsIgnoreCase(hieuLuc)) {
            sql.append("AND CURRENT_TIMESTAMP < ngay_bat_dau ");
        } else if ("expired".equalsIgnoreCase(hieuLuc)) {
            sql.append("AND CURRENT_TIMESTAMP > ngay_ket_thuc ");
        } else if ("out-of-stock".equalsIgnoreCase(hieuLuc)) {
            sql.append("AND so_luong_gioi_han <= 0 ");
        }

        sql.append("ORDER BY trang_thai DESC, ngay_ket_thuc ASC, ma_giam_gia ASC");

        List<KhuyenMai> danhSach = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setString(i + 1, String.valueOf(params.get(i)));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    danhSach.add(mapKhuyenMai(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    public List<KhuyenMai> getDangHoatDong() {
        String sql = "SELECT * FROM KhuyenMai WHERE trang_thai = 1 ORDER BY ngay_ket_thuc ASC, ma_giam_gia ASC";
        List<KhuyenMai> danhSach = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                danhSach.add(mapKhuyenMai(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    public KhuyenMai findUsableByCode(String maGiamGia, Timestamp thoiDiemApDung) {
        if (isBlank(maGiamGia) || thoiDiemApDung == null) {
            return null;
        }
        String sql = "SELECT * FROM KhuyenMai WHERE UPPER(ma_giam_gia) = UPPER(?) " +
                "AND trang_thai = 1 AND so_luong_gioi_han > 0 " +
                "AND ? BETWEEN ngay_bat_dau AND ngay_ket_thuc";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, maGiamGia.trim());
            ps.setTimestamp(2, thoiDiemApDung);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapKhuyenMai(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public KhuyenMai findUsableById(String id, Timestamp thoiDiemApDung) {
        if (isBlank(id) || thoiDiemApDung == null) {
            return null;
        }
        String sql = "SELECT * FROM KhuyenMai WHERE id = ? " +
                "AND trang_thai = 1 AND so_luong_gioi_han > 0 " +
                "AND ? BETWEEN ngay_bat_dau AND ngay_ket_thuc";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, id.trim());
            ps.setTimestamp(2, thoiDiemApDung);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapKhuyenMai(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean giamSoLuongConLai(String id) {
        if (isBlank(id)) {
            return false;
        }
        String sql = "UPDATE KhuyenMai SET so_luong_gioi_han = so_luong_gioi_han - 1 " +
                "WHERE id = ? AND so_luong_gioi_han > 0";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, id.trim());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public double tinhTienGiam(KhuyenMai khuyenMai, double tongTienGoc) {
        if (khuyenMai == null || tongTienGoc <= 0) {
            return 0.0;
        }
        double tienGiam;
        String loaiGiam = normalize(khuyenMai.getLoai_giam());
        if (loaiGiam.contains("phan tram") || loaiGiam.contains("percent")) {
            tienGiam = tongTienGoc * khuyenMai.getGia_tri() / 100.0;
        } else {
            tienGiam = khuyenMai.getGia_tri();
        }
        return Math.max(0.0, Math.min(tienGiam, tongTienGoc));
    }

    public boolean them(KhuyenMai km) {
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
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
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

    public KhuyenMai findByCode(String maGiamGia) {
        String sql = "SELECT * FROM KhuyenMai WHERE UPPER(ma_giam_gia) = UPPER(?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, maGiamGia);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapKhuyenMai(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean update(KhuyenMai km) {
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
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean xoa(String id) {
        String sql = "DELETE FROM KhuyenMai WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private KhuyenMai mapKhuyenMai(ResultSet rs) throws SQLException {
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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String normalize(String value) {
        if (value == null) {
            return "";
        }
        return Normalizer.normalize(value, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .toLowerCase(Locale.ROOT);
    }
}
