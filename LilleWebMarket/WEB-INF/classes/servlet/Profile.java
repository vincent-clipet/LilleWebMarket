package servlet;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.RequestDispatcher;

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
		HttpSession session = req.getSession(true);
		
		User u = (User) (session.getAttribute("userBean"));
		
		if (u == null)
		{
			u = new User();
			userDao.getUser(req.getUserPrincipal().getName(), u);
			session.setAttribute("userBean", u);
		}
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("profile.jsp");
dispatcher.forward(req, res);
	}
}
