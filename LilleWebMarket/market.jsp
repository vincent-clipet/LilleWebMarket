<%@ page import="dao.DAOFactory" %> 
<%@ page import="dao.MarketDAO" %> 

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
	
	<%!
	   MarketDAO marketDao;
	   
	   public void jspInit()
	   {
	   marketDao = ((DAOFactory) (getServletContext().getAttribute("dao_factory"))).getMarketDAO();
	   }
	   %>
	
	<%
	   marketDao.getMarket(Integer.parseInt(request.getParameter("id")), marketBean);
	   %>
	
	<h1 class='titre-marche' >Info : <% out.write(request.getParameter("opposite").equals("false")?marketBean.getInfo():marketBean.getOpposite_info()); %></h1>

	

      <div id='profil'>
	<h1 class='titre'>Vendeurs</h1>
      </div>
    </div>
  </body>
</html>
