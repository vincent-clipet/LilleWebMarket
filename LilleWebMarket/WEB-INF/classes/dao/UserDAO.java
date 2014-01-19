package dao;

import beans.User;

public interface UserDAO
{

	/** Gets the user corresponding to this login
	 * @return the asked user if it existed, else null  */
	User getUser(String login) throws DAOException;
	
	/** Creates a new user in database
	 * @return the created user */
	User createUser(String login, String password) throws DAOException;
	
	boolean promote(String role);
	
	boolean demote(String role);
	
}