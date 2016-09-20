package blog;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class SignBlogServlet extends HttpServlet {
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        String blogName = req.getParameter("blogName");
        String content = req.getParameter("content");
        String title = req.getParameter("title");
        Blog entity = new Blog(user, content, title);
        ofy().save().entity(entity).now();
        resp.sendRedirect("/home.jsp?blogName=" + blogName);
    }
}
