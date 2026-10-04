<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create account | FoundIt</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body class="auth-page">
<div class="auth-card">
    <a class="brand" href="index.jsp">FoundIt</a>
    <h1>Create account</h1>
    <p class="muted">Use your college account details.</p>

    <% if ("exists".equals(request.getParameter("error"))) { %>
        <div class="alert error">That email is already registered.</div>
    <% } else if ("invalid".equals(request.getParameter("error"))) { %>
        <div class="alert error">Use a name, valid email and a password of at least 6 characters.</div>
    <% } %>

    <form action="register" method="post" class="form" onsubmit="return validateRegister()">
        <label>Name</label>
        <input id="registerName" type="text" name="name" required maxlength="100">

        <label>Email</label>
        <input id="registerEmail" type="email" name="email" required maxlength="150">

        <label>Password</label>
        <input id="registerPassword" type="password" name="password" required minlength="6">

        <button class="btn btn-primary full" type="submit">Create account</button>
    </form>

    <p class="foot-link">Already have an account? <a href="login.jsp">Sign in</a></p>
</div>
<script src="js/app.js"></script>
</body>
</html>
