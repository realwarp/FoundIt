<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Report item | FoundIt</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body class="app-page">
<header class="topbar">
    <a class="brand" href="<%=request.getContextPath()%>/dashboard">FoundIt</a>
    <nav>
        <a href="<%=request.getContextPath()%>/dashboard">Dashboard</a>
        <a href="<%=request.getContextPath()%>/logout">Logout</a>
    </nav>
</header>

<main class="shell narrow">
    <section class="page-heading">
        <span class="eyebrow">NEW POST</span>
        <h1>Report an item</h1>
        <p class="muted">Add the details that can help someone identify it.</p>
    </section>

    <% if ("invalid".equals(request.getParameter("error"))) { %>
        <div class="alert error">Please fill in all required fields.</div>
    <% } %>

    <form action="<%=request.getContextPath()%>/create-item" method="post"
          class="panel form" onsubmit="return validateItemForm()">

        <label>Item name</label>
        <input id="itemTitle" type="text" name="title" maxlength="150" required
               placeholder="e.g. Black scientific calculator">

        <label>Post type</label>
        <select id="itemType" name="itemType" required>
            <option value="">Select one</option>
            <option value="LOST">I lost this</option>
            <option value="FOUND">I found this</option>
        </select>

        <label>Location</label>
        <input id="itemLocation" type="text" name="location" maxlength="150" required
               placeholder="e.g. Lab 3">

        <label>Description</label>
        <textarea name="description" rows="5" maxlength="1000"
                  placeholder="Colour, brand, identifying marks..."></textarea>

        <label>Contact</label>
        <input id="itemContact" type="text" name="contact" maxlength="150" required
               placeholder="Email or phone">

        <div class="actions">
            <a class="btn btn-secondary" href="<%=request.getContextPath()%>/dashboard">Cancel</a>
            <button class="btn btn-primary" type="submit">Publish post</button>
        </div>
    </form>
</main>
<script src="<%=request.getContextPath()%>/js/app.js"></script>
</body>
</html>
