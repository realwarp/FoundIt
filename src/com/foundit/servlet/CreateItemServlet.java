package com.foundit.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.foundit.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/create-item")
public class CreateItemServlet extends HttpServlet {
    private static final String INSERT =
            "INSERT INTO items(user_id, title, item_type, location, description, contact) "
            + "VALUES (?, ?, ?, ?, ?, ?)";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        String title = req.getParameter("title");
        String type = req.getParameter("itemType");
        String location = req.getParameter("location");
        String description = req.getParameter("description");
        String contact = req.getParameter("contact");

        if (title == null || location == null || contact == null
                || title.isBlank() || location.isBlank() || contact.isBlank()
                || (!"LOST".equals(type) && !"FOUND".equals(type))) {
            res.sendRedirect(req.getContextPath() + "/report-item?error=invalid");
            return;
        }

        Integer userId = (Integer) req.getSession().getAttribute("userId");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(INSERT)) {

            ps.setInt(1, userId);
            ps.setString(2, title.trim());
            ps.setString(3, type);
            ps.setString(4, location.trim());
            ps.setString(5, description == null ? "" : description.trim());
            ps.setString(6, contact.trim());
            ps.executeUpdate();

            res.sendRedirect(req.getContextPath() + "/dashboard?created=1");

        } catch (Exception e) {
            throw new ServletException("Could not create item.", e);
        }
    }
}
