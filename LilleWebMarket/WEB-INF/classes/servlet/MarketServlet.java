package servlet;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.Market;
import beans.Sell;
import beans.User;

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
		User u = super.storeUser();

		Market m = (Market) (req.getAttribute("marketBean"));

		boolean opposite = false;
		int marketId = 0;
		Boolean winner = null;

		try {opposite = Boolean.parseBoolean(req.getParameter("opposite"));}
		catch (Exception e) {}

		try {marketId = Integer.parseInt(req.getParameter("id"));}
		catch (Exception e) {}

		try
		{
			String requestWinner = req.getParameter("winner");
			winner = (requestWinner == null || requestWinner.equals("") ? null : Boolean.valueOf(requestWinner));
		}
		catch (Exception e) {}

		if (m == null)
			m = new Market();

		marketDao.getMarket(marketId, m);

		if (winner != null)
		{
			marketDao.closeMarket(marketId, (boolean) winner);
			super.forward("index");
		}
		else
		{
			ArrayList<Sell> asks = marketDao.getAsks(marketId, opposite);
			ArrayList<Sell> bids = marketDao.getBids(marketId, opposite);
			String logData = marketDao.getLogData(marketId);
			boolean[] b = marketDao.hasEndedAndMustBeConfirmed(m.getMarketId(), u.getId());

			if (b[1] && ! req.isUserInRole("marketmaker"))
				b[1] = false;

			req.setAttribute("hasEnded", b[0]);
			req.setAttribute("mustBeConfirmed", b[1]);
			req.setAttribute("logData", logData);
			req.setAttribute("marketBean", m);
			req.setAttribute("marketId", marketId);
			req.setAttribute("opposite", opposite);
			req.setAttribute("asks", asks);
			req.setAttribute("bids", bids);

			//out.println("###### MARKET_ID ##########" + req.getAttribute("marketId"));
			super.forward("market.jsp");
		}
	}

}
