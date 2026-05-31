package com.example.ezbook.entity;

public class AccountInfo {
    private final String username;
    private final String role;
    private final boolean active;
    private final String fullName;
    private final String phone;

    public AccountInfo(String username, String role, boolean active, String fullName, String phone) {
        this.username = username;
        this.role = role;
        this.active = active;
        this.fullName = fullName;
        this.phone = phone;
    }

    public String getUsername() {
        return username;
    }

    public String getRole() {
        return role;
    }

    public boolean isActive() {
        return active;
    }

    public String getFullName() {
        return fullName;
    }

    public String getPhone() {
        return phone;
    }
}
