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

@WebServlet("/mark-returned")
public class MarkReturnedServlet extends HttpServlet {
    private static final String UPDATE =
            "UPDATE items SET status='RETURNED' WHERE id=? AND user_id=? AND status='ACTIVE'";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String rawId = req.getParameter("id");
        Integer userId = (Integer) req.getSession().getAttribute("userId");

        try {
            int id = Integer.parseInt(rawId);

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(UPDATE)) {

                ps.setInt(1, id);
                ps.setInt(2, userId);
                ps.executeUpdate();
            }

            res.sendRedirect(req.getContextPath() + "/dashboard?updated=1");

        } catch (NumberFormatException e) {
            res.sendRedirect(req.getContextPath() + "/dashboard?error=invalid");
        } catch (Exception e) {
            throw new ServletException("Could not update item.", e);
        }
    }
}
