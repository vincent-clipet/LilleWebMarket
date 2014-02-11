package dao;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

/** Factory permettant d'unifier les interactions avec la base de données (pool de connexion, etc ...
 * mais également de  */ 
public class DAOFactory
{

	//
	// ATTRIBUTES
	//
	private DataSource ds; 



	//
	// CONSTRUCTOR
	//
	DAOFactory(DataSource ds)
	{
		this.ds = ds;
	}



	//
	// METHODS
	//
	/** Charge la DAOFactory au lancement de l'application */
	public static DAOFactory getInstance(String db_driver) throws DAOException
	{
		DataSource pool = null;
		
		try
		{
			Class.forName(db_driver);
		}
		catch (ClassNotFoundException e)
		{
			throw new DAOException("Can't load driver " + db_driver + ".");
		}

		try
		{
			Context initialContext = new InitialContext();
			Context envContext = (Context) initialContext.lookup("java:/comp/env");
			DataSource datasource = (DataSource) envContext.lookup("jdbc/base1");
			pool = datasource;
		}
		catch (NamingException e)
		{
			e.printStackTrace();
			throw new DAOException("Error while configuring connection pool.");
		}

		DAOFactory instance = new DAOFactory(pool);
		return instance;
	}

	Connection getConnection() throws SQLException, NullPointerException
	{
		return this.ds.getConnection();
	}

	public UserDAO getUserDAO()
	{
		return new UserDAOImpl(this);
	}
	
	public StockDAO getStockDAO()
	{
		return new StockDAOImpl(this);
	}
	
	public MarketDAO getMarketDAO()
	{
		return new MarketDAOImpl(this);
	}

}
