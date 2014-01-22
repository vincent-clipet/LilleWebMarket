package dao;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DAOFactory
{

	//
	// ATTRIBUTES
	//
	private DataSource ds;
	private final static String filename = "/bdd_config.txt"; 



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
	public static DAOFactory getInstance() throws DAOConfigException
	{
		Properties properties = new Properties();
		//String db_url;
		String db_driver;
		//String db_user;
		//String db_password;
		DataSource pool = null;

		ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
		InputStream content = classLoader.getResourceAsStream(filename);

		if (content == null)
			throw new DAOConfigException("Properties file "+ filename +" not found.");

		try
		{
			properties.load(content);
			//db_url = properties.getProperty("db_url");
			//db_driver = properties.getProperty("db_driver");
			db_driver = "org.postgresql.Driver"; //TODO: config
			//db_user = properties.getProperty("db_user");
			//db_password = properties.getProperty("db_password");
		}
		catch (FileNotFoundException e)
		{
			throw new DAOConfigException("Properties file "+ filename +" not found.");
		}
		catch ( IOException e )
		{
			throw new DAOConfigException("Can't load properties file " + filename + ".");
		}
		
		try
		{
			Class.forName(db_driver);
		}
		catch ( ClassNotFoundException e )
		{
			throw new DAOConfigException("Can't load driver " + db_driver + ".");
		}

		try
		{
			Context initialContext = new InitialContext();
			Context envContext = (Context) initialContext.lookup("java:/comp/env");
			DataSource datasource = (DataSource) envContext.lookup("jdbc/base1"); //TODO: config
			pool = datasource;
		}
		catch (NamingException e)
		{
			e.printStackTrace();
			throw new DAOConfigException("Error while configuring connection pool.");
		}

		DAOFactory instance = new DAOFactory(pool);
		return instance;
	}

	Connection getConnection() throws SQLException
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
