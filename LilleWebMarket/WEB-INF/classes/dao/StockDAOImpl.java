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
	private Stock map(ResultSet rs) throws SQLException
	{
		Stock s = new Stock();
		s.setId(rs.getInt("stock_id"));
		s.setQuantity(rs.getInt("quantity"));
		s.setOpposite(rs.getBoolean("opposite"));
		s.setOwnerId(rs.getInt("owner_id"));
		s.setMarketId(rs.getInt("market_id"));
		return s;
	}

	@Override
	public Stock getStock(int id) throws DAOException
	{
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		Stock s = null;

		try
		{
			conn = this.factory.getConnection();
			String req = "SELECT * FROM stocks WHERE stock_id=?;";
			ps = DAOUtil.getPreparedStatement(conn, req, id);
			rs = ps.executeQuery();

			if (rs.next())
				s = map(rs);
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
	public Stock createStock(int quantity, boolean opposite, int owner_id, int market_id) throws DAOException
	{
		//TODO use generated_keys ?
		return null;
	}
	
	@Override
	public Stock[] splitStock(Stock stock, int quantityToDraw)
	{
		//TODO
		return null;
	}

}