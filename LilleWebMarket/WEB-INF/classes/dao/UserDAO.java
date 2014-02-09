package dao;

import beans.User;

public interface UserDAO
{

	/** Récupère un utilisateur grâce à son login */
	User getUser(String login, User u) throws DAOException;
	
	/** Crée un nouvel utilisateur dans la base de données */
	User createUser(String login, String password, User u) throws DAOException;
	
}
