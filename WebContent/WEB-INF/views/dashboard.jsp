<%@ page import="java.util.List,java.util.Collections,com.foundit.model.Item,com.foundit.util.HtmlUtil" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    List<Item> items = (List<Item>) request.getAttribute("items");
    if (items == null) items = Collections.emptyList();
    Integer userId = (Integer) session.getAttribute("userId");
    String filter = (String) request.getAttribute("filter");
    if (filter == null) filter = "ALL";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | FoundIt</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/style.css">
</head>
<body class="app-page">
<header class="topbar">
    <a class="brand" href="<%=request.getContextPath()%>/dashboard">FoundIt</a>
    <nav>
        <a href="<%=request.getContextPath()%>/dashboard">Dashboard</a>
        <a href="<%=request.getContextPath()%>/report-item">Report item</a>
        <a href="<%=request.getContextPath()%>/logout">Logout</a>
    </nav>
</header>
<main class="shell">
    <section class="page-heading">
        <span class="eyebrow">DASHBOARD</span>
        <h1>Hello, <%=HtmlUtil.escape(String.valueOf(session.getAttribute("userName")))%></h1>
        <p class="muted">Browse active campus posts and help reunite people with their things.</p>
    </section>

    <% if ("1".equals(request.getParameter("created"))) { %>
        <div class="alert success">Your post is live.</div>
    <% } else if ("1".equals(request.getParameter("updated"))) { %>
        <div class="alert success">The item was marked as returned.</div>
    <% } else if ("invalid".equals(request.getParameter("error"))) { %>
        <div class="alert error">Invalid request.</div>
    <% } %>

    <section class="stats">
        <div class="stat"><span>Total</span><strong><%=request.getAttribute("total")%></strong></div>
        <div class="stat"><span>Lost</span><strong><%=request.getAttribute("lost")%></strong></div>
        <div class="stat"><span>Found</span><strong><%=request.getAttribute("found")%></strong></div>
        <div class="stat"><span>Returned</span><strong><%=request.getAttribute("returned")%></strong></div>
    </section>

    <div class="toolbar">
        <div class="filters">
            <a class="chip <%= "ALL".equals(filter) ? "active" : "" %>" href="<%=request.getContextPath()%>/dashboard">All</a>
            <a class="chip <%= "LOST".equals(filter) ? "active" : "" %>" href="<%=request.getContextPath()%>/dashboard?type=LOST">Lost</a>
            <a class="chip <%= "FOUND".equals(filter) ? "active" : "" %>" href="<%=request.getContextPath()%>/dashboard?type=FOUND">Found</a>
        </div>
        <a class="btn btn-primary" href="<%=request.getContextPath()%>/report-item">+ Report item</a>
    </div>

    <section class="items">
        <% if (items.isEmpty()) { %>
            <div class="empty panel">
                <h2>No active posts yet</h2>
                <p class="muted">Be the first to report a lost or found item.</p>
            </div>
        <% } %>

        <% for (Item item : items) { %>
            <article class="item-card <%= item.getItemType().toLowerCase() %>">
                <div class="item-top">
                    <span class="tag"><%=HtmlUtil.escape(item.getItemType())%></span>
                    <span class="date"><%=HtmlUtil.escape(item.getCreatedAt())%></span>
                </div>
                <h2><%=HtmlUtil.escape(item.getTitle())%></h2>
                <p><%=HtmlUtil.escape(item.getDescription())%></p>

                <dl>
                    <div><dt>Location</dt><dd><%=HtmlUtil.escape(item.getLocation())%></dd></div>
                    <div><dt>Contact</dt><dd><%=HtmlUtil.escape(item.getContact())%></dd></div>
                    <div><dt>Posted by</dt><dd><%=HtmlUtil.escape(item.getUserName())%></dd></div>
                </dl>

                <% if (userId != null && userId.intValue() == item.getUserId()) { %>
                    <form action="<%=request.getContextPath()%>/mark-returned" method="post">
                        <input type="hidden" name="id" value="<%=item.getId()%>">
                        <button class="btn btn-secondary" type="submit">Mark as returned</button>
                    </form>
                <% } %>
            </article>
        <% } %>
    </section>
</main>
</body>
</html>