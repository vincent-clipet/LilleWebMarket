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

		int hours = -1;
		String info = null;
		String oppositeInfo = null;

		try {hours = Integer.parseInt(escapeChars(req.getParameter("hours"))); }
		catch (Exception e) {}

		try {info = escapeChars(req.getParameter("info"));}
		catch (Exception e) {}

		try{oppositeInfo = escapeChars(req.getParameter("opposite_info"));}
		catch (Exception e) {}

		if (hours == -1 && info == null && oppositeInfo == null)
		{
			req.setAttribute("message", "1 : " + hours + " " + info + " " + oppositeInfo);
			super.forward("market_create.jsp");
		}
		else if (hours <= 0)
		{
			req.setAttribute("message", "La durée doit être supérieure à 0.");
			super.forward("market_create.jsp");
		}
		else if (info == null || info.equals(""))
		{
			req.setAttribute("message", "Le nom du marché est invalide");
			super.forward("market_create.jsp");
		}
		else if (oppositeInfo == null || oppositeInfo.equals(""))
		{
			req.setAttribute("message", "Le nom du marché opposé est invalide");
			super.forward("market_create.jsp");
		}
		else
		{
			req.setAttribute("message", "5");
			Market market = super.marketDao.createMarket(info, oppositeInfo, hours, u.getId(), null);
			super.forward("market?id=" + market.getMarketId() + "&opposite=false");
		}
	}

}
