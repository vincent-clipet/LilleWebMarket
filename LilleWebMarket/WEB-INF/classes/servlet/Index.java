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
		res.setContentType("text/html");
		PrintWriter out = res.getWriter();
		HttpSession session = req.getSession(true);
		
		ArrayList<Market> markets = marketDao.getNextMarkets(-1);
		req.setAttribute("markets", markets);
		
		RequestDispatcher dispatcher = req.getRequestDispatcher("index.jsp");
		dispatcher.forward(req, res);
	}
}
