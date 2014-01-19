package dao;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

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
        this.factory = DAOFactory.getInstance();
        sc.setAttribute("dao_factory", this.factory);
	}

}