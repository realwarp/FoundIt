package com.foundit.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBConnection {

    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    private DBConnection() {
    }

    private static String env(String name, String fallback) {
        String value = System.getenv(name);
        return value == null || value.isBlank() ? fallback : value;
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Connector/J is missing.", e);
        }

        String url = System.getenv("DB_URL");
        if (url == null || url.isBlank()) {
            String host = env("DB_HOST", "localhost");
            String port = env("DB_PORT", "3306");
            String database = env("DB_NAME", "foundit_db");
            String sslMode = env("DB_SSL_MODE", "REQUIRED");

            url = "jdbc:mysql://" + host + ":" + port + "/" + database
                    + "?serverTimezone=UTC"
                    + "&sslMode=" + sslMode
                    + "&allowPublicKeyRetrieval=true";
        }

        String user = env("DB_USER", "root");
        String password = env("DB_PASSWORD", "");

        if (password.isBlank()) {
            throw new SQLException(
                    "DB_PASSWORD is not configured. Set the database connection environment variables.");
        }

        return DriverManager.getConnection(url, user, password);
    }
}
