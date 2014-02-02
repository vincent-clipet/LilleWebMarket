package servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;


import dao.MarketDAO;
import dao.DAOFactory;
import beans.Market;
import beans.Sell;
import java.util.ArrayList;

// import ;
// import ;

@WebServlet("/market")
    public class MarketServlet extends HttpServlet
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
	    //	    HttpSession session = req.getSession(true);
	    res.setContentType("text/html");
	    PrintWriter out = res.getWriter();

	    beans.Market m = (Market) (req.getAttribute("marketBean"));
	    boolean opposite = false;
	    int marketId = 0;

	    try {opposite = Boolean.parseBoolean(req.getParameter("opposite"));}
	    catch (Exception e) {}
	    
	    try {marketId = Integer.parseInt(req.getParameter("id"));}
	    catch (Exception e) {}

	    if (m == null)
		{
		    m = new Market();
		}
	    marketDao.getMarket(marketId, m);
	
	    ArrayList<Sell> asks = marketDao.getAsks(marketId, opposite);
	    ArrayList<Sell> bids = marketDao.getBids(marketId, opposite);

	    req.setAttribute("marketBean", m);
	    req.setAttribute("marketId", marketId);
	    req.setAttribute("opposite", opposite);
	    req.setAttribute("asks", asks);
	    req.setAttribute("bids", bids);

	    out.println("###### MARKET_ID ##########" + req.getAttribute("marketId"));

	    RequestDispatcher dispatcher = req.getRequestDispatcher("market.jsp");
	    dispatcher.forward(req, res);
	}
    }