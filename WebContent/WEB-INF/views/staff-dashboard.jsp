<%@ page import="java.util.List,java.util.Collections,com.foundit.model.Item" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    List<Item> items = (List<Item>) request.getAttribute("items");
    if (items == null) items = Collections.emptyList();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard | FoundIt</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body class="app-page">

<header class="navbar">
    <a class="brand" href="<%=request.getContextPath()%>/staff-dashboard">
        FOUND<span>IT</span>
    </a>

    <nav>
        <span class="nav-user">
            Staff: <%=request.getSession().getAttribute("staffUser")%>
        </span>
        <a class="nav-link danger-link"
           href="<%=request.getContextPath()%>/staff-logout">
            Logout
        </a>
    </nav>
</header>

<main class="page-shell">
    <section class="page-heading row-heading">
        <div>
            <p class="eyebrow">STAFF DASHBOARD</p>
            <h1>Lost &amp; Found Register</h1>
            <p class="muted">
                Manage items currently kept by the college office.
            </p>
        </div>

        <a class="btn btn-primary"
           href="<%=request.getContextPath()%>/add-item">
            + Add Lost Item
        </a>
    </section>

    <% if ("1".equals(request.getParameter("added"))) { %>
        <div class="alert success">Item added successfully.</div>
    <% } else if ("1".equals(request.getParameter("updated"))) { %>
        <div class="alert success">Item marked as collected.</div>
    <% } else if ("invalid".equals(request.getParameter("error"))) { %>
        <div class="alert error">Invalid item request.</div>
    <% } %>

    <section class="stats">
        <div class="stat">
            <span>Available</span>
            <strong><%=request.getAttribute("available")%></strong>
        </div>

        <div class="stat">
            <span>Added Today</span>
            <strong><%=request.getAttribute("addedToday")%></strong>
        </div>

        <div class="stat">
            <span>Collected</span>
            <strong><%=request.getAttribute("collected")%></strong>
        </div>
    </section>

    <section class="panel-section">
        <div class="section-title">
            <div>
                <h2>All Items</h2>
                <p class="muted">Latest items are shown first.</p>
            </div>
        </div>

        <div class="staff-list">
            <% if (items.isEmpty()) { %>
                <div class="empty panel">
                    <h3>No items recorded</h3>
                    <p class="muted">Use Add Lost Item to create the first record.</p>
                </div>
            <% } %>

            <% for (Item item : items) { %>
                <article class="staff-item">
                    <img class="staff-thumb"
                         src="<%=request.getContextPath()%>/uploads/<%=item.getPhoto()%>"
                         alt="Photo of <%=item.getItemName()%>">

                    <div class="staff-item-info">
                        <div class="item-header">
                            <h3><%=item.getItemName()%></h3>

                            <% if ("AVAILABLE".equals(item.getStatus())) { %>
                                <span class="badge available">Available</span>
                            <% } else { %>
                                <span class="badge collected">Collected</span>
                            <% } %>
                        </div>

                        <p>Found at: <strong><%=item.getFoundLocation()%></strong></p>
                        <p>Given by: <strong><%=item.getGivenBy()%></strong></p>
                        <p>Date: <strong><%=item.getDateFound()%></strong></p>
                    </div>

                    <div class="staff-item-action">
                        <% if ("AVAILABLE".equals(item.getStatus())) { %>
                            <form action="<%=request.getContextPath()%>/collect-item" method="post">
                                <input type="hidden" name="id" value="<%=item.getId()%>">
                                <button class="btn btn-secondary" type="submit">
                                    Mark as Collected
                                </button>
                            </form>
                        <% } %>
                    </div>
                </article>
            <% } %>
        </div>
    </section>
</main>

</body>
</html>
