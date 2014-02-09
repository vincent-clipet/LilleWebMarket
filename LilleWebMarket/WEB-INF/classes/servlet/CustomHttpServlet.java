package servlet;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringEscapeUtils;

import beans.User;
import dao.DAOFactory;
import dao.MarketDAO;
import dao.StockDAO;
import dao.UserDAO;

public class CustomHttpServlet extends HttpServlet
{ 

	//
	// ATTRIBUTES
	//
	protected HttpServletRequest req;
	protected HttpServletResponse res;
	protected PrintWriter out;
	protected HttpSession session;

	protected UserDAO userDao;
	protected MarketDAO marketDao;
	protected StockDAO stockDao;



	//
	// METHODS
	//	
	/** Initialise les variables pour la requete actuelle */
	protected void initInstance(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
	{
		this.req = req;
		this.res = res;
		this.out = res.getWriter();
		this.session = req.getSession(true);
		res.setContentType("text/html");

		DAOFactory factory = ((DAOFactory) (getServletContext().getAttribute("dao_factory")));

		if (userDao == null)
			userDao = factory.getUserDAO();

		if (marketDao == null)
			marketDao = factory.getMarketDAO();

		if (stockDao == null)
			stockDao = factory.getStockDAO();
	}

	/** Enregistre l'utilisateur actuel dans la session */
	protected User storeUser()
	{
		User u = (User) ((req.getSession(true)).getAttribute("userBean"));

		//		if (u == null)
		//{
		if (req.getUserPrincipal() != null)
		{
			u = new User();
			userDao.getUser(req.getUserPrincipal().getName(), u);
			session.setAttribute("userVisibility", "visible");
			session.setAttribute("userBean", u);
		}
		else
			session.setAttribute("userVisibility", "hidden");

		return u;
	}

	/** Redirige le traitement vers une autre page */
	protected void forward(String jsp) throws ServletException, IOException
	{
		req.getRequestDispatcher(jsp).forward(req, res);
	}

	/** Echappe une chaine de caractères avant traitement */
	protected String escapeChars(String input)
	{
		return StringEscapeUtils.escapeHtml4(input);
	}

}
