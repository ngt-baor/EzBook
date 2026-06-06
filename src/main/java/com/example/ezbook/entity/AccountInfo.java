package com.example.ezbook.entity;

public class AccountInfo {
    private final String username;
    private final String role;
    private final boolean active;
    private final String fullName;
    private final String phone;
    private final String password;

    public AccountInfo(String username, String role, boolean active, String fullName, String phone) {
        this(username, role, active, fullName, phone, null);
    }

    public AccountInfo(String username, String role, boolean active, String fullName, String phone, String password) {
        this.username = username;
        this.role = role;
        this.active = active;
        this.fullName = fullName;
        this.phone = phone;
        this.password = password;
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

    public String getPassword() {
        return password;
    }
}
