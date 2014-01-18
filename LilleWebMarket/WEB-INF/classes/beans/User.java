package beans;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;



public class User
{

	//
	// --- Attributes ----------------------------
	//
	private int id;
	private String login;
	private transient String password;
	private String role;
	private int money;




	//
	// --- Constructors ----------------------------
	//
	public User()
	{
		
	}
	
	private User(int id, String login, String password, String role, int money)
	{
		this.id = id;
		this.login = login;
		this.password = password;
		this.role = role;
		this.money = money;
	}





	//
	// --- Methods ----------------------------
	//
	public static User getUser(String login)
	{
		try
		{
			Context initialContext = new InitialContext();
			Context context = (Context) initialContext.lookup("java:comp/env");
			DataSource ds = (DataSource) context.lookup("base1"); //TODO: config
			Connection conn = ds.getConnection();
			Statement st = conn.createStatement();
			
			ResultSet rs = st.executeQuery("SELECT * FROM users WHERE login='"+ login +"';");
			rs.next();
			
			return new User(rs.getInt("user_id"), rs.getString("login"), rs.getString("password"), rs.getString("role"), rs.getInt("money"));
		}
		catch (NamingException e)
		{
			e.printStackTrace();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		
		return null;
	}
	
	public static User getNewUser(String login, String password)
	{
		try
		{
			Context initialContext = new InitialContext();
			Context context = (Context) initialContext.lookup("java:comp/env");
			DataSource ds = (DataSource) context.lookup("base1"); //TODO: config
			Connection conn = ds.getConnection();
			Statement st = conn.createStatement();
			
			st.executeUpdate("INSERT INTO users(login, password) VALUES('"+ login +"', '"+ password +"');");
			ResultSet rs = st.executeQuery("SELECT * FROM users WHERE login='"+ login +"';");
			rs.next();
			
			return new User(rs.getInt("user_id"), rs.getString("login"), rs.getString("password"), rs.getString("role"), rs.getInt("money"));
		}
		catch (NamingException e)
		{
			e.printStackTrace();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		
		return null;
	}





	//
	// --- Get & Set ----------------------------
	//
	public int getId()
	{
		return this.id;
	}

	public void setId(int id)
	{
		this.id = id;
	}

	public String getLogin()
	{
		return this.login;
	}

	public void setLogin(String login)
	{
		this.login = login;
	}

	public String getPassword()
	{
		return this.password;
	}

	public void setPasswword(String password)
	{
		this.password = password;
	}

	public String getRole()
	{
		return this.role;
	}

	public void setRole(String role)
	{
		this.role = role;
	}

	public int getMoney()
	{
		return this.money;
	}

	public void setMoney(int money)
	{
		this.id = money;
	}

}
