package servlet;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.User;
import dao.DAOFactory;
import dao.UserDAO;

@WebServlet("/profile")
public class Profile extends HttpServlet
{
	
	//
	// ATTRIBUTES
	//
	private UserDAO userDao;
	
	
	
	//
	// METHODS
	//
	public void init() throws ServletException
	{
		this.userDao = ((DAOFactory) (getServletContext().getAttribute("dao_factory"))).getUserDAO();
	}
	
	public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		req.getSession(true);
		res.setContentType("text/html");
		PrintWriter out = res.getWriter();

		User u = this.userDao.getUser("user1");
		out.println("ID : " + u.getId() + "\n");
		out.println("Login : " + u.getLogin() + "\n");
		out.println("Password : " + u.getPassword() + "\n");
		out.println("Money : " + u.getMoney() + "\n");
		out.println("\n\n");
		
		User u2 = this.userDao.getUser("admin1");
		out.println("ID : " + u2.getId() + "\n");
		out.println("Login : " + u2.getLogin() + "\n");
		out.println("Password : " + u2.getPassword() + "\n");
		out.println("Money : " + u2.getMoney() + "\n");
	}
}
