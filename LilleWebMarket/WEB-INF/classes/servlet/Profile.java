package servlet;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import beans.User;

@WebServlet("/profile")
public class Profile extends HttpServlet
{
	public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		HttpSession session = req.getSession(true);
		res.setContentType("text/html");
		PrintWriter out = res.getWriter();

		User u = User.getUser("user1");
		out.println("ID : " + u.getId());
		out.println("Login : " + u.getLogin());
		out.println("Password : " + u.getPassword());
		out.println("Role : " + u.getRole());
		out.println("Money : " + u.getMoney());
		
		User u2 = User.getUser("admin1");
		out.println("ID : " + u2.getId());
		out.println("Login : " + u2.getLogin());
		out.println("Password : " + u2.getPassword());
		out.println("Role : " + u2.getRole());
		out.println("Money : " + u2.getMoney());
	}
}
