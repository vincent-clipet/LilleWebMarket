<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.DAOFactory" %> 
<%@ page import="dao.UserDAO" %>

<html>

	<%!
		UserDAO userDao;

		public void jspInit()
		{
			userDao = ((DAOFactory) (getServletContext().getAttribute("dao_factory"))).getUserDAO();
		}
	%>

	<jsp:useBean id="userBean" scope="session" class="beans.User" />
	<%
		//userDao.getUser(request.getUserPrincipal().getName(), userBean); // doesn't work, don't know why
	%>

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
		
		<p>ID : <jsp:getProperty name="userBean" property="id" /></p>
		<p>Login :<jsp:getProperty name="userBean" property="login" /></p>
		<p>Password :<jsp:getProperty name="userBean" property="password" /></p>
		<p>Money :<jsp:getProperty name="userBean" property="money" /></p>
		
      </div>

    </div>
  </body>
</html>
