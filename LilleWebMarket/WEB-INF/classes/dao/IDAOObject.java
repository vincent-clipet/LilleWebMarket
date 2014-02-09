package dao;

import java.sql.ResultSet;
import java.sql.SQLException;

/** Interface DAO */
public interface IDAOObject<T>
{

	/** Map un ResultSet avec l'objet 't' demandé */
	T map(ResultSet rs, T t) throws SQLException;
	
	//T get() throws DAOException; //TODO
	
	//T create() throws SQLException; //TODO
	
	//T delete() throws SQLException; //TODO
	
}
