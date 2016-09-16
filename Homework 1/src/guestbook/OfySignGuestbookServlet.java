// http://1-dot-ofyguestbook-142405.appspot.com/ofyguestbook.jsp

package guestbook;

import static com.googlecode.objectify.ObjectifyService.ofy;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class OfySignGuestbookServlet extends HttpServlet {

    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
        String guestbookName = req.getParameter("guestbookName");
        
        String content = req.getParameter("content");
        
        Greeting entity = new Greeting(user, content);
        
        ofy().save().entity(entity).now();
                
        resp.sendRedirect("/ofyguestbook.jsp?guestbookName=" + guestbookName);
    }
}
