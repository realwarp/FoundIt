<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Login | FoundIt</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="auth-page">

<div class="auth-card">
    <a class="brand" href="index.jsp">FOUND<span>IT</span></a>

    <p class="eyebrow">STAFF ACCESS</p>
    <h1>Welcome back.</h1>
    <p class="muted">
        Sign in to add and manage items kept by the college office.
    </p>

    <% if ("credentials".equals(request.getParameter("error"))) { %>
        <div class="alert error">Incorrect username or password.</div>
    <% } else if ("invalid".equals(request.getParameter("error"))) { %>
        <div class="alert error">Please enter both fields.</div>
    <% } else if ("login".equals(request.getParameter("error"))) { %>
        <div class="alert error">Please log in to access the staff area.</div>
    <% } %>

    <form action="staff-login" method="post" class="form">
        <label for="username">Username</label>
        <input id="username" type="text" name="username" required>

        <label for="password">Password</label>
        <input id="password" type="password" name="password" required>

        <button class="btn btn-primary full" type="submit">Login</button>
    </form>

    <a class="back-link" href="index.jsp">&larr; Back to FoundIt</a>
</div>

</body>
</html>
