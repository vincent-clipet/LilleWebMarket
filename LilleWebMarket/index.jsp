<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.DAOFactory" %> 
<%@ page import="dao.MarketDAO" %>
<%@ page import="beans.Market" %>
<%@ page import="java.util.ArrayList" %>

<html>

	<head>
    	<title>LilleWebMarket - Accueil</title>
		<link rel="stylesheet" type="text/css" href="style.css" media="screen, projection" />
	</head>
  
	<body>
		<jsp:include page="header.jsp" />

		<div id='marches'>
			<h1 class='titre'>Marchés en cours</h1>
			<ul>
			<%
				ArrayList<Market> markets = (ArrayList<Market>) (request.getAttribute("markets"));

				for (Market m : markets)
				{
				%>
				<li>
					<p>
					<strong>Marché</strong>
					<ul>
						<li class='pronostic'><a href='market?id=<%= m.getMarketId() %>&opposite=false'><%= m.getInfo() %></a></li>
						<li class='pronostic'><a href='market?id=<%= m.getMarketId() %>&opposite=true'><%= m.getOppositeInfo() %></a></li>
					</ul><br />
					<strong>Date fin:</strong><br />
					<%= m.getEndDate() %><br />
					</p>
				</li>
				<%
				}
				%>
				
			</ul>
		</div>
		
		<jsp:include page="footer.jsp" />
	</body>
	
</html>