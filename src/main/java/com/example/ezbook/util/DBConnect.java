package com.example.ezbook.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {
    private static final String HOSTNAME = env("EZBOOK_DB_HOST", "localhost");
    private static final String PORT = env("EZBOOK_DB_PORT", "1433");
    private static final String DATABASENAME = env("EZBOOK_DB_NAME", "EZBookDB");
    private static final String USERNAME = env("EZBOOK_DB_USER", "sa");
    private static final String PASSWORD = env("EZBOOK_DB_PASSWORD", "123456");
    private static final String ENCRYPT = env("EZBOOK_DB_ENCRYPT", "true");
    private static final String TRUST_SERVER_CERTIFICATE = env("EZBOOK_DB_TRUST_SERVER_CERTIFICATE", "true");

    public static Connection getConnection() {
        String connectionUrl = env("EZBOOK_DB_URL", "");
        if (connectionUrl.isBlank()) {
            connectionUrl = "jdbc:sqlserver://" + HOSTNAME + ":" + PORT + ";"
                    + "databaseName=" + DATABASENAME + ";"
                    + "encrypt=" + ENCRYPT + ";"
                    + "trustServerCertificate=" + TRUST_SERVER_CERTIFICATE + ";";
        }

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(connectionUrl, USERNAME, PASSWORD);
        } catch (Exception e) {
            throw new IllegalStateException(
                    "Khong the ket noi SQL Server. Kiem tra driver, URL, username/password va trang thai SQL Server. URL="
                            + connectionUrl,
                    e
            );
        }
    }

    private static String env(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value == null || value.isBlank()) {
            return defaultValue;
        }
        return value.trim();
    }

    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("Ket noi SQL Server thanh cong.");
            } else {
                System.out.println("Ket noi SQL Server that bai.");
            }
        } catch (Exception e) {
            throw new IllegalStateException("Ket noi SQL Server that bai.", e);
        }
    }
}
