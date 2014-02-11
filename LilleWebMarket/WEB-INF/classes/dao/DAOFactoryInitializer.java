package dao;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/** Lsteneur permettant de charger la DAOFactory dans le contexte actuel au lancement de l'application */
public class DAOFactoryInitializer implements ServletContextListener
{
	
	//
	// ATTRIBUTES
	//
	private DAOFactory factory;
	
	

	//
	// METHODS
	//
	@Override
	public void contextDestroyed(ServletContextEvent e)
	{
		
	}

	@Override
	public void contextInitialized(ServletContextEvent e)
	{
		ServletContext sc = e.getServletContext();
        this.factory = DAOFactory.getInstance(sc.getInitParameter("db_driver")); //TODO
        sc.setAttribute("dao_factory", this.factory);
	}

}