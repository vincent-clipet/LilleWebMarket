<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>



<html>

	<head>
		<meta http-equiv="Content-type" content="text/html;charset=UTF-8">
		<title>LilleWebMarket - Création d'un marché</title>
		<link rel="stylesheet" type="text/css" href="style.css" media="screen, projection" />
	</head>
	
	<body>
		<jsp:useBean id="userBean" scope="session" class="beans.User" />
		<jsp:include page="header.jsp" />
		
		<%
		   String info = (String) (request.getAttribute("info"));
		   String oppositeInfo = (String) (request.getAttribute("opposite_info"));
		   Integer hours = (Integer) (request.getAttribute("hours"));
		   String message = (String) (request.getAttribute("message"));
		   
		   info = (info == null ? "" : info);
		   oppositeInfo = (oppositeInfo == null ? "" : oppositeInfo);
		   hours = (hours == null ? 0 : hours);
		 %>
	   
	   
		<div id='menu'>
			<ul>
				<li><a href='index.jsp'>Marchés</a></li>
			</ul>
		</div>
		
		
		<div class='market-maker' id='creation'>    
			<%
				if (message != null)
				{
			%>
			<p class='alert'><%= message %></p>
			<%
				}
			%>

			<h1>Création d'un nouveau marché</h1>
			<form method="get" action="market_create">
				<p>Intitulé <input type='text' name='info' value='<%= info %>' size='50'/></p>
				<p>Contre-proposition<input type='text' name='opposite_info' value='<%= oppositeInfo %>' size='50' /></p>
				<p>Durée (en heures)<input type='text' name='hours' value='<%= (int)hours %>' /></p>
				<input type="submit" value="Créer un nouveau marché">
			</form>
		</div>

		<jsp:include page="footer.jsp" />
	</body>
	
</html>
