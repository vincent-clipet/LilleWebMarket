<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" isErrorPage="true" pageEncoding="UTF-8" %>

<html>
	<head>
		<title>LilleWebMarket - Erreur</title>
		<link rel="stylesheet" type="text/css" href="style.css" media="screen, projection" />
	</head>
  
	<body>
		<jsp:include page="header.jsp" />

		<div id='erreur'> 
			<h1> Page de gestion d'erreur</h1>
			<pre>
			<%
				String m = request.getParameter("message");
				
				
				if (m != null)
				{
					out.print(m);
					out.println("<br />");
				}
				
				if (exception != null)
				{
					out.print(exception.getMessage());
					out.println("<br />");
				}
			 %> 
			</pre>
			<a href="/LilleWebMarket">Retour à l'accueil ...</a>
		</div>
		
		<jsp:include page="footer.jsp" />
	</body>
</html>
