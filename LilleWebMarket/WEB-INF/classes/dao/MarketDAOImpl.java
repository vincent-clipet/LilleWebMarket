package dao;

import java.util.ArrayList;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import beans.Market;
import beans.Sell;


public class MarketDAOImpl implements MarketDAO
{

    //
    // ATTRIBUTES
    //
    private DAOFactory factory;


    //
    // CONSTRUCTOR
    //
    MarketDAOImpl(DAOFactory factory)
	{
	    this.factory = factory;
	}
    

    //
    // METHODS
    //	
    private Market map(ResultSet rs, Market m) throws SQLException
    {
	if (m == null)
	    m = new Market();
			
	m.setMarket_id(rs.getInt("market_id"));
	m.setInfo(rs.getString("info"));
	m.setOpposite_info(rs.getString("opposite_info"));
	m.setEnd_date(rs.getString("end_date"));
	m.setWinner(rs.getBoolean("winner"));
	m.setCreator_id(rs.getInt("creator_id"));

	return m;
    }


    private Sell mapSell(ResultSet rs, Sell s) throws SQLException
    {
	if (s == null)
	    s = new Sell();

	s.setOwnerName(rs.getString("ownername"));
	s.setQuantity(rs.getInt("quantity"));
	s.setPrice(rs.getInt("price"));

	return s;
    }

    /** Gets the market corresponding to this id
     * @return the asked user if it existed, else null  */
    public Market getMarket(int market_id, Market m) throws DAOException
    {
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;

	try
	    {
		conn = this.factory.getConnection();
		String req = "SELECT * FROM markets WHERE market_id=?;";
		ps = DAOUtil.getPreparedStatement(conn, req, market_id);
		rs = ps.executeQuery();

		if (rs.next())
		    m = map(rs, m);
	    }
	catch (SQLException e)
	    {
		throw new DAOException(e);
	    }
	finally
	    {
		DAOUtil.close(rs, ps, conn);
	    }

	return m;
	
    }


    /** Creates a new market in database
     * @return the created market */
    public Market createMarket(String info, String opposite_info, String end_date, int creator_id, Market m) throws DAOException
    {
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	
	try
	    {
		conn = this.factory.getConnection();

		String req =  "INSERT INTO markets(info, opposite_info, end_date, creator_id) VALUES(?,?,?,?);";
		ps = DAOUtil.getPreparedStatement(conn, req, info, opposite_info, end_date, creator_id);
		ps.executeUpdate();
		DAOUtil.close(ps);
	    
		req = "SELECT * FROM markets WHERE info=? AND opposite_info=? AND end_date=? AND creator_id=?;";
		ps = DAOUtil.getPreparedStatement(conn, req, info, opposite_info, end_date, creator_id);
		rs = ps.executeQuery();

		if (rs.next())
		    m = map(rs, null);
	    }
	catch (SQLException e)
	    {
		throw new DAOException(e);
	    }
	finally
	    {
		DAOUtil.close(rs, ps, conn);
	    }

	return m;
    }

    public ArrayList<Sell> getAsks(int market_id, boolean opposite)
    {
	opposite = !opposite;
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	ArrayList<Sell> ret = new ArrayList<Sell>();

	try
	    {
		conn = this.factory.getConnection();
		
		//		String req = "SELECT * FROM stocks WHERE winner IS NOT NULL ORDER BY end_date ASC LIMIT ?;";


		String req = "SELECT login as ownername, quantity, (100-price_sell) as price";
		req += " FROM sells sl, stocks st, users u";
		req += " WHERE st.market_id = ? AND owner_id = user_id AND sl.stock_id = st.stock_id AND opposite = ? ORDER BY price DESC";

		ps = DAOUtil.getPreparedStatement(conn, req, market_id,opposite);
		rs = ps.executeQuery();
				
		while (rs.next())
		    ret.add(mapSell(rs, null));
	    }
	catch (SQLException e)
	    {
		throw new DAOException(e);
	    }
	finally
	    {
		DAOUtil.close(rs, ps, conn);
	    }

	return ret;

    }
    
    public ArrayList<Sell> getBids(int market_id, boolean opposite)
    {
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	ArrayList<Sell> ret = new ArrayList<Sell>();

	try
	    {
		conn = this.factory.getConnection();
		
		//		String req = "SELECT * FROM stocks WHERE winner IS NOT NULL ORDER BY end_date ASC LIMIT ?;";


		String req = "SELECT login as ownername, quantity, price_sell as price";
		req += " FROM sells sl, stocks st, users u";
		req += " WHERE st.market_id = ? AND owner_id = user_id AND sl.stock_id = st.stock_id AND opposite = ? ORDER BY price DESC";

		ps = DAOUtil.getPreparedStatement(conn, req, market_id, opposite);
		rs = ps.executeQuery();
				
		while (rs.next())
		    ret.add(mapSell(rs, null));
	    }
	catch (SQLException e)
	    {
		throw new DAOException(e);
	    }
	finally
	    {
		DAOUtil.close(rs, ps, conn);
	    }

	return ret;

    }
    
    public ArrayList<Market> getNextMarkets(int nb)
    {
    	Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		ArrayList<Market> ret = new ArrayList<Market>(nb);

		try
		{
			conn = this.factory.getConnection();
			String req = "SELECT * FROM markets WHERE winner IS NULL ORDER BY end_date ASC LIMIT ?;";
			ps = DAOUtil.getPreparedStatement(conn, req, nb);
			rs = ps.executeQuery();
				
			while (rs.next())
				ret.add(map(rs, null));
		}
		catch (SQLException e)
		{
			throw new DAOException(e);
		}
		finally
		{
			DAOUtil.close(rs, ps, conn);
		}

		return ret;
    }
}
