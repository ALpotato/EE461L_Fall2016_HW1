<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link type="text/css" rel="stylesheet" href="/stylesheets/main.css" />
</head>
<body>
    <div id="container">
        <div id="banner">
            <h1 class="title-text">Welcome to Blog created by
                EE461L Fall 2016 Homework 1 Group 24!</h1>
            <blockquote>Hi ${user.nickname}!</blockquote>
        </div>
        <br />
        <div id="sidebar">
            <div class="menu">
                <ul>
                    <li class="links">Navigate</li>
                    <li><a href="/">Home</a></li>
                    <li><a href="/?=all">All Posts</a></li>
                    <li><c:choose>
                            <c:when test="${not empty logOutUrl}">
                                <a href="${logOutUrl}">Log out</a>
                            </c:when>
                            <c:otherwise>
                                <a href="${logInUrl}">Log in</a>
                            </c:otherwise>
                        </c:choose></li>
                    <%-- <li>
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
                        value="${blogName}" />
                </form>
                </li> --%>
                </ul>
            </div>
        </div>
        <br />
        <div id="content">
            <c:choose>
                <c:when test="${empty blogs}">
                    <h1>Blog '${blogName}' has no messages.</h1>
                </c:when>
                <c:otherwise>
                    <h1>Messages in Blog '${blogName}':</h1>
                    <c:choose>
                        <c:when test="${5 gt fn:length(blogs)}">
                            <c:forEach items="${blogs}" var="blog">
                                <c:choose>
                                    <c:when
                                        test="${not empty blog.user}">
                                        <h3>
                                            <b>${blog.user.nickname}></b>
                                            wrote:
                                        </h3>
                                    </c:when>
                                    <c:otherwise>
                                        <h3>A visitor wrote:</h3>
                                    </c:otherwise>
                                </c:choose>
                                <div id="box">
                                <blockquote>${blog.title}</blockquote>
                                <br />
                                <p>${blog.content}</p>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <h2>To see older posts, click "All Posts" in the navigation side bar</h2>
                            <c:forEach var="i" begin="0" end="4">
                                <c:choose>
                                    <c:when
                                        test="${not empty blogs[i].user}">
                                        <h3>
                                            <b>${blogs[i].user.nickname}</b>
                                            wrote:
                                        </h3>
                                    </c:when>
                                    <c:otherwise>
                                        <h3>A visitor wrote:</h3>
                                    </c:otherwise>
                                </c:choose>
                                <blockquote>${blogs[i].title}</blockquote>
                                <br />
                                <p>${blogs[i].content}</p>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </c:otherwise>
            </c:choose>
            <form action="/" method="post">
                <textarea name="title" rows="1" cols="60"
                    placeholder="Insert title here"></textarea>
                <br />
                <div>
                    <textarea name="content" rows="3" cols="60"
                        placeholder="Insert content here"></textarea>
                </div>
                <div>
                    <input type="submit" value="Post Blog" />
                </div>
                <input type="hidden" name="blogName"
                    value="${blogName}" />
            </form>
        </div>
    </div>
    <br />
    <div class="clear"></div>
</body>
</html>