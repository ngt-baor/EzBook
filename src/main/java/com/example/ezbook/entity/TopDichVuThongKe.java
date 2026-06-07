package com.example.ezbook.entity;

public class TopDichVuThongKe {
    private final String dichVuId;
    private final String tenDichVu;
    private final int soLuotDat;
    private final double doanhThuDuKien;

    public TopDichVuThongKe(String dichVuId, String tenDichVu, int soLuotDat, double doanhThuDuKien) {
        this.dichVuId = dichVuId;
        this.tenDichVu = tenDichVu;
        this.soLuotDat = soLuotDat;
        this.doanhThuDuKien = doanhThuDuKien;
    }

    public String getDichVuId() {
        return dichVuId;
    }

    public String getTenDichVu() {
        return tenDichVu;
    }

    public int getSoLuotDat() {
        return soLuotDat;
    }

    public double getDoanhThuDuKien() {
        return doanhThuDuKien;
    }
}
