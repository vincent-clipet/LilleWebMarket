<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.DAOFactory" %> 
<%@ page import="java.util.ArrayList" %> 
<%@ page import="beans.Sell" %> 



<html>
  <head>
    <title>LilleWebMarket - Accueil</title>
    <link rel="stylesheet" type="text/css" href="style.css" media="screen, projection" />
    <script type="text/javascript" src="https://www.google.com/jsapi"></script>
    <script type="text/javascript">
      google.load('visualization', '1', {packages: ['corechart']});
    </script>
    <script type="text/javascript">
      function drawVisualization() {
      // Some raw data (not necessarily accurate)
      var data = google.visualization.arrayToDataTable([
      ['Date', 'Volume', 'Prix'],

      <%= (String) (request.getAttribute("logData")) %>
      
      var options = {
        title : 'Evolution du marché',
        vAxes: {
          0: {title: "Volume", titleTextStyle:{color: "#556270", fontSize: 18, bold: true, italic: false}},
          1:{title: "Prix", titleTextStyle:{color: "#4ecdc4", fontSize: 18, bold: true, italic: false}}
        },
        hAxis: {title: "Date"},
        seriesType: "bars",
        series: {
          0: {targetAxisIndex: 0, color: "#556270"},
          1: {targetAxisIndex: 1,type: "line", color: "#4ecdc4"}
        }
      };
      
      var chart = new google.visualization.ComboChart(document.getElementById('graph'));
      chart.draw(data, options);
      }
      google.setOnLoadCallback(drawVisualization);
    </script>
  </head>
  <body>
  	<jsp:useBean id="userBean" scope="session" class="beans.User" />
  
    <jsp:include page="header.jsp" />

    <jsp:useBean id="marketBean" scope="request" class="beans.Market" />
    <jsp:useBean id="sellBean" scope="request" class="beans.Sell" />

    <%!
       int marketId;
       boolean opposite;
       ArrayList<Sell> asks;
       ArrayList<Sell> bids;
       String message;
       boolean hasEnded;
       boolean mustBeConfirmed;
       %>
    
    <%
       marketId = (Integer) (request.getAttribute("marketId"));
       opposite = (Boolean) (request.getAttribute("opposite"));
       asks = (ArrayList<Sell>) (request.getAttribute("asks"));
       bids = (ArrayList<Sell>) (request.getAttribute("bids"));
       message = (String) (request.getAttribute("message"));
       hasEnded = (Boolean) (request.getAttribute("hasEnded"));
       mustBeConfirmed = (Boolean) (request.getAttribute("mustBeConfirmed"));
       %>
    
    <div id='menu'>
      <ul>
        <li><a href='index'>Marchés</a></li>
	<li><a href='market?id=<%= marketId %>&opposite=<%= !opposite %>'>Aller au marché opposé</a></li>
      </ul>
    </div>

    <div id='marches' >      
      <h1 class='titre' >Pronostic : <% out.write( opposite ? marketBean.getOppositeInfo() : marketBean.getInfo()); %></h1>
      <%
	 if (message != null) {
	 %>
      <p class='alert'><%= message %></p>
      <% } %>

      <div id='left-col' >
	<div class='div-tab' id="asks" >
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

	<div class='div-tab' id="bids" >
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
	
	<%
		if (! hasEnded)
		{
	%>
	<div id='buy-form' >
	  <form method="get" action='buy'>
	    <input type="text" name="id" value='<%= marketId %>' hidden />
	    <input type="text" name="opposite" value='<%= opposite %>' hidden />

	    <input type="text" name="quantity" placeholder="quantity"/>
	    <input type="text" name="price" placeholder="price"/>
	    <input class="bouton" type="submit" value="Faire une offre"/>
	  </form>
	</div><!-- end div #buy-form -->
	<%
		}
	%>

      </div><!-- end div #left-col -->

      <div id='right-col'>
		<div id='graph' style="width: 100%; height: 300px;">
		</div>
      </div>
	  
	<%
		if (mustBeConfirmed)
		{
	%>
	  <div id='confirmation-form' >
	  <form method="get" action='market'>
		<input type="radio" name="winner" value="false" /><jsp:getProperty name="marketBean" property="info" />
		<input type="radio" name="winner" value="true" /><jsp:getProperty name="marketBean" property="oppositeInfo" />
		<input type="text" name="id" value='<%= marketId %>' hidden/>
		<input type="text" name="opposite" value='<%= opposite %>' hidden />
	    <input class="bouton" type="submit" value="Confimer la fin de ce marché"/>
	  </form>
	</div><!-- end div #buy-form -->
	<%
		}
	%>

    </div><!-- end div #marches -->
</div><!-- end div #page -->
<jsp:include page="footer.jsp" />
</body>
</html>
