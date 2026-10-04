<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | FoundIt</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="auth-page">
<div class="auth-card">
    <a class="brand" href="index.jsp">FoundIt</a>
    <h1>Welcome back</h1>
    <p class="muted">Sign in to manage your lost and found posts.</p>

    <% if ("credentials".equals(request.getParameter("error"))) { %>
        <div class="alert error">Invalid email or password.</div>
    <% } else if ("invalid".equals(request.getParameter("error"))) { %>
        <div class="alert error">Please fill in both fields.</div>
    <% } else if ("login".equals(request.getParameter("error"))) { %>
        <div class="alert error">Please log in first.</div>
    <% } else if ("1".equals(request.getParameter("registered"))) { %>
        <div class="alert success">Account created. You can log in now.</div>
    <% } else if ("1".equals(request.getParameter("logout"))) { %>
        <div class="alert success">You have been logged out.</div>
    <% } %>

    <form action="login" method="post" class="form" onsubmit="return validateLogin()">
        <label>Email</label>
        <input id="loginEmail" type="email" name="email" required maxlength="150">

        <label>Password</label>
        <input id="loginPassword" type="password" name="password" required minlength="6">

        <button class="btn btn-primary full" type="submit">Sign in</button>
    </form>

    <p class="foot-link">New here? <a href="register.jsp">Create an account</a></p>
</div>
<script src="js/app.js"></script>
</body>
</html>
