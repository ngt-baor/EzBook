package com.example.ezbook.entity;

public class Booking {
    private String id;
    private String khach_hang_id;
    private String nhan_vien_id;
    private String dich_vu_id;
    private String khuyen_mai_id;
    private String thoi_gian_hen; // Định dạng YYYY-MM-DD HH:mm:ss
    private String trang_thai_booking; // Chờ xác nhận, Đã xác nhận, Đã hoàn thành, Đã hủy
    private String ghi_chu_khach_hang;

    public Booking(String id, String khach_hang_id, String nhan_vien_id, String dich_vu_id,
                   String khuyen_mai_id, String thoi_gian_hen, String trang_thai_booking, String ghi_chu_khach_hang) {
        this.id = id;
        this.khach_hang_id = khach_hang_id;
        this.nhan_vien_id = nhan_vien_id;
        this.dich_vu_id = dich_vu_id;
        this.khuyen_mai_id = khuyen_mai_id;
        this.thoi_gian_hen = thoi_gian_hen;
        this.trang_thai_booking = trang_thai_booking;
        this.ghi_chu_khach_hang = ghi_chu_khach_hang;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getKhach_hang_id() { return khach_hang_id; }
    public void setKhach_hang_id(String khach_hang_id) { this.khach_hang_id = khach_hang_id; }

    public String getNhan_vien_id() { return nhan_vien_id; }
    public void setNhan_vien_id(String nhan_vien_id) { this.nhan_vien_id = nhan_vien_id; }

    public String getDich_vu_id() { return dich_vu_id; }
    public void setDich_vu_id(String dich_vu_id) { this.dich_vu_id = dich_vu_id; }

    public String getKhuyen_mai_id() { return khuyen_mai_id; }
    public void setKhuyen_mai_id(String khuyen_mai_id) { this.khuyen_mai_id = khuyen_mai_id; }

    public String getThoi_gian_hen() { return thoi_gian_hen; }
    public void setThoi_gian_hen(String thoi_gian_hen) { this.thoi_gian_hen = thoi_gian_hen; }

    public String getTrang_thai_booking() { return trang_thai_booking; }
    public void setTrang_thai_booking(String trang_thai_booking) { this.trang_thai_booking = trang_thai_booking; }

    public String getGhi_chu_khach_hang() { return ghi_chu_khach_hang; }
    public void setGhi_chu_khach_hang(String ghi_chu_khach_hang) { this.ghi_chu_khach_hang = ghi_chu_khach_hang; }
}