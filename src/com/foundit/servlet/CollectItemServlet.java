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

@WebServlet("/collect-item")
public class CollectItemServlet extends HttpServlet {

    private static final String SQL =
            "UPDATE items SET status = 'COLLECTED' WHERE id = ? "
            + "AND status = 'AVAILABLE'";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idValue = request.getParameter("id");

        try {
            int id = Integer.parseInt(idValue);

            try (Connection connection = DBConnection.getConnection();
                 PreparedStatement statement = connection.prepareStatement(SQL)) {

                statement.setInt(1, id);
                statement.executeUpdate();
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/staff-dashboard?error=invalid");
            return;
        } catch (Exception e) {
            throw new ServletException("Unable to mark item as collected.", e);
        }

        response.sendRedirect(
                request.getContextPath() + "/staff-dashboard?updated=1");
    }
}
