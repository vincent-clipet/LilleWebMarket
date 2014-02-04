package servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.Market;
import beans.User;

@WebServlet("/buy")
public class BuyServlet extends CustomHttpServlet
{

	//
	// METHODS
	//
	public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		super.initInstance(req, res);
		super.storeUser();

		beans.Market m = (Market) (req.getAttribute("marketBean"));
		beans.User u = (User) (session.getAttribute("userBean"));

		boolean opposite = false;
		int marketId = 0;
		int quantity = 0;
		int price = 0;

		try {opposite = Boolean.parseBoolean(req.getParameter("opposite"));}
		catch (Exception e) {}

		try {marketId = Integer.parseInt(req.getParameter("id"));}
		catch (Exception e) {}

		try{quantity = Integer.parseInt(req.getParameter("quantity"));}
		catch (Exception e) {}

		try{price = Integer.parseInt(req.getParameter("price"));}
		catch (Exception e) {}

		marketDao.getMarket(marketId, m);

		if (quantity == 0 || (price <= 0 || price >= 100))
		    req.setAttribute("message", "La quantité doit être différente de 0 et le prix compris entre 0 et 99.");
		else
		{
		    int userId = u.getId(); // TODO
		    String message = marketDao.putBid(quantity, price, userId, marketId, opposite);
			req.setAttribute("message", message);   
		}

		super.forward("market");

	}
}
