package dao;

import java.util.ArrayList;

import beans.Market;

public interface MarketDAO
{

	/** Gets the market corresponding to this id
	 * @return the asked market if it existed, else null  */
        Market getMarket(int market_id, Market m) throws DAOException;
        
     /** Gets the next n markets which will end
	 * @return the n next markets */
        ArrayList<Market> getNextMarkets(int nb) throws DAOException;
	
	/** Creates a new market in database
	 * @return the created market */
    Market createMarket(String info, String opposite_info, String end_date, int creator_id, Market m) throws DAOException;
	
}
