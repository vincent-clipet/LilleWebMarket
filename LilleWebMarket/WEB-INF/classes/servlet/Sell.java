package servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/sell")
public class Sell extends HttpServlet
{
	
	//
	// ATTRIBUTES
	//
	
	
	
	//
	// METHODS
	//
	public void init() throws ServletException
	{
		
	}
	
	public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		req.getSession(true);
		res.setContentType("text/html");
		PrintWriter out = res.getWriter();
		
		
	}
}
