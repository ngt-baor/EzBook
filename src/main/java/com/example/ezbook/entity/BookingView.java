package com.example.ezbook.entity;

import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;

public class BookingView {
    private final String id;
    private final String khachHangId;
    private final String khachHangTen;
    private final String khachHangSdt;
    private final String nhanVienId;
    private final String nhanVienTen;
    private final String dichVuId;
    private final String dichVuTen;
    private final String khuyenMaiCode;
    private final Timestamp thoiGianHen;
    private final String trangThaiBooking;
    private final String ghiChuKhachHang;
    private final String phuongThucThanhToan;

    public BookingView(String id, String khachHangId, String khachHangTen, String khachHangSdt,
                       String nhanVienId, String nhanVienTen, String dichVuId, String dichVuTen,
                       Timestamp thoiGianHen, String trangThaiBooking, String ghiChuKhachHang) {
        this(id, khachHangId, khachHangTen, khachHangSdt, nhanVienId, nhanVienTen, dichVuId, dichVuTen,
                null, thoiGianHen, trangThaiBooking, ghiChuKhachHang, "Tien mat");
    }

    public BookingView(String id, String khachHangId, String khachHangTen, String khachHangSdt,
                       String nhanVienId, String nhanVienTen, String dichVuId, String dichVuTen,
                       Timestamp thoiGianHen, String trangThaiBooking, String ghiChuKhachHang,
                       String phuongThucThanhToan) {
        this(id, khachHangId, khachHangTen, khachHangSdt, nhanVienId, nhanVienTen, dichVuId, dichVuTen,
                null, thoiGianHen, trangThaiBooking, ghiChuKhachHang, phuongThucThanhToan);
    }

    public BookingView(String id, String khachHangId, String khachHangTen, String khachHangSdt,
                       String nhanVienId, String nhanVienTen, String dichVuId, String dichVuTen,
                       String khuyenMaiCode, Timestamp thoiGianHen, String trangThaiBooking, String ghiChuKhachHang,
                       String phuongThucThanhToan) {
        this.id = id;
        this.khachHangId = khachHangId;
        this.khachHangTen = khachHangTen;
        this.khachHangSdt = khachHangSdt;
        this.nhanVienId = nhanVienId;
        this.nhanVienTen = nhanVienTen;
        this.dichVuId = dichVuId;
        this.dichVuTen = dichVuTen;
        this.khuyenMaiCode = khuyenMaiCode;
        this.thoiGianHen = thoiGianHen;
        this.trangThaiBooking = trangThaiBooking;
        this.ghiChuKhachHang = ghiChuKhachHang;
        this.phuongThucThanhToan = phuongThucThanhToan;
    }

    public String getId() {
        return id;
    }

    public String getKhachHangId() {
        return khachHangId;
    }

    public String getKhachHangTen() {
        return khachHangTen;
    }

    public String getKhachHangSdt() {
        return khachHangSdt;
    }

    public String getNhanVienId() {
        return nhanVienId;
    }

    public String getNhanVienTen() {
        return nhanVienTen;
    }

    public String getDichVuId() {
        return dichVuId;
    }

    public String getDichVuTen() {
        return dichVuTen;
    }

    public String getKhuyenMaiCode() {
        return khuyenMaiCode;
    }

    public Timestamp getThoiGianHen() {
        return thoiGianHen;
    }

    public String getThoiGianHenText() {
        if (thoiGianHen == null) return "";
        return thoiGianHen.toLocalDateTime().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"));
    }

    public String getTrangThaiBooking() {
        return trangThaiBooking;
    }

    public String getGhiChuKhachHang() {
        return ghiChuKhachHang;
    }

    public String getPhuongThucThanhToan() {
        return phuongThucThanhToan;
    }
}
