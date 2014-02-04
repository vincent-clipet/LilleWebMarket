<!DOCTYPE html>
<html>

	<head>
		<title>Page de login</title>
		<META http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel=stylesheet href=style.css type=text/css>		
	</head>
  
	<body>
		<jsp:include page="header.jsp" />
		
		<h1>Page de login</h1>
		
		<form method="POST" action='<%= response.encodeURL("j_security_check") %>' >
			<table border="0" cellspacing="5">
				<tr>
					<th align="right">Nom d'utilisateur:</th>
					<td align="left"><input type="text" name="j_username"></td>
				</tr>
			  	<tr>
					<th align="right">Mot de passe:</th>
					<td align="left"><input type="password" name="j_password"></td>
			  	</tr>
			  	<tr>
					<td align="right"><input type="submit" value="Log In"></td>
					<td align="left"><input type="reset"></td>
				</tr>
			</table>
		</form>
		
		<jsp:include page="footer.jsp" />
	</body>
	
</html>