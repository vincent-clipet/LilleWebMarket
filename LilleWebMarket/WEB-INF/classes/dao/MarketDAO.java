package dao;

import java.util.ArrayList;

import beans.Market;
import beans.User;
import beans.Sell;

public interface MarketDAO
{

	/** Retourne le marché correspondant à cet ID  */
	Market getMarket(int market_id, Market m) throws DAOException;

	/** Retourne les n prochains marchés qui doivent se terminer */
	ArrayList<Market> getNextMarkets(int nb) throws DAOException;

	/** Crée un nouveau marché dans la base de données */
	Market createMarket(String info, String opposite_info, int hours, int creator_id, Market m) throws DAOException;

	/** Retourne la liste des propositions d'achat pour un marché 
	 * (opposite : définit le sens du marché (positif ou négatif)) */
	ArrayList<Sell> getAsks(int market_id, boolean opposite);

	/** Retourne la liste des propositions de vente pour un marché 
	 * (opposite : définit le sens du marché (positif ou négatif)) */
	ArrayList<Sell> getBids(int market_id, boolean opposite);

	/** Tente de créer une proposition d'achat. 
	 * Si la proposition match des propositions de ventes, effectue les transferts d'argenet de d'actions */
	void putBid(int bidQuantity, int bidPrice, int marketId, boolean opposite, User u);

	/** Retourne les données d'un marché formattées pour un affichage graphique */
	String getLogData(int marketId);

	/** Récupère le statut d'un marché
	 * [0] : true si le marché est terminé 
	 * [1] : true si le marché doit être validé & que l'utilisateur actuel est le créateur de ce marché */
	boolean[] hasEndedAndMustBeConfirmed(int marketId, int userId);

	/** Ferme un marché : distribue l'argent et supprime toutes traces du marché dans la base de données */
	void closeMarket(int marketId, boolean winner);

}