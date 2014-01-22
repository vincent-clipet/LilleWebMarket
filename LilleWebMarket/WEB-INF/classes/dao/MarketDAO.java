package dao;

import beans.Market;

public interface MarketDAO
{

	/** Gets the user corresponding to this login
	 * @return the asked user if it existed, else null  */
        Market getMarket(int market_id, Market m) throws DAOException;
	
	/** Creates a new user in database
	 * @return the created user */
    Market createMarket(String info, String opposite_info, String end_date, int creator_id, Market m) throws DAOException;
	
}