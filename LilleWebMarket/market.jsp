<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.DAOFactory" %> 
<%@ page import="java.util.ArrayList" %> 
<%@ page import="beans.Sell" %> 



<html>
  <head>
    <title>LilleWebMarket - Accueil</title>
    <link rel="stylesheet" type="text/css" href="style.css" media="screen, projection" />
  </head>
  <body>

      <jsp:include page="header.jsp" />

      <jsp:useBean id="marketBean" scope="request" class="beans.Market" />
      <jsp:useBean id="sellBean" scope="request" class="beans.Sell" />

      <%!
	 int marketId;
	 boolean opposite;
	 ArrayList<Sell> asks;
	 ArrayList<Sell> bids;
	 %>
      
      <%
	 marketId = (Integer) (request.getAttribute("marketId"));
	 opposite = (Boolean) (request.getAttribute("opposite"));
	 asks = (ArrayList<Sell>) (request.getAttribute("asks"));
	 bids = (ArrayList<Sell>) (request.getAttribute("bids"));
	 %>

      <div id='menu'>
        <ul>
          <li><a href='index'>Marchés</a></li>
	  <li><a href='market?id=<%= marketId %>&opposite=<%= !opposite %>'>Aller au marché opposé</a></li>
        </ul>
      </div>

      <div id='marches' >      
	<h1 class='titre' >Pronostic : <% out.write( opposite ? marketBean.getOpposite_info() : marketBean.getInfo()); %></h1>

	<div id="asks" >
	  <h1 class="asks">Vendeurs</h1>
	  <table>

	    <tr>
	      <th>Nom</th>
	      <th>Quantite</th>
	      <th>Prix</th>
	    </tr>

	    <% for (Sell s : asks) {
	       sellBean = s; %>
	    <tr>
	      <td><%= sellBean.getOwnerName() %></td>
	      <td><%= sellBean.getQuantity() %></td>
	      <td><%= sellBean.getPrice() %></td>
	    </tr>
	    <%}%>

	  </table>
	</div><!-- end div #bids -->

	<div id="bids" >
	  <h1 class="bids">Acheteurs</h1>
	  <table>
	    
	    <tr>
	      <th>Nom</th>
	      <th>Quantite</th>
	      <th>Prix</th>
	    </tr>
	    
	    <% for (Sell s : bids) {
	       sellBean = s; %>
	    <tr>
	      <td><%= sellBean.getOwnerName() %></td>
	      <td><%= sellBean.getQuantity() %></td>
	      <td><%= sellBean.getPrice() %></td>
	    </tr>
	    <%}%>
	    
	  </table>

	</div><!-- end div #bids -->

	<div id='buy-form' >
	  <form method="get" action="buy-servlet">
	    <input type="text" name="marketid" value='<%= marketId %>' hidden/>
	    <input type="text" name="quantity" placeholder="quantity"/>
	    <input type="text" name="price" placeholder="price"/>
	    <input type="submit" value="Faire une offre"/>
	  </form>
	</div>

      </div><!-- end div #marches -->
    </div><!-- end div #page -->
   <jsp:include page="footer.jsp" />
  </body>
</html>
