package blog;

import java.util.Date;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class Blog implements Comparable<Blog> {

    @Id
    Long id;
    User user;
    String content;
    String title;
    Date date;

    @SuppressWarnings("unused")
    private Blog() {
    }

    public Blog(User user, String content, String title) {
        this.user = user;
        this.content = content;
        this.title = title;
        date = new Date();
    }

    public User getUser() {
        return user;
    }

    public String getContent() {
        return content;
    }

    public String getTitle() {
        return title;
    }

    @Override
    public int compareTo(Blog other) {
        if (date.after(other.date)) {
            return 1;
        } else if (date.before(other.date)) {
            return -1;
        }
        return 0;
    }
}
