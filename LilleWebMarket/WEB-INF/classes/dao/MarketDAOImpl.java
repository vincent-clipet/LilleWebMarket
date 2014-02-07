package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import java.io.StringWriter;
import java.io.PrintWriter;
//import org.postgresql.util.PGInterval;

import beans.Market;
import beans.User;
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

	public void putBid(int bidQuantity, int bidPrice, int marketId, boolean opposite, User u)
	{
		opposite = !opposite;
		int userId = u.getId();
		Connection conn = null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		ResultSet rs = null;
		ResultSet rsK = null;

		//String log = "";

		try
		{
			conn = this.factory.getConnection();

			// Get only price-matching asks list
			// Testing request
			// SELECT sl.stock_id as stockid, owner_id, quantity, (100-price_sell) as price FROM markets m, stocks st, sells sl WHERE m.market_id = 4 AND opposite = false AND st.stock_id = sl.stock_id AND m.market_id = st.market_id AND (100-price_sell) < 25 order by price desc;

			String req = "SELECT sl.stock_id as stockid, owner_id, quantity, (100-price_sell) as price"
					+ " FROM markets m, stocks st, sells sl"
					+ " WHERE m.market_id = ? AND opposite = ? AND st.stock_id = sl.stock_id AND m.market_id = st.market_id AND (100-price_sell) <= ? order by price asc;";

			ps = DAOUtil.getPreparedStatement(conn, req, marketId, opposite, bidPrice);
			rs = ps.executeQuery();

			// DEBUG
			String req2 = null;

			//log += " bidQuantity:"+ bidQuantity+" bidPrice:"+ bidPrice +" userId:"+userId+" marketId:"+ marketId+" opposite:"+ opposite+"<br>";

			// While there is price-matching asks, we do the math.
			// TODO : need to handle stocks fragmentation.
			while (rs.next() && bidQuantity > 0)
			{
				int stockId = rs.getInt("stockid");
				int availableQuantity = rs.getInt("quantity");
				int ownerId = rs.getInt("owner_id");
				int sellPrice = rs.getInt("price");

				//log += " stockId:"+stockId+" availableQuantity:"+availableQuantity+" ownerId:"+ownerId+" sellPrice:"+sellPrice+"<br>";
				//log += "Après get<br>"; // DEBUG

				if (availableQuantity <= bidQuantity)
				{
					//log += "1.0<br>"; // DEBUG

					int exchangeQuantity = availableQuantity;
					int totalExchange = exchangeQuantity * sellPrice;

					bidQuantity -= exchangeQuantity;

					//  ! ! Attention à opposite ! !
					// Initier une transaction ?
					//log += "1.0.1<br>"; // DEBUG

					req2 = "INSERT INTO stocks (quantity, opposite, owner_id, market_id) VALUES (?, ?, ?, ?);";
					//log += "1.0.2<br>"; // DEBUG
					ps2 = DAOUtil.getPreparedStatement(conn, req2, exchangeQuantity, new Boolean(! opposite), userId, marketId);
					//log += "1.0.3<br>"; // DEBUG
					ps2.executeUpdate();
					//log += "1.1<br>"; // DEBUG


					req2 = "DELETE FROM sells WHERE stock_id = ?;";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, stockId);
					ps2.executeUpdate();
					//log += "1.2<br>"; // DEBUG

					req2 = "UPDATE users SET money = money + ? WHERE user_id = ?;";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, totalExchange, ownerId);
					ps2.executeUpdate();
					//log += "1.3<br>"; // DEBUG

					req2 = "UPDATE users SET money = money - ? WHERE user_id = ?;";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, totalExchange, userId);
					ps2.executeUpdate();

					if (u.getId() != ownerId)
						u.setMoney(u.getMoney() - totalExchange);

					//log += "1.4<br>"; // DEBUG

					req2 = "INSERT INTO logs VALUES (default, TIMESTAMP 'now', ?, ?, ?);";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, sellPrice, exchangeQuantity, marketId);
					ps2.executeUpdate();
					//log += "1.5<br>"; // DEBUG
				}
				else
				{
					int exchangeQuantity = bidQuantity;
					int totalExchange = exchangeQuantity * sellPrice;

					availableQuantity -= exchangeQuantity;

					bidQuantity = 0;

					req2 = "INSERT INTO stocks (quantity, opposite, owner_id, market_id) VALUES (?, ?, ?, ?);";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, exchangeQuantity, new Boolean (! opposite), userId, marketId);
					ps2.executeUpdate();
					//log += "2.1<br>"; // DEBUG

					req2 = "UPDATE stocks SET quantity = ? WHERE stock_id = ?;";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, availableQuantity, stockId);
					ps2.executeUpdate();
					//log += "2.2<br>"; // DEBUG

					req2 = "UPDATE users SET money = money + ? WHERE user_id = ?;";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, totalExchange, ownerId);
					ps2.executeUpdate();
					//log += "2.3<br>"; // DEBUG

					req2 = "UPDATE users SET money = money - ? WHERE user_id = ?;";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, totalExchange, userId);
					ps2.executeUpdate();

					if (u.getId() != ownerId)
						u.setMoney(u.getMoney() - totalExchange);

					//log += "2.4<br>"; // DEBUG

					req2 = "INSERT INTO logs VALUES (default, TIMESTAMP 'now', ?, ?, ?);";
					ps2 = DAOUtil.getPreparedStatement(conn, req2, sellPrice, exchangeQuantity, marketId);
					ps2.executeUpdate();
					//log += "2.5<br>"; // DEBUG
				}
			}
			if (bidQuantity > 0)
			{
				//log += "3.1 bidQuantity " + bidQuantity + " opposite:"+opposite+" userid:"+userId+" marketid:"+marketId+"<br>";
				req2 = "INSERT INTO stocks VALUES (default, ?, ?, ?, ?);";
				ps2 = conn.prepareStatement(req2, PreparedStatement.RETURN_GENERATED_KEYS);
				ps2.setObject(1, bidQuantity);
				ps2.setObject(2, new Boolean(! opposite));
				ps2.setObject(3, userId);
				ps2.setObject(4, marketId);

				ps2.executeUpdate();
				//log += "Update if (bidQuant > 0) (Insert into stock)<br>"; // DEBUG
				long key = -1L;
				rsK = ps2.getGeneratedKeys();
				if (rsK != null && rsK.next())
					key = rsK.getLong(1);

				//log += "key:" + key+"<br>";

				// Retrieve new stock_id
				req2 = "INSERT INTO sells VALUES (default, TIMESTAMP 'now', ?, ?);";
				ps2 = DAOUtil.getPreparedStatement(conn, req2, bidPrice, key);
				ps2.executeUpdate();

				//log += "Update if (bidQuant > 0) (Insert into sells)<br>"; // DEBUG
			}
			//log += "4<br>"; // DEBUG
		}
		catch (SQLException e)
		{
			//log += e.getMessage();
			throw new DAOException(e);
		}
		finally
		{
			DAOUtil.close(rsK);
			DAOUtil.close(ps2);
			DAOUtil.close(rs, ps, conn);
		}

		//return log;
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
			String req = "SELECT login as ownername, quantity, price_sell as price"
					+ " FROM sells sl, stocks st, users u"
					+ " WHERE st.market_id = ? AND owner_id = user_id AND sl.stock_id = st.stock_id AND opposite = ? ORDER BY price DESC";

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

	public boolean[] hasEndedAndMustBeConfirmed(int marketId, int userId)
	{
		Connection conn = null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;
		boolean ret[] = new boolean[2];

		try
		{
			conn = this.factory.getConnection();
			String req = "SELECT COUNT(*) FROM markets WHERE market_id=? AND end_date < TIMESTAMP 'now';";
			ps = DAOUtil.getPreparedStatement(conn, req, marketId);
			rs = ps.executeQuery();

			if (rs.next())
			{
				ret[0] = (rs.getInt(1) == 1 ? true : false);

				String req2 = "SELECT COUNT(*) FROM markets WHERE market_id=? AND winner IS NULL AND creator_id=?;";
				ps2 = DAOUtil.getPreparedStatement(conn, req2, marketId, userId);
				rs2 = ps2.executeQuery();

				if (rs2.next())
					ret[1] = (rs2.getInt(1) == 1 ? true : false);
			}
		}
		catch (SQLException e)
		{
			throw new DAOException(e);
		}
		finally
		{
			DAOUtil.close(rs, ps, conn);
			DAOUtil.close(rs2);
			DAOUtil.close(ps2);
		}

		return ret;
	}

	public void closeMarket(int marketId, boolean winner)
	{
		//String req = "UPDATE stocks S, users U SET U.money=U.money + 100 * "; // pay users //TODO: see for only 1 request
		// SELECT SUM(quantity) AS req_sum,owner_id AS req_owner_id FROM stocks WHERE market_id=4 AND opposite='false' GROUP BY owner_id;
		//String req2 = "DELETE FROM markets WHERE market_id=? ;"; // destroy market

		Connection conn = null;
		PreparedStatement ps = null;
		PreparedStatement ps2 = null;
		PreparedStatement ps3 = null;
		ResultSet rs = null;
		ResultSet rs2 = null;

		try
		{
			conn = this.factory.getConnection();

			String req = "SELECT SUM(quantity) AS req_sum, owner_id AS req_owner_id FROM stocks WHERE market_id=? AND opposite=? GROUP BY owner_id;";
			ps = DAOUtil.getPreparedStatement(conn, req, marketId, winner);
			rs = ps.executeQuery();

			while (rs.next())
			{
				int stocks = rs.getInt("req_sum");
				int userId = rs.getInt("req_owner_id");
				String req2 = "UPDATE users SET money = money + 100 * ? WHERE user_id=?;";
				ps2 = DAOUtil.getPreparedStatement(conn, req2, stocks, userId);
				ps2.executeUpdate();
			}

			String req3 = "DELETE FROM markets WHERE market_id=?;";
			ps3 = DAOUtil.getPreparedStatement(conn, req3, marketId);
			ps3.executeUpdate();
		}
		catch (SQLException e)
		{
		    String err = e.toString();
		    StringWriter sw = new StringWriter();
		    PrintWriter pw = new PrintWriter(sw);
		    e.printStackTrace(pw);
		    err += sw.toString();
		    throw new DAOException(err);
		}
		finally
		{
			DAOUtil.close(rs, ps, conn);
			DAOUtil.close(rs2);
			DAOUtil.close(ps2);
			DAOUtil.close(ps3);
		}
	}

}
