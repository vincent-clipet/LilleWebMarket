<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.DAOFactory" %> 
<%@ page import="dao.MarketDAO" %>
<%@ page import="beans.Market" %>
<%@ page import="java.util.ArrayList" %>

<html>

<%!
	MarketDAO marketDao;

	public void jspInit()
	{
		marketDao = ((DAOFactory) (getServletContext().getAttribute("dao_factory"))).getMarketDAO();
	}
%>

  <head>
    <title>LilleWebMarket - Accueil</title>
    <link rel="stylesheet" type="text/css" href="style.css" media="screen, projection" />
  </head>
  
  <body>
	<div id='page'> 

		<div id='header'>
			<img src="logo.png" alt='logo' />
      	</div>

      	<div id='marches'>
			<h1 class='titre'>Marchés en cours</h1>
			
				<ul>
				<%
				ArrayList<Market> markets = marketDao.getNextMarkets(5);
				
				for (Market m : markets)
				{
					String s1 = "\"market.jsp?id=" + m.getMarket_id() + "&opposite=false\"";
					String s2 = "\"market.jsp?id=" + m.getMarket_id() + "&opposite=true\"";
					
					out.println("<li>");
					out.println("	<p>");
					out.println("	<strong>Marché:</strong>");
					out.println("	<ul>");
					out.println("		<li class='pronostic'><a href=" + s1 + ">" + m.getInfo() + "</a></li>");
					out.println("		<li class='pronostic'><a href=" + s2 + ">" + m.getOpposite_info() + "</a></li>");
					out.println("	</ul><br />");
					out.println("	<strong>Date fin:</strong><br />");
					out.println("" + m.getEnd_date() + "<br />");
					out.println("	</p>");
					out.println("</li>");
				}
				%>
				</ul>
				</li>
			</ul>
		</div>

    </div>
  </body>
</html>
