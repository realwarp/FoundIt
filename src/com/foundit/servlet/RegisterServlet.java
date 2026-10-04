package com.foundit.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.foundit.util.DBConnection;
import com.foundit.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final String INSERT =
            "INSERT INTO users(name, email, password_hash) VALUES (?, ?, ?)";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (name == null || email == null || password == null
                || name.isBlank() || email.isBlank() || password.length() < 6) {
            res.sendRedirect(req.getContextPath() + "/register.jsp?error=invalid");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT)) {

            ps.setString(1, name.trim());
            ps.setString(2, email.trim().toLowerCase());
            ps.setString(3, PasswordUtil.hashPassword(password));
            ps.executeUpdate();

            res.sendRedirect(req.getContextPath() + "/login.jsp?registered=1");

        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) {
                res.sendRedirect(req.getContextPath() + "/register.jsp?error=exists");
                return;
            }
            throw new ServletException("Registration failed.", e);
        }
    }
}
