package blog;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

@SuppressWarnings("serial")
public class HomeServlet extends HttpServlet {
    static {
        ObjectifyService.register(Blog.class);
    }

    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String blogName = req.getParameter("blogName");
        if (blogName == null) {
            blogName = "EE461L Fall 2016 Homework 1 Group 24";
        }
        req.setAttribute("blogName", blogName);
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        req.setAttribute("user", user);
        if (user == null) {
            req.setAttribute("logInUrl", userService.createLoginURL(req.getRequestURI()));
        } else {
            req.setAttribute("logOutUrl", userService.createLogoutURL(req.getRequestURI()));
        }
        List<Blog> blogs = ObjectifyService.ofy().load().type(Blog.class).list();
        Collections.sort(blogs);
        req.setAttribute("blogs", blogs);
        if(req.getQueryString() == null || req.getQueryString().isEmpty()) {
            req.getRequestDispatcher("home.jsp").forward(req, resp);
        }
        else {
            req.getRequestDispatcher("showAllPosts.jsp").forward(req, resp);
        }
    }
    
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        req.setAttribute("user", user);
        if (user == null) {
            req.setAttribute("logInUrl", userService.createLoginURL(req.getRequestURI()));
        } else {
            req.setAttribute("logOutUrl", userService.createLogoutURL(req.getRequestURI()));
        }
        String content = req.getParameter("content");
        String title = req.getParameter("title");
        req.setAttribute("blogName", req.getParameter("blogName"));
        Blog entity = new Blog(user, content, title);
        ofy().save().entity(entity).now();
        List<Blog> blogs = ObjectifyService.ofy().load().type(Blog.class).list();
        Collections.sort(blogs);
        req.setAttribute("blogs", blogs);
        req.getRequestDispatcher("home.jsp").forward(req, resp);
    }
}
