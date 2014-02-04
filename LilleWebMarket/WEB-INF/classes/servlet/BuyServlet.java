package servlet;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.RequestDispatcher;

import beans.Market;
import beans.Sell;


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

		RequestDispatcher dispatcher;

		beans.Market m = (Market) (req.getAttribute("marketBean"));
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

		if (m == null)
		{
			m = new Market();
		}
		marketDao.getMarket(marketId, m);

		if (quantity == 0 || (price <= 0 || price >= 100))
			req.setAttribute("message", "La quantité doit être différente de 0 et le prix compris entre 0 et 99.");
		else
		{
			int userId = 1; // TODO
			String message = marketDao.putBid(quantity, price, userId, marketId, opposite);
			req.setAttribute("message", message);   
		}

		dispatcher = req.getRequestDispatcher("market");
		dispatcher.forward(req, res);

	}
}
