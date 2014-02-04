package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DAOUtil
{

	//
	// CONSTRUCTOR
	//
	private DAOUtil()
	{

	}

	//
	// METHODS
	//
	public static void close(ResultSet rs)
	{
		if (rs != null)
		{
			try
			{
				rs.close();
			}
			catch (SQLException e)
			{
				System.out.println("Error while closing ResultSet : " + e.getMessage());
			}
		}
	}

	public static void close(Statement st)
	{
		if (st != null)
		{
			try
			{
				st.close();
			}
			catch (SQLException e)
			{
				System.out.println("Error while closing Statement : " + e.getMessage());
			}
		}
	}

	public static void close(Connection conn)
	{
		if (conn != null)
		{
			try
			{
				conn.close();
			}
			catch (SQLException e)
			{
				System.out.println("Error while closing Connection : " + e.getMessage());
			}
		}
	}
	
	public static void close(ResultSet rs, Statement st, Connection conn)
	{
		close(rs);
		close(st);
		close(conn);
	}
	
	

	public static PreparedStatement getPreparedStatement(Connection conn, String req, Object... objects) throws SQLException
	{
		PreparedStatement preparedStatement = conn.prepareStatement(req);

		for (int i = 0; i < objects.length; i++)
			preparedStatement.setObject(i + 1, objects[i]);

		return preparedStatement;
	}

}