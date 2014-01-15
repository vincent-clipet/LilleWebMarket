<html>
  <head>
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8">
    <title>LilleWebMarket - Marché</title>
    <link rel="stylesheet" type="text/css" href="style.css" media="screen, projection" />
  </head>
  <body>
    <div id='page'> 

      <div id='header'>
	<img src="logo.png" alt='logo' />
      </div>

      <div id='menu'>
	<ul>
	  <li><a href='index.jsp'>Marchés</a></li>
	  <ul>
      </div>

      <div class='stocks' id='vendeurs'>
	<h1 class='titre'>Vendeurs</h1>
	<table>
	  <tr><th>Vendeur</th><th>Prix</th><th>Quantité</th></tr>
	  <tr><td>bob</td><td>60</td><td>5</td></tr>
	</table>
      </div>

      <div class='stocks' id='acheteurs'>
	<h1 class='titre'>Acheteurs</h1>
	<table>
	  <tr><th>Acheteur</th><th>Prix</th><th>Quantité</th></tr>
	  <tr><td>Joe</td><td>40</td><td>10</td></tr>
	</table>
      </div>

      <div class='market-maker' id='creation'>
	<form method="get">
	  <input type='textarea' />
	  <input type="submit" value="Créer un nouveau marché">
	</form>
      </div>

    </div>
  </body>
</html>
