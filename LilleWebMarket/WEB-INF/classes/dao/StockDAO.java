package dao;

import beans.Stock;

public interface StockDAO
{

	/** Gets the stock corresponding to this ID
	 * @return the asked stock if it existed, else null  */
	Stock getStock(int id) throws DAOException;
	
	/** Creates a new stock in database
	 * @return the created stock */
	Stock createStock(int quantity, boolean opposite, int owner_id, int market_id) throws DAOException;
	
	/** Split the given stock into 2
	 * @return Array containing 2 stocks :
	 * [0] : the old stock, with its new quantity
	 * [1] : the new stock, with the asked quantity to draw */
	Stock[] splitStock(Stock stock, int quantityToDraw) throws DAOException;
	
	
	
}