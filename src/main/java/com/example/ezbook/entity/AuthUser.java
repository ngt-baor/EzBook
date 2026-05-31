package com.example.ezbook.entity;

public class AuthUser {
    private final String username;
    private final String displayName;
    private final String role;
    private final boolean active;

    public AuthUser(String username, String displayName, String role, boolean active) {
        this.username = username;
        this.displayName = displayName;
        this.role = role;
        this.active = active;
    }

    public String getUsername() {
        return username;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getRole() {
        return role;
    }

    public boolean isActive() {
        return active;
    }
}
