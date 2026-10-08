<%@ page import="java.util.List,java.util.Collections,com.foundit.model.Item" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<Item> items = (List<Item>) request.getAttribute("items");
    if (items == null) items = Collections.emptyList();

    String search = (String) request.getAttribute("search");
    if (search == null) search = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Available Items | FoundIt</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body class="app-page">

<header class="navbar">
    <a class="brand" href="<%=request.getContextPath()%>/index.jsp">
        FOUND<span>IT</span>
    </a>

    <nav>
        <a class="nav-link" href="<%=request.getContextPath()%>/guest-items">Available Items</a>
        <a class="nav-link" href="<%=request.getContextPath()%>/index.jsp">Home</a>
    </nav>
</header>

<main class="page-shell">
    <section class="page-heading center-heading">
        <p class="eyebrow">GUEST ACCESS</p>
        <h1>Available Items</h1>
        <p class="muted">
            Items currently kept by the college office.
        </p>
    </section>

    <form class="search-bar" method="get"
          action="<%=request.getContextPath()%>/guest-items">
        <input type="search" name="search"
               value="<%=search%>"
               placeholder="Search item name...">
        <button class="btn btn-primary" type="submit">Search</button>
    </form>

    <section class="item-grid">
        <% if (items.isEmpty()) { %>
            <div class="empty panel">
                <h3>No matching items</h3>
                <p class="muted">
                    Try another name or check again later.
                </p>
            </div>
        <% } %>

        <% for (Item item : items) { %>
            <article class="item-card">
                <div class="photo-wrap">
                    <img src="<%=request.getContextPath()%>/uploads/<%=item.getPhoto()%>"
                         alt="Photo of <%=item.getItemName()%>">
                    <span class="badge available">Available</span>
                </div>

                <div class="item-card-body">
                    <h2><%=item.getItemName()%></h2>

                    <p class="item-detail">
                        <span>Found at</span>
                        <strong><%=item.getFoundLocation()%></strong>
                    </p>

                    <p class="item-detail">
                        <span>Date</span>
                        <strong><%=item.getDateFound()%></strong>
                    </p>

                    <p class="card-note">
                        If this is yours, please visit the college office to collect it.
                    </p>
                </div>
            </article>
        <% } %>
    </section>
</main>

</body>
</html>
