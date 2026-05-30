package com.example.ezbook.entity;

public class KhuyenMai {
    private String id;
    private String ma_giam_gia;
    private String loai_giam; // "Phần trăm" hoặc "Số tiền cố định"
    private double gia_tri;
    private String ngay_bat_dau;
    private String ngay_ket_thuc;
    private int so_luong_gioi_han;
    private boolean trang_thai;

    public KhuyenMai(String id, String ma_giam_gia, String loai_giam, double gia_tri,
                     String ngay_bat_dau, String ngay_ket_thuc, int so_luong_gioi_han, boolean trang_thai) {
        this.id = id;
        this.ma_giam_gia = ma_giam_gia;
        this.loai_giam = loai_giam;
        this.gia_tri = gia_tri;
        this.ngay_bat_dau = ngay_bat_dau;
        this.ngay_ket_thuc = ngay_ket_thuc;
        this.so_luong_gioi_han = so_luong_gioi_han;
        this.trang_thai = trang_thai;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getMa_giam_gia() { return ma_giam_gia; }
    public void setMa_giam_gia(String ma_giam_gia) { this.ma_giam_gia = ma_giam_gia; }

    public String getLoai_giam() { return loai_giam; }
    public void setLoai_giam(String loai_giam) { this.loai_giam = loai_giam; }

    public double getGia_tri() { return gia_tri; }
    public void setGia_tri(double gia_tri) { this.gia_tri = gia_tri; }

    public String getNgay_bat_dau() { return ngay_bat_dau; }
    public void setNgay_bat_dau(String ngay_bat_dau) { this.ngay_bat_dau = ngay_bat_dau; }

    public String getNgay_ket_thuc() { return ngay_ket_thuc; }
    public void setNgay_ket_thuc(String ngay_ket_thuc) { this.ngay_ket_thuc = ngay_ket_thuc; }

    public int getSo_luong_gioi_han() { return so_luong_gioi_han; }
    public void setSo_luong_gioi_han(int so_luong_gioi_han) { this.so_luong_gioi_han = so_luong_gioi_han; }

    public boolean isTrang_thai() { return trang_thai; }
    public void setTrang_thai(boolean trang_thai) { this.trang_thai = trang_thai; }
}