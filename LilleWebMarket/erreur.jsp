<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<%@ page language="java" contentType="text/html; charset=UTF-8" isErrorPage="true" pageEncoding="UTF-8" %>

<html>
	<head>
		<title>LilleWebMarket - Erreur</title>
		<link rel="stylesheet" type="text/css" href="style.css" media="screen, projection" />
	</head>
  
	<body>
  
		<div id='header'>
			<img src="logo.png" alt='logo' /><div id='main-title' >Lille Web Market</div>
		</div>

		<div id='erreur'> 
			<h1> Page de gestion d'erreur</h1>
	   		<h3> Un probleme de type </h3><br />
			<pre>"<%
				String m = request.getParameter("message");
				out.println("<br />");
				if (m!=null) out.print(m);
				if (exception!=null) out.print(exception.getMessage());
			 %>" est survenu. 
			</pre>
			<a href="/LilleWebMarket">Retour à l'accueil ...</a>
		</div>
		
	</body>
</html>
