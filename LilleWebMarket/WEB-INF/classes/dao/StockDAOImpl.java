package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import beans.Stock;

public class StockDAOImpl implements StockDAO
{

	//
	// ATTRIBUTES
	//
	private DAOFactory factory;



	//
	// CONSTRUCTOR
	//
	StockDAOImpl(DAOFactory factory)
	{
		this.factory = factory;
	}



	//
	// METHODS
	//
	private Stock map(ResultSet rs, Stock s) throws SQLException
	{
		if (s == null)
			s = new Stock();
		
		s.setId(rs.getInt("stock_id"));
		s.setQuantity(rs.getInt("quantity"));
		s.setOpposite(rs.getBoolean("opposite"));
		s.setOwnerId(rs.getInt("owner_id"));
		s.setMarketId(rs.getInt("market_id"));
		
		return s;
	}

	@Override
	public Stock getStock(int id, Stock s) throws DAOException
	{
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try
		{
			conn = this.factory.getConnection();
			String req = "SELECT * FROM stocks WHERE stock_id=?;";
			ps = DAOUtil.getPreparedStatement(conn, req, id);
			rs = ps.executeQuery();

			if (rs.next())
				s = map(rs, s);
		}
		catch (SQLException e)
		{
			throw new DAOException(e);
		}
		finally
		{
			DAOUtil.close(rs, ps, conn);
		}

		return s;
	}

	@Override
	public Stock createStock(int quantity, boolean opposite, int owner_id, int market_id, Stock s) throws DAOException
	{
		//TODO use generated_keys ?
		
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try
		{
			conn = this.factory.getConnection();
			String req = "INSERT INTO stocks(quantity, opposite, owner_id, market_id) VALUES(?, ?, ?, ?);";
			ps = DAOUtil.getPreparedStatement(conn, req, quantity, opposite, owner_id, market_id);
			ps.executeUpdate();
			DAOUtil.close(ps);
			
			req = "SELECT * FROM stocks WHERE quantity=? AND opposite=? AND owner_id=? AND market_id=?;";
			ps = DAOUtil.getPreparedStatement(conn, req, quantity, opposite, owner_id, market_id);
			rs = ps.executeQuery();
			
			if (rs.next())
				s = map(rs, null);
		}
		catch (SQLException e)
		{
			throw new DAOException(e);
		}
		finally
		{
			DAOUtil.close(rs, ps, conn);
		}

		return s;
	}
	
	@Override
	public Stock[] splitStock(Stock stock, int quantityToDraw)
	{
		//TODO
		return null;
	}

}
