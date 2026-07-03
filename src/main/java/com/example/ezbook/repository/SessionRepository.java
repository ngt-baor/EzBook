package com.example.ezbook.repository;

import com.example.ezbook.util.DBConnect;

import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Base64;

public class SessionRepository {
    public static final String SESSION_TOKEN_ATTRIBUTE = "loginSessionToken";

    private static final Object SCHEMA_LOCK = new Object();
    private static volatile boolean schemaReady = false;
    private final SecureRandom secureRandom = new SecureRandom();

    public String issueSessionToken(String username) {
        if (isBlank(username)) {
            return null;
        }
        ensureSchema();

        String token = generateToken();
        String sql = "UPDATE TaiKhoan SET current_session_token = ? WHERE username = ?";
        Connection connection = DBConnect.getConnection();
        synchronized (connection) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, token);
                ps.setString(2, username);
                return ps.executeUpdate() > 0 ? token : null;
            } catch (SQLException e) {
                e.printStackTrace();
                return null;
            }
        }
    }

    public boolean isCurrentSession(String username, String token) {
        if (isBlank(username) || isBlank(token)) {
            return false;
        }
        ensureSchema();

        String sql = "SELECT current_session_token FROM TaiKhoan WHERE username = ?";
        Connection connection = DBConnect.getConnection();
        synchronized (connection) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, username);
                try (ResultSet rs = ps.executeQuery()) {
                    return rs.next() && token.equals(rs.getString("current_session_token"));
                }
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }
    }

    public void clearSessionTokenIfMatches(String username, String token) {
        if (isBlank(username) || isBlank(token)) {
            return;
        }
        ensureSchema();

        String sql = "UPDATE TaiKhoan SET current_session_token = NULL WHERE username = ? AND current_session_token = ?";
        Connection connection = DBConnect.getConnection();
        synchronized (connection) {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, token);
                ps.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private void ensureSchema() {
        if (schemaReady) {
            return;
        }
        synchronized (SCHEMA_LOCK) {
            if (schemaReady) {
                return;
            }
            Connection connection = DBConnect.getConnection();
            synchronized (connection) {
                try (Statement st = connection.createStatement()) {
                    st.executeUpdate("ALTER TABLE TaiKhoan ADD COLUMN IF NOT EXISTS current_session_token VARCHAR(255)");
                    schemaReady = true;
                } catch (SQLException e) {
                    throw new IllegalStateException("Khong the khoi tao cot current_session_token cho TaiKhoan.", e);
                }
            }
        }
    }

    private String generateToken() {
        byte[] bytes = new byte[32];
        secureRandom.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
