package blog;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

@SuppressWarnings("serial")
public class HomeServlet extends HttpServlet {
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String blogName = req.getParameter("blogName");
        if (blogName == null) {
            blogName = "EE461L Fall 2016 Homework 1 Group 24";
        }
        req.setAttribute("blogName", blogName);
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        req.setAttribute("user", user);
        ObjectifyService.register(Blog.class);
        List<Blog> blogs = ObjectifyService.ofy().load().type(Blog.class).list();
        Collections.sort(blogs);
        req.setAttribute("blogs", blogs);
    }
}
