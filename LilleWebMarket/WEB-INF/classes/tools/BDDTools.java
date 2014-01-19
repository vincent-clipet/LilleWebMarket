/*
------------------------------------------------
Bean de mise en forme HTML d'une requête SQL
Auteur : P Mathieu, pour les étudiants de LP DA2I
Date   : 28/12/2002
------------------------------------------------
*/

package tools;

import java.sql.*;

public class BDDTools
{
    /**
       Renvoie une table HTML contenant l'ensemble du resultSet. Les
       noms des colonnes peuvent être mis ou pas. la
       premiere colonne doit etre l'id qui sera utilisé pour faire un
       lien http.
@param rs le resulset à transformer en table html
@param colname indique si les noms des cols seront affichés
@param ligNb   indique si le nombre de lignes est affiché en fin de table
@param link    indique si on fait un lien sur la premiere colonne (id)
    **/
    public String getHTMLSimpleTable(ResultSet rs,boolean colname,
    boolean ligNb, boolean link)
    throws Exception
    {
	StringBuffer sb = new StringBuffer();
	ResultSetMetaData rsmd= rs.getMetaData();
	int nbCols=rsmd.getColumnCount();
	sb.append("<center><table>\n");
	// entete des colonnes
	if (colname)
	{
		sb.append("<tr>");
		for (int i=1;i<=nbCols;i++)
		{
			sb.append("<th>");
			sb.append((rsmd.getColumnName(i)).toUpperCase());
			sb.append("</th>");
		}
		sb.append("</tr>\n");
	}
	// valeurs des colonnes
	int nblig=1;
	while (rs.next())
	    {
		sb.append("<tr>");
		for (int i=1;i<=nbCols;i++)
		    {
			if (nblig%2==0) sb.append("<td class=paire>");
			else sb.append("<td class=impaire>");
			String val=rs.getString(i);
			if (link && i==1) // Traitement de l'id avec l'option link
			sb.append("<a href=adminFiche.jsp?id="+val+">"+val+"</a>");
			else sb.append(val);
			sb.append("</td>");
		    }
		sb.append("</tr>\n");
		nblig++;
	    }
	sb.append("</table>\n");
	if (ligNb) 
	   sb.append("<p>La table contient "+(nblig-1)+" lignes\n");
	sb.append("<center>\n");
	return sb.toString();
    }

    /*-----------------------------------------------------------*/

    /**
       Renvoie une table HTML sous forme de fiche représentant la
       ligne sur laquelle est positionné le resultSet. Attention à ne
       pas oublier de faire appel à next() avant l'appel de cette
       méthode.
    **/
    public String getHTMLSimpleFiche(ResultSet rs)
    throws Exception
    {
	StringBuffer sb = new StringBuffer();
	ResultSetMetaData rsmd= rs.getMetaData();
	int nbCols=rsmd.getColumnCount();
	sb.append("<center><table>\n");
	// entete des colonnes
	for (int i=1;i<=nbCols;i++)
	    {
		sb.append("<tr>");
		if (i%2==0) sb.append("<td class=paire>");
		else sb.append("<td class=impaire>");
		sb.append("<b>"+(rsmd.getColumnName(i)).toUpperCase()+"</b>");
		sb.append("</td>");
		if (i%2==0) sb.append("<td class=paire>");
		else sb.append("<td class=impaire>");
		sb.append(rs.getString(i));
		sb.append("</td>");
		sb.append("</tr>\n");
	    }
	sb.append("</table></center>");
	return sb.toString();
    }
}
