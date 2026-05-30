package com.example.ezbook.entity;

public class LoaiDichVu {
    private String id;
    private String ten_loai;
    private String mo_ta;

    public LoaiDichVu(String id, String ten_loai, String mo_ta) {
        this.id = id;
        this.ten_loai = ten_loai;
        this.mo_ta = mo_ta;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTen_loai() { return ten_loai; }
    public void setTen_loai(String ten_loai) { this.ten_loai = ten_loai; }

    public String getMo_ta() { return mo_ta; }
    public void setMo_ta(String mo_ta) { this.mo_ta = mo_ta; }
}