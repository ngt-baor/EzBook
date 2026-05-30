package com.example.ezbook.entity;

public class DichVu {
    private String id;
    private String loai_dich_vu_id;
    private String ten_dich_vu;
    private double gia_tien;
    private boolean trang_thai;

    public DichVu(String id, String loai_dich_vu_id, String ten_dich_vu, double gia_tien, boolean trang_thai) {
        this.id = id;
        this.loai_dich_vu_id = loai_dich_vu_id;
        this.ten_dich_vu = ten_dich_vu;
        this.gia_tien = gia_tien;
        this.trang_thai = trang_thai;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getLoai_dich_vu_id() { return loai_dich_vu_id; }
    public void setLoai_dich_vu_id(String loai_dich_vu_id) { this.loai_dich_vu_id = loai_dich_vu_id; }

    public String getTen_dich_vu() { return ten_dich_vu; }
    public void setTen_dich_vu(String ten_dich_vu) { this.ten_dich_vu = ten_dich_vu; }

    public double getGia_tien() { return gia_tien; }
    public void setGia_tien(double gia_tien) { this.gia_tien = gia_tien; }

    public boolean isTrang_thai() { return trang_thai; }
    public void setTrang_thai(boolean trang_thai) { this.trang_thai = trang_thai; }
}