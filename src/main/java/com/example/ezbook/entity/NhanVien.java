package com.example.ezbook.entity;

public class NhanVien {
    private String id;
    private String ho_ten;
    private String sdt;
    private String vai_tro;
    private boolean trang_thai;

    public NhanVien(String id, String ho_ten, String sdt, String vai_tro, boolean trang_thai) {
        this.id = id;
        this.ho_ten = ho_ten;
        this.sdt = sdt;
        this.vai_tro = vai_tro;
        this.trang_thai = trang_thai;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getHo_ten() {
        return ho_ten;
    }

    public void setHo_ten(String ho_ten) {
        this.ho_ten = ho_ten;
    }

    public String getSdt() {
        return sdt;
    }

    public void setSdt(String sdt) {
        this.sdt = sdt;
    }

    public String getVai_tro() {
        return vai_tro;
    }

    public void setVai_tro(String vai_tro) {
        this.vai_tro = vai_tro;
    }

    public boolean isTrang_thai() {
        return trang_thai;
    }

    public void setTrang_thai(boolean trang_thai) {
        this.trang_thai = trang_thai;
    }
}