package dao;

/** Exception personnalisée pour toutes les erreurs liées à la couche DAO */
public class DAOException extends RuntimeException
{

	public DAOException(String msg)
	{
		super(msg);
	}
	
	public DAOException(Throwable cause)
	{
        super(cause);
    }

}