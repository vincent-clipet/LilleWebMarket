

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
	
	
	


	//
	// --- Methods ----------------------------
	//
	
	
	
	

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
