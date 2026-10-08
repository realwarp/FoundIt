package com.foundit.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.foundit.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/staff-login")
public class StaffLoginServlet extends HttpServlet {

    private static final String SQL =
            "SELECT username FROM staff WHERE username = ? AND password = ?";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null
                || username.isBlank() || password.isBlank()) {
            response.sendRedirect(request.getContextPath()
                    + "/staff-login.jsp?error=invalid");
            return;
        }

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL)) {

            statement.setString(1, username.trim());
            statement.setString(2, password);

            try (ResultSet result = statement.executeQuery()) {
                if (result.next()) {
                    jakarta.servlet.http.HttpSession oldSession =
                            request.getSession(false);
                    if (oldSession != null) {
                        oldSession.invalidate();
                    }

                    request.getSession(true).setAttribute(
                            "staffUser", result.getString("username"));

                    response.sendRedirect(
                            request.getContextPath() + "/staff-dashboard");
                    return;
                }
            }

            response.sendRedirect(request.getContextPath()
                    + "/staff-login.jsp?error=credentials");

        } catch (Exception e) {
            throw new ServletException("Unable to login.", e);
        }
    }
}
