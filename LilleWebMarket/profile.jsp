<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.DAOFactory" %> 
<%@ page import="dao.UserDAO" %>

<html>

	<jsp:useBean id="userBean" scope="session" class="beans.User" />

  <head>
    <title>LilleWebMarket - Profil</title>
    <link rel="stylesheet" type="text/css" href="style.css" media="screen, projection" />
  </head>
  
  <body>
    <div id='page'> 

      <div id='header'>
	<img src="logo.png" alt='logo' />
      </div>

      <div id='profil'>
		<h1 class='titre'>Profil</h1>
		
		<p>
			ID : <jsp:getProperty name="userBean" property="id" /><br />
			Login : <jsp:getProperty name="userBean" property="login" /><br />
			Money : <jsp:getProperty name="userBean" property="money" /><br />
		</p>
		
      </div>

    </div>
  </body>
</html>
