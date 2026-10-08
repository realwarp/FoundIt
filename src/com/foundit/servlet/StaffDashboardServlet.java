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

@WebServlet("/staff-dashboard")
public class StaffDashboardServlet extends HttpServlet {

    private static final String ITEMS_SQL =
            "SELECT id, item_name, photo, found_location, given_by, "
            + "DATE_FORMAT(date_found, '%d %b %Y'), status "
            + "FROM items ORDER BY id DESC";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Item> items = new ArrayList<>();

                try (Connection connection = DBConnection.getConnection();
                         PreparedStatement itemStatement = connection.prepareStatement(ITEMS_SQL)) {

            try (ResultSet result = itemStatement.executeQuery()) {
                while (result.next()) {
                    Item item = new Item();
                    item.setId(result.getInt(1));
                    item.setItemName(result.getString(2));
                    item.setPhoto(result.getString(3));
                    item.setFoundLocation(result.getString(4));
                    item.setGivenBy(result.getString(5));
                    item.setDateFound(result.getString(6));
                    item.setStatus(result.getString(7));
                    items.add(item);
                }
            }

        } catch (Exception e) {
            throw new ServletException("Unable to load dashboard.", e);
        }

        request.setAttribute("items", items);

        request.getRequestDispatcher("/WEB-INF/views/staff-dashboard.jsp")
                .forward(request, response);
    }
}
