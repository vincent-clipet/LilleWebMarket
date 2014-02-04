package servlet;
import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import beans.Market;

@WebServlet("/index")
public class Index extends CustomHttpServlet
{

	//
	// METHODS
	//
	public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		super.initInstance(req, res);
		super.storeUser();

		ArrayList<Market> markets = marketDao.getNextMarkets(-1);
		req.setAttribute("markets", markets);

		super.sendToJsp("index.jsp");
	}
}
