package dao;

import beans.Stock;

public interface StockDAO
{

	/** Récupère une action via son ID */
	Stock getStock(int id, Stock s) throws DAOException;

	/** Crée une action dans la base de données */
	Stock createStock(int quantity, boolean opposite, int owner_id, int market_id, Stock s) throws DAOException;

}
