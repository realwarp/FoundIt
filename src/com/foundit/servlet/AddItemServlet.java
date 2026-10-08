package com.foundit.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.UUID;

import com.foundit.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/add-item")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024)
public class AddItemServlet extends HttpServlet {

    private static final String SQL =
            "INSERT INTO items(item_name, photo, found_location, given_by, date_found) "
            + "VALUES (?, ?, ?, ?, ?)";

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/add-item.jsp")
            .forward(request, response);
        }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String itemName = request.getParameter("itemName");
        String foundLocation = request.getParameter("foundLocation");
        String givenBy = request.getParameter("givenBy");
        String dateFound = request.getParameter("dateFound");
        Part photoPart = request.getPart("photo");

        if (itemName == null || foundLocation == null || givenBy == null
                || dateFound == null || photoPart == null
                || itemName.isBlank() || foundLocation.isBlank()
                || givenBy.isBlank() || dateFound.isBlank()
                || photoPart.getSize() == 0) {

            response.sendRedirect(request.getContextPath()
                    + "/add-item?error=invalid");
            return;
        }

        String contentType = photoPart.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            response.sendRedirect(request.getContextPath()
                    + "/add-item?error=image");
            return;
        }

        String submittedName = photoPart.getSubmittedFileName();
        String extension = "";

        if (submittedName != null && submittedName.contains(".")) {
            extension = submittedName.substring(
                    submittedName.lastIndexOf(".")).toLowerCase();
        }

        String storedName = UUID.randomUUID() + extension;

        String uploadPath = request.getServletContext().getRealPath("/uploads");

        if (uploadPath == null) {
            throw new ServletException("Upload directory is unavailable.");
        }

        Path directory = Paths.get(uploadPath);
        Files.createDirectories(directory);

        Path target = directory.resolve(storedName).normalize();

        try (InputStream input = photoPart.getInputStream()) {
            Files.copy(input, target, StandardCopyOption.REPLACE_EXISTING);
        }

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(SQL)) {

            statement.setString(1, itemName.trim());
            statement.setString(2, storedName);
            statement.setString(3, foundLocation.trim());
            statement.setString(4, givenBy.trim());
            statement.setString(5, dateFound);
            statement.executeUpdate();
        } catch (Exception e) {
            Files.deleteIfExists(target);
            throw new ServletException("Unable to save item.", e);
        }

        response.sendRedirect(
                request.getContextPath() + "/staff-dashboard?added=1");
    }
}
