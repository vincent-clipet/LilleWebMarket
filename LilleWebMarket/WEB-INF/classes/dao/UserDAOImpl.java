package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import beans.User;

public class UserDAOImpl implements UserDAO
{

	//
	// ATTRIBUTES
	//
	private DAOFactory factory;



	//
	// CONSTRUCTOR
	//
	UserDAOImpl(DAOFactory factory)
	{
		this.factory = factory;
	}



	//
	// METHODS
	//
	private User map(ResultSet rs) throws SQLException
	{
		User u = new User();
		u.setId(rs.getInt("user_id"));
		u.setLogin(rs.getString("login"));
		u.setPassword(rs.getString("password"));
		u.setMoney(rs.getInt("money"));
		return u;
	}

	@Override
	public User getUser(String login) throws DAOException
	{
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		User u = null;

		try
		{
			conn = this.factory.getConnection();
			String req = "SELECT * FROM users WHERE login=?;";
			ps = DAOUtil.getPreparedStatement(conn, req, login);
			rs = ps.executeQuery();

			if (rs.next())
				u = map(rs);
		}
		catch (SQLException e)
		{
			throw new DAOException(e);
		}
		finally
		{
			DAOUtil.close(rs, ps, conn);
		}

		return u;
	}

	@Override
	public User createUser(String login, String password) throws DAOException
	{
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		User u = null;

		try
		{
			conn = this.factory.getConnection();
			
			String req = "INSERT INTO users(login, password) VALUES(?,?);";
			ps = DAOUtil.getPreparedStatement(conn, req, login, password);
			ps.executeUpdate();
			DAOUtil.close(ps);
			
			req = "SELECT * FROM users WHERE login=?;";
			ps = DAOUtil.getPreparedStatement(conn, req, login);
			rs = ps.executeQuery();
			
			if (rs.next())
				u = map(rs);
		}
		catch (SQLException e)
		{
			throw new DAOException(e);
		}
		finally
		{
			DAOUtil.close(rs, ps, conn);
		}

		return u;
	}
	
	public boolean promote(String role)
	{
		//TODO
		return false;
	}
	
	public boolean demote(String role)
	{
		//TODO
		return false;
	}

}