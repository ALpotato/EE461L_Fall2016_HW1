package blog;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Properties;
import java.util.logging.Logger;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

@SuppressWarnings("serial")
public class CronServlet extends HttpServlet {
    //FIXME:logger probably not needed
    private static final Logger _logger = Logger.getLogger(CronServlet.class.getName());
    public static ArrayList<User> subscribed = new ArrayList<User>();
    public static ArrayList<String> posts = new ArrayList<String>();
    public static ArrayList<String> users = new ArrayList<String>();

    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        String blogName = req.getParameter("blogName");

        if (subscribed.contains(user)) {
            subscribed.remove(user);
        } else {
            subscribed.add(user);
        }
        resp.sendRedirect("/home.jsp?blogName=" + blogName);
    }

    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        _logger.info("trigged doGet method for cron services");
        String blogName = req.getParameter("blogName");
        //FIXME: change the email account address
        String fromWhom = "admin@random-thoughts8.appspotmail.com";

        // Get system properties
        Properties properties = new Properties();
        Session session = Session.getDefaultInstance(properties, null);

        for (int i = 0; i < subscribed.size(); i += 1) {
            String toWhom = subscribed.get(i).getEmail();
            _logger.info(toWhom);
            try {
                String blogUpdateMessage = "Daily update for the Group 24 Blog: \n\n";
                MimeMessage mimeMessage = new MimeMessage(session);
                mimeMessage.setFrom(new InternetAddress(fromWhom));
                mimeMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(toWhom));
                mimeMessage.setSubject("Blog Updates from Group 24 Blog");
                if (posts.size() == 0) {
                    blogUpdateMessage = "No new posts since last update";
                } else {
                    for (int j = 0; j < posts.size(); j += 1) {
                        blogUpdateMessage += users.get(j);
                        blogUpdateMessage += "  wrote: \n";
                        blogUpdateMessage += posts.get(j);
                        blogUpdateMessage += "\n";
                    }
                }
                mimeMessage.setText(blogUpdateMessage);
                Transport.send(mimeMessage);
                _logger.info("Cron executed");
            } catch (MessagingException messagingException) {
                _logger.info("Cron not executed");
                messagingException.printStackTrace();
            }
        }
        posts.clear();
        resp.sendRedirect("/home.jsp?blogName=" + blogName);
    }
}
