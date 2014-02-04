package servlet;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.RequestDispatcher;

import beans.Market;
import dao.DAOFactory;
import dao.MarketDAO;

@WebServlet("/disconnect")
public class Disconnect extends HttpServlet
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
		res.setContentType("text/html");
		HttpSession session = req.getSession(true);
		
		session.invalidate();

		RequestDispatcher dispatcher = req.getRequestDispatcher("index");
		dispatcher.forward(req, res);
	}
}
