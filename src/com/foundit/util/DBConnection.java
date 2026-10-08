package com.foundit.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class DBConnection {

    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    private static final String URL =
            "jdbc:mysql://localhost:3306/foundit_db"
            + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";

    private static final String USER = "root";
    private static final String PASSWORD = "4645";

    private DBConnection() {
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new SQLException(
                    "MySQL Connector/J is missing. Copy mysql-connector-j-*.jar into WEB-INF/lib.",
                    e);
        }

        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
