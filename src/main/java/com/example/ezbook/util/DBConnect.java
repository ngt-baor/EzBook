package com.example.ezbook.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.io.InputStream;
import java.util.Properties;

public class DBConnect {
    private static final Properties LOCAL_PROPERTIES = loadLocalProperties();
    private static final Object CONNECTION_LOCK = new Object();
    private static volatile Connection sharedConnection;
    private static final String HOSTNAME = config("EZBOOK_DB_HOST", "ezbook.db.host", "localhost");
    private static final String PORT = config("EZBOOK_DB_PORT", "ezbook.db.port", "5432");
    private static final String DATABASENAME = config("EZBOOK_DB_NAME", "ezbook.db.name", "postgres");
    private static final String USERNAME = config("EZBOOK_DB_USER", "ezbook.db.user", "postgres");
    private static final String PASSWORD = config("EZBOOK_DB_PASSWORD", "ezbook.db.password", "");
    private static final String SSL_MODE = config("EZBOOK_DB_SSL_MODE", "ezbook.db.sslMode", "require");

    public static Connection getConnection() {
        synchronized (CONNECTION_LOCK) {
            try {
                if (sharedConnection == null || sharedConnection.isClosed() || !sharedConnection.isValid(3)) {
                    sharedConnection = openConnection();
                }
                return sharedConnection;
            } catch (Exception e) {
                sharedConnection = openConnection();
                return sharedConnection;
            }
        }
    }

    private static Connection openConnection() {
        String connectionUrl = firstConfig(
                new String[]{"EZBOOK_DB_URL", "DATABASE_URL"},
                new String[]{"ezbook.db.url", "database.url"}
        );
        if (connectionUrl.isBlank()) {
            connectionUrl = "jdbc:postgresql://" + HOSTNAME + ":" + PORT + "/" + DATABASENAME
                    + "?sslmode=" + SSL_MODE;
        } else {
            connectionUrl = toJdbcUrl(connectionUrl);
        }

        try {
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(connectionUrl, USERNAME, PASSWORD);
        } catch (Exception e) {
            throw new IllegalStateException(
                    "Khong the ket noi PostgreSQL/Supabase. Kiem tra driver, URL, username/password va trang thai database. URL="
                            + connectionUrl,
                    e
            );
        }
    }

    private static String config(String envKey, String propertyKey, String defaultValue) {
        String value = firstNonBlank(
                System.getenv(envKey),
                System.getProperty(propertyKey),
                LOCAL_PROPERTIES.getProperty(propertyKey),
                LOCAL_PROPERTIES.getProperty(envKey)
        );
        if (value == null || value.isBlank()) {
            return defaultValue;
        }
        return value.trim();
    }

    private static String firstConfig(String[] envKeys, String[] propertyKeys) {
        for (String key : envKeys) {
            String value = System.getenv(key);
            if (value != null && !value.isBlank()) return value.trim();
        }
        for (String key : propertyKeys) {
            String value = System.getProperty(key);
            if (value != null && !value.isBlank()) return value.trim();
        }
        for (String key : propertyKeys) {
            String value = LOCAL_PROPERTIES.getProperty(key);
            if (value != null && !value.isBlank()) return value.trim();
        }
        for (String key : envKeys) {
            String value = LOCAL_PROPERTIES.getProperty(key);
            if (value != null && !value.isBlank()) return value.trim();
        }
        return "";
    }

    private static String firstNonBlank(String... values) {
        for (String value : values) {
            if (value != null && !value.isBlank()) {
                return value.trim();
            }
        }
        return null;
    }

    private static Properties loadLocalProperties() {
        Properties properties = new Properties();
        try (InputStream input = DBConnect.class.getClassLoader().getResourceAsStream("ezbook-db.properties")) {
            if (input != null) {
                properties.load(input);
            }
        } catch (Exception ignored) {
            // Environment variables still remain the primary deployment configuration.
        }
        return properties;
    }

    private static String toJdbcUrl(String url) {
        if (url.startsWith("jdbc:postgresql://")) {
            return url;
        }
        if (url.startsWith("postgresql://")) {
            return "jdbc:" + url;
        }
        if (url.startsWith("postgres://")) {
            return "jdbc:postgresql://" + url.substring("postgres://".length());
        }
        return url;
    }

    public static void main(String[] args) {
        try {
            Connection conn = getConnection();
            if (conn != null) {
                System.out.println("Ket noi PostgreSQL/Supabase thanh cong.");
            } else {
                System.out.println("Ket noi PostgreSQL/Supabase that bai.");
            }
        } catch (Exception e) {
            throw new IllegalStateException("Ket noi PostgreSQL/Supabase that bai.", e);
        }
    }
}
