package com.foundit.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.foundit.model.Item;
import com.foundit.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/guest-items")
public class GuestItemsServlet extends HttpServlet {

    private static final String SQL =
            "SELECT id, item_name, photo, found_location, date_found, status "
            + "FROM items "
            + "WHERE status = 'AVAILABLE' "
            + "AND item_name LIKE ? "
            + "ORDER BY date_found DESC";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        if (search == null) {
            search = "";
        }

        List<Item> items = new ArrayList<>();

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL)) {

            statement.setString(1, "%" + search.trim() + "%");

            try (ResultSet result = statement.executeQuery()) {
                while (result.next()) {
                    Item item = new Item();
                    item.setId(result.getInt(1));
                    item.setItemName(result.getString(2));
                    item.setPhoto(result.getString(3));
                    item.setFoundLocation(result.getString(4));
                    item.setDateFound(result.getString(5));
                    item.setStatus(result.getString(6));
                    items.add(item);
                }
            }

        } catch (Exception e) {
            throw new ServletException("Unable to load available items.", e);
        }

        request.setAttribute("items", items);
        request.setAttribute("search", search);

        request.getRequestDispatcher("/WEB-INF/views/guest-items.jsp")
                .forward(request, response);
    }
}
