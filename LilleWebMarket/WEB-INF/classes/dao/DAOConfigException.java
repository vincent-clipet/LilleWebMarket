package dao;

public class DAOConfigException extends RuntimeException
{

	public DAOConfigException( String message )
	{
		super(message);
	}

	public DAOConfigException(Throwable cause)
	{
		super(cause);
	}

}