package com.foundit.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.foundit.util.DBConnection;
import com.foundit.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final String SQL =
            "SELECT id, name, password_hash FROM users WHERE email = ?";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || password == null
                || email.isBlank() || password.isBlank()) {
            res.sendRedirect("login.jsp?error=invalid");
            return;
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SQL)) {

            ps.setString(1, email.trim().toLowerCase());

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && PasswordUtil.verifyPassword(password, rs.getString("password_hash"))) {
                    HttpSession session = req.getSession(true);
                    session.setAttribute("userId", rs.getInt("id"));
                    session.setAttribute("userName", rs.getString("name"));
                    session.setMaxInactiveInterval(30 * 60);
                    res.sendRedirect(req.getContextPath() + "/dashboard");
                    return;
                }
            }

            res.sendRedirect(req.getContextPath() + "/login.jsp?error=credentials");

        } catch (Exception e) {
            throw new ServletException("Login failed.", e);
        }
    }
}
