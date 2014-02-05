package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
//import org.postgresql.util.PGInterval;

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

		m.setMarketId(rs.getInt("market_id"));
		m.setInfo(rs.getString("info"));
		m.setOppositeInfo(rs.getString("opposite_info"));
		m.setEndDate(rs.getString("end_date"));
		m.setWinner(rs.getBoolean("winner"));
		m.setCreatorId(rs.getInt("creator_id"));

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
	public Market createMarket(String info, String opposite_info, int hours, int creator_id, Market m) throws DAOException
	{
		Connection conn = null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		ResultSet rs = null;
		ResultSet rsK = null;

		try
		{
			conn = this.factory.getConnection();

			String req = "INSERT INTO markets(info, opposite_info, end_date, creator_id) VALUES(?, ?, current_timestamp + interval '24 hours', ?);";
			ps = conn.prepareStatement(req, PreparedStatement.RETURN_GENERATED_KEYS);

			ps.setString(1, info);
			ps.setString(2, opposite_info);
			ps.setInt(3, creator_id);

			ps.executeUpdate();
			rsK = ps.getGeneratedKeys();

			if (rsK.next())
			{
				long key = rsK.getLong(1);

				req = "SELECT * FROM markets WHERE market_id=?;";
				ps2 = DAOUtil.getPreparedStatement(conn, req, (int) key);
				rs = ps2.executeQuery();

				if (rs.next())
					m = map(rs, m);
			}
		}
		catch (SQLException e)
		{
			throw new DAOException(e);
		}
		finally
		{
			DAOUtil.close(rsK, ps, conn);
			DAOUtil.close(rs);
			DAOUtil.close(ps2);
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
			req += " WHERE st.market_id = ? AND owner_id = user_id AND sl.stock_id = st.stock_id AND opposite = ? ORDER BY price DESC;";

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

	public String putBid(int bidQuantity, int bidPrice, int userId, int marketId, boolean opposite)
	{
		opposite = !opposite;
		Connection conn = null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		ResultSet rs = null;
		ResultSet rsK = null;

		String log = "";

		try
		{
			conn = this.factory.getConnection();

			// Get only price-matching asks list

			// Testing request
			// SELECT sl.stock_id as stockid, owner_id, quantity, (100-price_sell) as price FROM markets m, stocks st, sells sl WHERE m.market_id = 4 AND opposite = false AND st.stock_id = sl.stock_id AND m.market_id = st.market_id AND (100-price_sell) < 25 order by price desc;

			String req = "SELECT sl.stock_id as stockid, owner_id, quantity, (100-price_sell) as price";
			req += " FROM markets m, stocks st, sells sl";
			req += " WHERE m.market_id = ? AND opposite = ? AND st.stock_id = sl.stock_id AND m.market_id = st.market_id AND (100-price_sell) <= ? order by price asc;";

			ps = DAOUtil.getPreparedStatement(conn, req, marketId, opposite, bidPrice);
			rs = ps.executeQuery();

			// DEBUG
			int biderMoney = 5000; //TODO : remove
			int askerMoney = 5000;
			String req2 = null;

			log += " bidQuantity:"+ bidQuantity+" bidPrice:"+ bidPrice +" userId:"+userId+" marketId:"+ marketId+" opposite:"+ opposite+"<br>";

			// While there is price-matching asks, we do the math.
			// TODO : need to handle stocks fragmentation.
			while (rs.next() && bidQuantity > 0)
			{
				int stockId = rs.getInt("stockid");
				int availableQuantity = rs.getInt("quantity");
				int ownerId = rs.getInt("owner_id");
				int sellPrice = rs.getInt("price");

				log += " stockId:"+stockId+" availableQuantity:"+availableQuantity+" ownerId:"+ownerId+" sellPrice:"+sellPrice+"<br>";

				log += "Après get<br>"; // DEBUG

				if (availableQuantity <= bidQuantity)
				{

					log += "1.0<br>"; // DEBUG

					int exchangeQuantity = availableQuantity;
					int totalExchange = exchangeQuantity * sellPrice;

					bidQuantity -= exchangeQuantity;

					//  ! ! Attention à opposite ! !
					// Initier une transaction ?
					log += "1.0.1<br>"; // DEBUG

					// "INSERT INTO stocks (quantity, opposite, owner_id, market_id) VALUES (:exchangeQuantity, :opposite, :userId, :marketId);";
					req2 = "INSERT INTO stocks (quantity, opposite, owner_id, market_id) VALUES (?, ?, ?, ?);";
					log += "1.0.2<br>"; // DEBUG
					ps2 = DAOUtil.getPreparedStatement(conn, req2, exchangeQuantity, new Boolean(! opposite), userId, marketId);
					log += "1.0.3<br>"; // DEBUG
					ps2.executeUpdate();
					log += "1.1<br>"; // DEBUG


					// "DELETE FROM sells WHERE stock_id = :stockId;";
					req2 = "DELETE FROM sells WHERE stock_id = ?;";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, stockId);
					ps2.executeUpdate();
					log += "1.2<br>"; // DEBUG

					// "UPDATE users SET money = money + :totalExchange WHERE user_id = :ownerId";
					req2 = "UPDATE users SET money = money + ? WHERE user_id = ?;";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, totalExchange, ownerId);
					ps2.executeUpdate();
					log += "1.3<br>"; // DEBUG

					// "UPDATE users SET money = money - :totalExchange WHERE user_id = :userId"
					req2 = "UPDATE users SET money = money - ? WHERE user_id = ?;";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, totalExchange, userId);
					ps2.executeUpdate();
					log += "1.4<br>"; // DEBUG

					// "INSERT INTO logs VALUES (default, TIMESTAMP 'now', :sellPrice, :exchangeQuantity, :marketId)";
					req2 = "INSERT INTO logs VALUES (default, TIMESTAMP 'now', ?, ?, ?);";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, sellPrice, exchangeQuantity, marketId);
					ps2.executeUpdate();
					log += "1.5<br>"; // DEBUG

				}
				else
				{
					int exchangeQuantity = bidQuantity;
					int totalExchange = exchangeQuantity * sellPrice;

					availableQuantity -= exchangeQuantity;

					bidQuantity = 0;

					// "INSERT INTO stocks (quantity, opposite, owner_id, market_id) VALUES (:exchangeQuantity, :opposite, :userId, :marketId);";
					req2 = "INSERT INTO stocks (quantity, opposite, owner_id, market_id) VALUES (?, ?, ?, ?);";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, exchangeQuantity, new Boolean (! opposite), userId, marketId);
					ps2.executeUpdate();
					log += "2.1<br>"; // DEBUG

					// "UPDATE stocks SET quantity = :availableQuantity WHERE stock_id = :stockId;";
					req2 = "UPDATE stocks SET quantity = ? WHERE stock_id = ?;";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, availableQuantity, stockId);
					ps2.executeUpdate();
					log += "2.2<br>"; // DEBUG

					// "UPDATE users SET money = money + :totalExchange WHERE user_id = :ownerId;";
					req2 = "UPDATE users SET money = money + ? WHERE user_id = ?;";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, totalExchange, ownerId);
					ps2.executeUpdate();
					log += "2.3<br>"; // DEBUG

					// "UPDATE users SET money = money - :totalExchange WHERE user_id = :userId;"
					req2 = "UPDATE users SET money = money - ? WHERE user_id = ?;";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, totalExchange, userId);
					ps2.executeUpdate();
					log += "2.4<br>"; // DEBUG

					// "INSERT INTO logs VALUES (default, TIMESTAMP 'now', :sellPrice, :exchangeQuantity, :marketId) ;";
					req2 = "INSERT INTO logs VALUES (default, TIMESTAMP 'now', ?, ?, ?);";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, sellPrice, exchangeQuantity, marketId);
					ps2.executeUpdate();
					log += "2.5<br>"; // DEBUG

				}
			}
			if (bidQuantity > 0)
			{
				log += "3.1 bidQuantity " + bidQuantity + " opposite:"+opposite+" userid:"+userId+" marketid:"+marketId+"<br>";
				// "INSERT INTO stocks (default, :bidQuantity, :opposite, :userId, :marketId);";
				req2 = "INSERT INTO stocks VALUES (default, ?, ?, ?, ?);";
				ps2 = conn.prepareStatement(req2, PreparedStatement.RETURN_GENERATED_KEYS);
				ps2.setObject(1, bidQuantity);
				ps2.setObject(2, new Boolean(! opposite));
				ps2.setObject(3, userId);
				ps2.setObject(4, marketId);

				ps2.executeUpdate();
				log += "Update if (bidQuant > 0) (Insert into stock)<br>"; // DEBUG
				long key = -1L;
				rsK = ps2.getGeneratedKeys();
				if (rsK != null && rsK.next())
					key = rsK.getLong(1);

				log += "key:" + key+"<br>";

				// Retrieve new stock_id
				// "INSERT INTO sells VALUES (default, TIMESTAMP 'now', :bidPrice, :key);";
				req2 = "INSERT INTO sells VALUES (default, TIMESTAMP 'now', ?, ?);";
				ps2 = DAOUtil.getPreparedStatement(conn, req2, bidPrice, key);
				ps2.executeUpdate();

				log += "Update if (bidQuant > 0) (Insert into sells)<br>"; // DEBUG

			}
			log += "4<br>"; // DEBUG
		}
		catch (SQLException e)
		{
			log += e.getMessage();
			throw new DAOException(e);
		}
		finally
		{
			DAOUtil.close(rsK);
			DAOUtil.close(ps2);
			DAOUtil.close(rs, ps, conn);
		}

		return log;
	}

	public String getLogData(int marketId)
	{
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		String ret = "";

		try
		{
			conn = this.factory.getConnection();
			String req = "SELECT DATE(sell_date) as sdate, log_price, log_quantity FROM logs WHERE market_id = ?";

			ps = DAOUtil.getPreparedStatement(conn, req, marketId);
			rs = ps.executeQuery();

			while (rs.next())
				ret += "['" + rs.getString("sdate") + "',\t" + rs.getInt("log_quantity") + ",\t" + rs.getInt("log_price") + "],\n";
				
			if (!ret.equals(""))
				ret = ret.substring(0, ret.length()-1);
			else
				ret += "['No Data', 0, 0]";
				
			ret += "\n]);";
		}
		catch (SQLException e)
		{
			ret += e.getMessage();
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
		ArrayList<Market> ret = new ArrayList<Market>();

		try
		{
			conn = this.factory.getConnection();

			if (nb != -1)
			{
				String req = "SELECT * FROM markets WHERE winner IS NULL ORDER BY end_date ASC LIMIT ?;";
				ps = DAOUtil.getPreparedStatement(conn, req, nb);
			}
			else
			{
				String req = "SELECT * FROM markets WHERE winner IS NULL ORDER BY end_date ASC;";
				ps = DAOUtil.getPreparedStatement(conn, req);
			}

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
