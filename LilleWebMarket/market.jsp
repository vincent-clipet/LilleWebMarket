<%@ page import="dao.DAOFactory" %> 
<%@ page import="dao.MarketDAO" %> 
<%@ page import="java.util.ArrayList" %> 
<%@ page import="beans.Sell" %> 



<html>
  <head>
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8">
    <title>LilleWebMarket - Accueil</title>
    <link rel="stylesheet" type="text/css" href="style.css" media="screen, projection" />
  </head>
  <body>
    <div id='page'> 

      <div id='header'>
	<img src="logo.png" alt='logo' />
      </div>

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
	
	<h1 class='titre-marche' >Info : <% out.write( opposite ? marketBean.getOpposite_info() : marketBean.getInfo()); %></h1>

	<table class="asks">

	  <tr><th>Nom</th><th>Quantite</th><th>Prix</th></tr>
	  <% for (Sell s : asks)
	   {
	   sellBean = s;
		 %><tr><td><%= sellBean.getOwnerName() %></td><td><%= sellBean.getQuantity() %></td><td><%= sellBean.getPrice() %></td></tr><%}%>

	</table>

	<table class="asks">

	  <tr><th>Nom</th><th>Quantite</th><th>Prix</th></tr>
	  <% for (Sell s : bids)
	   {
	   sellBean = s;
		 %><tr><td><%= sellBean.getOwnerName() %></td><td><%= sellBean.getQuantity() %></td><td><%= sellBean.getPrice() %></td></tr><%}%>

	</table>

      <div id='profil'>
	<h1 class='titre'>Vendeurs</h1>
      </div>
    </div>
  </body>
</html>
