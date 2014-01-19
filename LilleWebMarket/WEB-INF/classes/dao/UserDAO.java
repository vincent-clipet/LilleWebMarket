package dao;

import beans.User;

public interface UserDAO
{

	User getUser(String login) throws DAOException;
	
	User createUser(String login, String password) throws DAOException;
	
}