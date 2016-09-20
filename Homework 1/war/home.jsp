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
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
</head>
<%
    String blogName = request.getParameter("blogName");
    if (blogName == null) {
        blogName = "EE461L Fall 2016 Homework 1 Group 24";
    }
    pageContext.setAttribute("blogName", blogName);
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();

    ObjectifyService.register(Blog.class);
    List<Blog> blogs = ObjectifyService.ofy().load().type(Blog.class).list();
    Collections.sort(blogs);
%>
<body>
    <div id="container">
        <div id="bannaer">
            <h1 class="title-text">Welcome to Blog created by EE461L Fall 2016 Homework 1 Group 24!</h1>
        </div>
    </div>
    <div id="content">
    <%
        if (user != null) {
            pageContext.setAttribute("user", user);
    %>
    <p>
        Hello, ${fn:escapeXml(user.nickname)}! (You can <a
            href="<%=userService.createLogoutURL(request.getRequestURI())%>">sign
            out</a>.)
    </p>
    <%
        } else {
    %>
    <p>
        Hello! <a
            href="<%=userService.createLoginURL(request.getRequestURI())%>">Sign
            in</a> to include your name with blogs you post.
    </p>
    <%
        }
        if (blogs.isEmpty()) {
    %>
    <p>Blog '${fn:escapeXml(blogName)}' has no messages.</p>
    <%
        } else {
    %>
    <p>Messages in Blog '${fn:escapeXml(blogName)}'.</p>
    <%
        for (int i = 0; i < 5; i += 1) {
            if(blogs.size() == i){
                break;
            }
            Blog blog = blogs.get(blogs.size() - i - 1);
            pageContext.setAttribute("blog_content", blog.getContent());
            pageContext.setAttribute("blog_title", blog.getTitle());
            if (blog.getUser() == null) {
    %>
    <p>Random person wrote:</p>
    <%
            } else {
                pageContext.setAttribute("blog_user", blog.getUser());
    %>
    <p>
        <b>${fn:escapeXml(blog_user.nickname)}</b> wrote:
    </p>
    <%
            }
    %>
    <blockquote>${fn:escapeXml(blog_title)}</blockquote>
    <br>
    <blockquote>${fn:escapeXml(blog_content)}</blockquote>
    <%
        }
        }
        if (user != null) {
    %>
    
    <form action="/ofysign" method="post">
        <textarea name="title" rows="1" cols="60" placeholder="Insert title here"></textarea>
        <br>
        <div>
            <textarea name="content" rows="3" cols="60" placeholder="Insert content here"></textarea>
        </div>
        <div>
            <input type="submit" value="Post Blog" />
        </div>
        <input type="hidden" name="blogName"
            value="${fn:escapeXml(blogName)}" />
    </form>
    <% } %>
    </div>
    <div id="sidebar">
        <ul>
            <li class="links">Navigate</li>
            <li><a href="home.jsp">Home</a></li>
            <li><a href="showAllPosts.jsp">All Posts</a></li>
            <li>
                <form action="/cron/mycronjob" method="post">
                    <%
                        if (blog.CronServlet.subscribed.contains(user)) {
                    %>
                    <div>
                        <input type="submit" class="submitlink"
                            value="Unsubscribe" />
                    </div>
                    <%
                        } else {
                    %>
                    <div>
                        <input type="submit" class="submitlink"
                            value="Subscribe" />
                    </div>
                    <%
                        }
                    %>
                    <input type="hidden" name="blogName"
                        value="${fn:escapeXml(blogName)}" />
                </form>
            </li>
        </ul>
    </div>
</body>
</html>