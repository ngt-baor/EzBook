package com.example.ezbook.entity;

public class MonthlyRevenue {
    private final int month;
    private final double revenue;
    private double widthPercent;

    public MonthlyRevenue(int month, double revenue) {
        this.month = month;
        this.revenue = revenue;
    }

    public int getMonth() {
        return month;
    }

    public double getRevenue() {
        return revenue;
    }

    public double getWidthPercent() {
        return widthPercent;
    }

    public void setWidthPercent(double widthPercent) {
        this.widthPercent = widthPercent;
    }
}
