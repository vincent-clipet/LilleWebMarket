package servlet;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.Market;
import beans.Sell;

// import ;
// import ;

@WebServlet("/market")
public class MarketServlet extends CustomHttpServlet
{

	//
	// METHODS
	//
	public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		super.initInstance(req, res);
		super.storeUser();

		beans.Market m = (Market) (req.getAttribute("marketBean"));
		boolean opposite = false;
		int marketId = 0;

		try {opposite = Boolean.parseBoolean(req.getParameter("opposite"));}
		catch (Exception e) {}

		try {marketId = Integer.parseInt(req.getParameter("id"));}
		catch (Exception e) {}

		if (m == null)
			m = new Market();
		
		marketDao.getMarket(marketId, m);

		ArrayList<Sell> asks = marketDao.getAsks(marketId, opposite);
		ArrayList<Sell> bids = marketDao.getBids(marketId, opposite);

		req.setAttribute("marketBean", m);
		req.setAttribute("marketId", marketId);
		req.setAttribute("opposite", opposite);
		req.setAttribute("asks", asks);
		req.setAttribute("bids", bids);

		out.println("###### MARKET_ID ##########" + req.getAttribute("marketId"));

		super.sendToJsp("market.jsp");
	}
	
}