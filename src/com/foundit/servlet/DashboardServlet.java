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

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final String ITEMS_SQL =
            "SELECT i.id, i.user_id, u.name, i.title, i.item_type, i.location, "
            + "i.description, i.contact, i.status, DATE_FORMAT(i.created_at, '%Y-%m-%d %H:%i') "
            + "FROM items i JOIN users u ON i.user_id=u.id "
            + "WHERE i.status='ACTIVE' "
            + "ORDER BY i.created_at DESC";
    private static final String COUNT_SQL =
            "SELECT "
            + "COUNT(*) AS total, "
            + "SUM(item_type='LOST' AND status='ACTIVE') AS lost, "
            + "SUM(item_type='FOUND' AND status='ACTIVE') AS found, "
            + "SUM(status='RETURNED') AS returned "
            + "FROM items";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String type = req.getParameter("type");
        if (!"LOST".equals(type) && !"FOUND".equals(type)) {
            type = "ALL";
        }

        List<Item> items = new ArrayList<>();
        int total = 0, lost = 0, found = 0, returned = 0;

        String sql = ITEMS_SQL;
        if (!"ALL".equals(type)) {
            sql = ITEMS_SQL.replace("ORDER BY", "AND i.item_type=? ORDER BY");
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             PreparedStatement count = con.prepareStatement(COUNT_SQL)) {

            if (!"ALL".equals(type)) {
                ps.setString(1, type);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Item item = new Item();
                    item.setId(rs.getInt(1));
                    item.setUserId(rs.getInt(2));
                    item.setUserName(rs.getString(3));
                    item.setTitle(rs.getString(4));
                    item.setItemType(rs.getString(5));
                    item.setLocation(rs.getString(6));
                    item.setDescription(rs.getString(7));
                    item.setContact(rs.getString(8));
                    item.setStatus(rs.getString(9));
                    item.setCreatedAt(rs.getString(10));
                    items.add(item);
                }
            }

            try (ResultSet rs = count.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt("total");
                    lost = rs.getInt("lost");
                    found = rs.getInt("found");
                    returned = rs.getInt("returned");
                }
            }

        } catch (Exception e) {
            throw new ServletException("Could not load dashboard.", e);
        }

        req.setAttribute("items", items);
        req.setAttribute("total", total);
        req.setAttribute("lost", lost);
        req.setAttribute("found", found);
        req.setAttribute("returned", returned);
        req.setAttribute("filter", type);
        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, res);
    }
}
