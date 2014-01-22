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

import beans.Market;
import dao.DAOFactory;
import dao.MarketDAO;

@WebServlet("/index")
public class Index extends HttpServlet
{
	
	//
	// ATTRIBUTES
	//
	private MarketDAO marketDao;
	
	
	
	//
	// METHODS
	//
	public void init() throws ServletException
	{
		this.marketDao = ((DAOFactory) (getServletContext().getAttribute("dao_factory"))).getMarketDAO();
	}
	
	public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		req.getSession(true);
		res.setContentType("text/html");
		PrintWriter out = res.getWriter();
		
		ArrayList<Market> markets = marketDao.getNextMarkets(5);
		
		out.println("<li>\n");
		
		for (Market m : markets)
		{
			out.println("<p>\n");
			out.println("	<strong>Marché:</strong><br />\n");
			out.println("	" + m.getInfo() + "<br />\n");
			out.println("	<strong>Date fin:</strong><br />\n");
			out.println("	" + m.getEnd_date() + "<br />\n");
			out.println("</p>\n");
			out.println("\n");
		}
		
		out.println("</li>\n");
	}
}
