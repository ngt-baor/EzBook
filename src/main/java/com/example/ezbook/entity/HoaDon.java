package com.example.ezbook.entity;

public class HoaDon {
    private String id;
    private String booking_id;
    private double tong_tien_goc;
    private double tien_giam_gia;
    private double thanh_tien;
    private String phuong_thuc_thanh_toan; // Tiền mặt, Chuyển khoản, Ví điện tử
    private String thoi_gian_thanh_toan;
    private String trang_thai_thanh_toan; // Chưa thanh toán, Đã thanh toán, Hủy hóa đơn

    public HoaDon(String id, String booking_id, double tong_tien_goc, double tien_giam_gia,
                  double thanh_tien, String phuong_thuc_thanh_toan, String thoi_gian_thanh_toan, String trang_thai_thanh_toan) {
        this.id = id;
        this.booking_id = booking_id;
        this.tong_tien_goc = tong_tien_goc;
        this.tien_giam_gia = tien_giam_gia;
        this.thanh_tien = thanh_tien;
        this.phuong_thuc_thanh_toan = phuong_thuc_thanh_toan;
        this.thoi_gian_thanh_toan = thoi_gian_thanh_toan;
        this.trang_thai_thanh_toan = trang_thai_thanh_toan;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getBooking_id() { return booking_id; }
    public void setBooking_id(String booking_id) { this.booking_id = booking_id; }

    public double getTong_tien_goc() { return tong_tien_goc; }
    public void setTong_tien_goc(double tong_tien_goc) { this.tong_tien_goc = tong_tien_goc; }

    public double getTien_giam_gia() { return tien_giam_gia; }
    public void setTien_giam_gia(double tien_giam_gia) { this.tien_giam_gia = tien_giam_gia; }

    public double getThanh_tien() { return thanh_tien; }
    public void setThanh_tien(double thanh_tien) { this.thanh_tien = thanh_tien; }

    public String getPhuong_thuc_thanh_toan() { return phuong_thuc_thanh_toan; }
    public void setPhuong_thuc_thanh_toan(String phuong_thuc_thanh_toan) { this.phuong_thuc_thanh_toan = phuong_thuc_thanh_toan; }

    public String getThoi_gian_thanh_toan() { return thoi_gian_thanh_toan; }
    public void setThoi_gian_thanh_toan(String thoi_gian_thanh_toan) { this.thoi_gian_thanh_toan = thoi_gian_thanh_toan; }

    public String getTrang_thai_thanh_toan() { return trang_thai_thanh_toan; }
    public void setTrang_thai_thanh_toan(String trang_thai_thanh_toan) { this.trang_thai_thanh_toan = trang_thai_thanh_toan; }
}