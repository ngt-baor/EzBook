package com.example.ezbook.entity;

public class KhachHang {
    private String id;
    private String ho_ten;
    private String sdt;
    private String ngay_sinh; // Định dạng YYYY-MM-DD hoặc dùng kiểu dữ liệu Date/LocalDate

    public KhachHang(String id, String ho_ten, String sdt, String ngay_sinh) {
        this.id = id;
        this.ho_ten = ho_ten;
        this.sdt = sdt;
        this.ngay_sinh = ngay_sinh;
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getHo_ten() { return ho_ten; }
    public void setHo_ten(String ho_ten) { this.ho_ten = ho_ten; }

    public String getSdt() { return sdt; }
    public void setSdt(String sdt) { this.sdt = sdt; }

    public String getNgay_sinh() { return ngay_sinh; }
    public void setNgay_sinh(String ngay_sinh) { this.ngay_sinh = ngay_sinh; }
}