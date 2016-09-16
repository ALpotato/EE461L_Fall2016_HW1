<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%@ page import="java.util.List"%>

<%@ page import="java.util.Collections"%>

<%@ page import="guestbook.Greeting"%>

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
		<li><a href="ofyguestbook.jsp">Home</a></li>
		<li><a href="showAllPosts.jsp">All Posts</a></li>
	</ul>

	<%

    String guestbookName = request.getParameter("guestbookName");

    if (guestbookName == null) {

        guestbookName = "guest";

    }

    pageContext.setAttribute("guestbookName", guestbookName);

    UserService userService = UserServiceFactory.getUserService();

    User user = userService.getCurrentUser();

    if (user != null) {

      pageContext.setAttribute("user", user);

%>


	<p>
		Hello, ${fn:escapeXml(user.nickname)}! (You can <a
			href="<%= userService.createLogoutURL(request.getRequestURI()) %>">sign
			out</a>.)
	</p>
	<form action="/cronjob" method="post">
		<%
			if (guestbook.CronServlet.subscribedUsers.contains(user)) {
		%>
		<div>
			<input type="submit" class="submitlink" value="Unsubscribe" />
		</div>
		<%
			} else {
		%>
		<div>
			<input type="submit" class="submitlink" value="Subscribe" />
		</div>
		<%
			}
		%>
		<input type="hidden" name="userName" value="${fn:escapeXml(userName)}" />
	</form>

	<%
		} else {
	%>

	<p>
		Hello! <a
			href="<%= userService.createLoginURL(request.getRequestURI()) %>">Sign
			in</a> to include your name with greetings you post.
	</p>

	<%

    }

%>



	<%

	ObjectifyService.register(Greeting.class);
	
	List<Greeting> greetings = ObjectifyService.ofy().load().type(Greeting.class).list();   
	
	Collections.sort(greetings);

    if (greetings.isEmpty()) {

        %>

	<p>Guestbook '${fn:escapeXml(guestbookName)}' has no messages.</p>

	<%

    } else {

        %>

	<p>Messages in Guestbook '${fn:escapeXml(guestbookName)}'.</p>

	<%

        for (int i = 0; i < 5; i += 1) {
			Greeting greeting = greetings.get(greetings.size() - i - 1);
            pageContext.setAttribute("greeting_content",

                                     greeting.getContent());
            
            pageContext.setAttribute("greeting_title", greeting.getTitle());

            if (greeting.getUser() == null) {

                %>

	<p>Random person wrote:</p>

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

	<% if(user != null){ %>

	<form action="/ofysign" method="post">

		<textarea name="title" rows="1" cols="60"></textarea>
		<br>

		<div>
			<textarea name="content" rows="3" cols="60"></textarea>
		</div>

		<div>

			<input type="submit" value="Post Greeting" />
		</div>

		<input type="hidden" name="guestbookName"
			value="${fn:escapeXml(guestbookName)}" />

	</form>

	<% } %>

</body>

</html>