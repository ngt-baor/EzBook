package com.example.ezbook.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnect {
    // Thay đổi thông tin cho đúng với máy của bạn
    private static final String HOSTNAME = "localhost";
    private static final String PORT = "1433";
    private static final String DATABASENAME = "EZBookDB";
    private static final String USERNAME = "sa";
    private static final String PASSWORD = "123456"; // Mật khẩu sa của bạn

    public static Connection getConnection() {
        String connectionUrl = "jdbc:sqlserver://" + HOSTNAME + ":" + PORT + ";"
                + "databaseName=" + DATABASENAME + ";"
                + "encrypt=true;trustServerCertificate=true;";

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

    // Test nhanh xem kết nối chạy được không trước khi bật Tomcat
    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("Kết nối thành công rồi Bảo ơi!");
        } else {
            System.out.println("Kết nối thất bại, xem lại tài khoản/mật khẩu SQL hoặc cổng Port nha!");
        }
    }
}