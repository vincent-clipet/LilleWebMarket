<jsp:useBean id="userBean" scope="session" class="beans.User" />

<div id='header'>
  <img id="logo" src="images/logo-lille1.png" alt='logo' /><div id='main-title' >Lille Web Market</div>


  <% if (session.getAttribute("userVisibility").equals("visible")) { %>
  <div id='profile'>
    <img src="images/photo.png"/>
    <div id='infos'>
      <p id='login'><jsp:getProperty name="userBean" property="login" /></p>
      <p id='account'>Compte : <jsp:getProperty name="userBean" property="money" /></p>
      <form method='post' action='disconnect' ><input id='disconnect-button' type="submit" value="Disconnect"/></form>
    </div>
  </div>
  <% } %>

</div>

<div id='page'>
