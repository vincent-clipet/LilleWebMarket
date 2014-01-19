package beans;



public class User
{

	//
	// --- Attributes ----------------------------
	//
	private int id;
	private String login;
	private transient String password;
	//private String[] roles;
	private int money;




	//
	// --- Constructors ----------------------------
	//
	public User()
	{

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

	public void setPassword(String password)
	{
		this.password = password;
	}

	public int getMoney()
	{
		return this.money;
	}

	public void setMoney(int money)
	{
		this.money = money;
	}

}
