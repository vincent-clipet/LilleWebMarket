package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.Market;
import beans.User;

@WebServlet("/market_create")
public class MarketCreate extends CustomHttpServlet
{

	//
	// METHODS
	//
	public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		super.initInstance(req, res);
		User u = super.storeUser();

		int hours = 0;
		String info = null;
		String oppositeInfo = null;

		try {hours = (Integer) (req.getAttribute("hours")); }
		catch (Exception e) {}

		try {info = (String) (req.getAttribute("info"));}
		catch (Exception e) {}

		try{oppositeInfo = (String) (req.getAttribute("opposite_info"));}
		catch (Exception e) {}

		if (hours <= 0)
		{
			req.setAttribute("message", "La durée doit être supérieure à 0.");
			super.forward("market_create");
		}
		else if (info == null || info.equals("") || oppositeInfo == null || oppositeInfo.equals(""))
		{
			req.setAttribute("message", "Le nom du marché est invalide");
			super.forward("market_create");
		}
		else
		{
			Market market = super.marketDao.createMarket(info, oppositeInfo, hours, u.getId(), null);
			req.setAttribute("id", market.getMarketId());
			req.setAttribute("opposite", false);
			super.forward("market");
		}
	}

}