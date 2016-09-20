<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Collections"%>
<%@ page import="blog.Blog"%>
<%@ page import="com.googlecode.objectify.*"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ page import="com.google.appengine.api.users.User"%>
<%@ page import="com.google.appengine.api.users.UserService"%>
<%@ page import="com.google.appengine.api.users.UserServiceFactory"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html>
<head>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
</head>
<body>
    <ul>
        <li><a href="home.jsp">Home</a></li>
        <li><a href="showAllPosts.jsp">All Posts</a></li>
    </ul>
    <%
        String blogName = request.getParameter("blogName");
        if (blogName == null) {
            blogName = "guest";
        }
        pageContext.setAttribute("blogName", blogName);
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        if (user != null) {
            pageContext.setAttribute("user", user);
    %>
    <a
        href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign
        out
    </a>
    <%
        } else {
    %>
    <p>
        Hello! <a
            href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign
            in</a> to include your name with greetings you post.
    </p>
    <%
        }
        ObjectifyService.register(Blog.class);
        List<Blog> greetings = ObjectifyService.ofy().load().type(Blog.class).list();
        Collections.sort(greetings);
        if (greetings.isEmpty()) {
    %>
    <p>Blog '${fn:escapeXml(blogName)}' has no messages.</p>
    <%
        } else {
    %>
    <p>Messages in Blog '${fn:escapeXml(blogName)}'.</p>
    <%
        for (Blog greeting : greetings) {
                pageContext.setAttribute("greeting_content",
                        greeting.getContent());
                pageContext.setAttribute("greeting_title", greeting.getTitle());
                if (greeting.getUser() == null) {
    %>
    <p>A visitor wrote:</p>
    <%
        } else {
                    pageContext.setAttribute("greeting_user",
                            greeting.getUser());
    %>
    <p>
        <b>${fn:escapeXml(greeting_user.nickname)}</b> wrote:
    </p>
    <%
        }
    %>
    <blockquote>${fn:escapeXml(greeting_title)}</blockquote>
    <br>
    <blockquote>${fn:escapeXml(greeting_content)}</blockquote>
    <%
        }
        }
    %>
</body>
</html>