package servlet;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/disconnect")
public class Disconnect extends CustomHttpServlet
{

	//
	// METHODS
	//
	public void init() throws ServletException
	{

	}

	public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		super.initInstance(req, res);

		session.removeAttribute("userBean");
		session.invalidate();

		res.sendRedirect("index");
	}
}
