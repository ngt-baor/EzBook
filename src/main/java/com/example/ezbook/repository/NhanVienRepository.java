package com.example.ezbook.repository;

import com.example.ezbook.entity.NhanVien;
import com.example.ezbook.util.DBConnect;

import java.text.Normalizer;
import java.sql.*;
import java.util.ArrayList;
import java.util.Locale;
import java.util.List;

public class NhanVienRepository {
    private Connection connection = null;

    public NhanVienRepository() {
        connection = DBConnect.getConnection();
    }

    public List<NhanVien> getAll() {
        String sql = "SELECT * FROM NhanVien";
        List<NhanVien> danhSach = new ArrayList<>();
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                danhSach.add(new NhanVien(
                        rs.getString("id"),
                        rs.getString("ho_ten"),
                        rs.getString("sdt"),
                        rs.getString("vai_tro"),
                        rs.getBoolean("trang_thai"),
                        null
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return danhSach;
    }

    public List<NhanVien> getNhanVienCoTheDatLich() {
        List<NhanVien> danhSach = new ArrayList<>();
        for (NhanVien nv : getAll()) {
            if (nv.isTrang_thai() && !laNhanVienQuanTri(nv)) {
                danhSach.add(nv);
            }
        }
        return danhSach;
    }

    public boolean coTheNhanBooking(String id) {
        if (id == null || id.trim().isEmpty()) {
            return false;
        }
        NhanVien nv = findById(id.trim());
        return nv != null && nv.isTrang_thai() && !laNhanVienQuanTri(nv);
    }

    public void them(NhanVien nv) {
        String sql = "INSERT INTO NhanVien (id, ho_ten, sdt, vai_tro, trang_thai) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, nv.getId());
            ps.setString(2, nv.getHo_ten());
            ps.setString(3, nv.getSdt());
            ps.setString(4, nv.getVai_tro());
            ps.setBoolean(5, nv.isTrang_thai());
            ps.execute();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public NhanVien findById(String id) {
        String sql = "SELECT * FROM NhanVien WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new NhanVien(
                        rs.getString("id"),
                        rs.getString("ho_ten"),
                        rs.getString("sdt"),
                        rs.getString("vai_tro"),
                        rs.getBoolean("trang_thai"),
                        null
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void update(NhanVien nv) {
        String sql = "UPDATE NhanVien SET ho_ten = ?, sdt = ?, vai_tro = ?, trang_thai = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, nv.getHo_ten());
            ps.setString(2, nv.getSdt());
            ps.setString(3, nv.getVai_tro());
            ps.setBoolean(4, nv.isTrang_thai());
            ps.setString(5, nv.getId());
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void xoa(String id) {
        String sql = "DELETE FROM NhanVien WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ps.execute();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private boolean laNhanVienQuanTri(NhanVien nv) {
        if (nv == null) {
            return false;
        }
        String vaiTro = chuanHoaText(nv.getVai_tro());
        String hoTen = chuanHoaText(nv.getHo_ten());
        return vaiTro.contains("admin")
                || vaiTro.contains("quan tri")
                || hoTen.contains("admin")
                || hoTen.contains("quan tri he thong");
    }

    private String chuanHoaText(String value) {
        if (value == null) {
            return "";
        }
        return Normalizer.normalize(value, Normalizer.Form.NFD)
                .replaceAll("\\p{M}", "")
                .toLowerCase(Locale.ROOT);
    }
}
