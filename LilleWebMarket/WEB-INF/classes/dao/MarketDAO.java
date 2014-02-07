package dao;

import java.util.ArrayList;

import beans.Market;
import beans.User;
import beans.Sell;

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
	Market createMarket(String info, String opposite_info, int hours, int creator_id, Market m) throws DAOException;

	/** Returns an arraylist of asks
	 * for this market (side according to the boolean)
	 */
	ArrayList<Sell> getAsks(int market_id, boolean opposite);

	/** Returns an arraylist of bids
	 * for this market (side according to the boolean)
	 */
        ArrayList<Sell> getBids(int market_id, boolean opposite);

	/** Try to put a bid with specified parameters
	 * @return an information message about the transaction.
	 */
        void putBid(int bidQuantity, int bidPrice, int marketId, boolean opposite, User u);

	/** Return formated exchange data to use in
	 * graphical representation
	 */
	String getLogData(int marketId);
	
	/** Gets the status of a market
	 * @return true if market has ended, else false  */
	boolean[] hasEndedAndMustBeConfirmed(int marketId, int userId);
	
	/** Close a market, paying all winners & deleting all sells */
	void closeMarket(int marketId, boolean winner);

}
