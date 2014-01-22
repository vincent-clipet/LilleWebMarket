<%@ page import="dao.DAOFactory" %> 
<%@ page import="dao.UserDAO" %> 

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

      <div id='profil'>
		<h1 class='titre'>Profil</h1>
		
		<jsp:useBean id="userBean" scope="session" class="beans.User" />
		
		<%!
			UserDAO userDao;
		
			public void jspInit()
			{
				userDao = ((DAOFactory) (getServletContext().getAttribute("dao_factory"))).getUserDAO();
			}
		%>
		
		<%
			userDao.getUser("admin1", userBean);
		%>
		
		<%--
		<jsp:useBean id="userBean" scope="session" class="beans.User" />
		<jsp:setProperty name="userBean" property="*" />
		--%>

		
		<p>ID : <jsp:getProperty name="userBean" property="id" /></p>
		<p>Login :<jsp:getProperty name="userBean" property="login" /></p>
		<p>Password :<jsp:getProperty name="userBean" property="password" /></p>
		<p>Money :<jsp:getProperty name="userBean" property="money" /></p>
		
      </div>

    </div>
  </body>
</html>
