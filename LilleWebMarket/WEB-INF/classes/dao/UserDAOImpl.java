package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import beans.User;

/** Implémentation concrète de l'interface UserDAO */
public class UserDAOImpl implements UserDAO, IDAOObject<User>
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
	public User map(ResultSet rs, User u) throws SQLException
	{
		if (u == null)
			u = new User();

		u.setId(rs.getInt("user_id"));
		u.setLogin(rs.getString("login"));
		u.setPassword(rs.getString("password"));
		u.setMoney(rs.getInt("money"));
		return u;
	}

	public User getUser(String login, User u) throws DAOException
	{
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try
		{
			conn = this.factory.getConnection();
			String req = "SELECT * FROM users WHERE login=?;";
			ps = DAOUtil.getPreparedStatement(conn, req, login);
			rs = ps.executeQuery();

			if (rs.next())
				u = map(rs, u);
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

	public User createUser(String login, String password, User u) throws DAOException
	{
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

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
				u = map(rs, null);
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

}