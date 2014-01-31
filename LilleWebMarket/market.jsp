<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.DAOFactory" %> 
<%@ page import="dao.MarketDAO" %> 
<%@ page import="java.util.ArrayList" %> 
<%@ page import="beans.Sell" %> 


<!DOCTYPE html>
<html>
	<head>
		<title>LilleWebMarket - Accueil</title>
	<link rel="stylesheet" type="text/css" href="style.css" media="screen, projection" />
	</head>
	
	<body>
  		<jsp:include page="header.jsp" />

		<jsp:useBean id="marketBean" scope="session" class="beans.Market" />
		<jsp:useBean id="sellBean" scope="session" class="beans.Sell" />

		<%!
			MarketDAO marketDao;
			ArrayList<Sell> asks;
			ArrayList<Sell> bids;
			boolean opposite;
			int market_id;
		
			public void jspInit()
			{
			marketDao = ((DAOFactory) (getServletContext().getAttribute("dao_factory"))).getMarketDAO();
			}
		%>
      
      <%
	 try {opposite = Boolean.parseBoolean(request.getParameter("opposite"));}
	 catch (Exception e) {opposite = false;}
	 
	 try {market_id = Integer.parseInt(request.getParameter("id"));}
	 catch (Exception e) {market_id = 0;}

	 marketDao.getMarket(Integer.parseInt(request.getParameter("id")), marketBean);

	 asks = marketDao.getAsks(market_id, opposite);
	 bids = marketDao.getBids(market_id, opposite);
	 %>


      <div id='menu'>
        <ul>
          <li><a href='index.jsp'>Marchés</a></li>
	  <li><a href='market.jsp?id=<%= request.getParameter("id") %>&opposite=<%= !opposite %>'>Aller au marché opposé</a></li>
        </ul>
      </div>

      <div id='marches' >      
	<h1 class='titre' >Pronostic : <% out.write( opposite ? marketBean.getOpposite_info() : marketBean.getInfo()); %></h1>

	<div id="asks" >
	  <h1 class="asks">Vendeurs</h1>
	  <table>
	    <tr><th>Nom</th><th>Quantite</th><th>Prix</th></tr>
	    <% for (Sell s : asks)
	       {
	       sellBean = s;
	       %><tr><td><%= sellBean.getOwnerName() %></td><td><%= sellBean.getQuantity() %></td><td><%= sellBean.getPrice() %></td></tr><%}%>
	  </table>
	</div>

	<div id="bids" >
	  <h1 class="bids">Acheteurs</h1>
	  <table>

	    <tr><th>Nom</th><th>Quantite</th><th>Prix</th></tr>
	    <% for (Sell s : bids)
	       {
	       sellBean = s;
	       %><tr><td><%= sellBean.getOwnerName() %></td><td><%= sellBean.getQuantity() %></td><td><%= sellBean.getPrice() %></td></tr><%}%>

	  </table>
	</div>

      <div id='buy-form' >
	<form method="get" action="buy-servlet">
	  
	  <input type="text" name="quantity" placeholder="quantity">
	  <input type="text" name="price" placeholder="price">
	  <input type="submit" value="Faire une offre">
	  
	</form>
      </div>

      </div><!-- end div #marches -->
    </div><!-- end div #page -->

	<jsp:include page="footer.jsp" />
  </body>
</html>
