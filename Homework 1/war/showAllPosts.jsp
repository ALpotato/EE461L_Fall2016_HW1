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
                </ul>
            </div>
        </div>

        <div id="content">
            <c:choose>
                <c:when test="${empty blogs}">
                    <h1>Blog '${blogName}' has no messages.</h1>
                </c:when>
                <c:otherwise>
                    <h1>ALL Messages in Blog '${blogName}':</h1>
                    <c:forEach items="${blogs}" var="blog">
                        <c:choose>
                            <c:when test="${not empty blog.user}">
                                <h3>
                                    <b>${blog.user.nickname}</b> wrote:
                                </h3>
                            </c:when>
                            <c:otherwise>
                                <h3>A visitor wrote:</h3>
                            </c:otherwise>
                        </c:choose>
                        <blockquote>${blog.title}</blockquote>
                        <br />
                        <p>${blog.content}</p>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <div class="clear"></div>
</body>