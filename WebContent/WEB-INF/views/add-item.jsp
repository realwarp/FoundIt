<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Item | FoundIt</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body class="app-page">

<header class="navbar">
    <a class="brand" href="<%=request.getContextPath()%>/staff-dashboard">
        FOUND<span>IT</span>
    </a>
    <nav>
        <a class="nav-link" href="<%=request.getContextPath()%>/staff-dashboard">Dashboard</a>
        <a class="nav-link danger-link" href="<%=request.getContextPath()%>/staff-logout">Logout</a>
    </nav>
</header>

<main class="page-shell narrow">
    <section class="page-heading">
        <p class="eyebrow">NEW ITEM</p>
        <h1>Add a lost item</h1>
        <p class="muted">Record the item exactly as it was handed over.</p>
    </section>

    <% if ("invalid".equals(request.getParameter("error"))) { %>
        <div class="alert error">Please complete every field.</div>
    <% } else if ("image".equals(request.getParameter("error"))) { %>
        <div class="alert error">Please upload an image file.</div>
    <% } %>

    <form action="<%=request.getContextPath()%>/add-item"
          method="post"
          enctype="multipart/form-data"
          class="panel form">

        <label for="itemName">Item name</label>
        <input id="itemName" type="text" name="itemName"
               maxlength="150" placeholder="e.g. Black wallet" required>

        <label for="photo">Photo</label>
        <input id="photo" type="file" name="photo"
               accept="image/*" required>

        <label for="foundLocation">Where was it found?</label>
        <input id="foundLocation" type="text" name="foundLocation"
               maxlength="150" placeholder="e.g. Lab 2" required>

        <label for="givenBy">Given by</label>
        <input id="givenBy" type="text" name="givenBy"
               maxlength="100" placeholder="e.g. Rohan Patil" required>

        <label for="dateFound">Date found</label>
        <input id="dateFound" type="date" name="dateFound" required>

        <div class="form-actions">
            <a class="btn btn-secondary"
               href="<%=request.getContextPath()%>/staff-dashboard">
                Cancel
            </a>
            <button class="btn btn-primary" type="submit">
                Add Item
            </button>
        </div>
    </form>
</main>

</body>
</html>
