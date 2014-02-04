package beans;


public class Sell
{

	//
	// --- Attributes ----------------------------
	//
	private String ownerName;	
	private int quantity;
	private int price;


	//
	// --- Constructors ----------------------------
	//
	public Sell()
	{

	}

	public Sell(String ownerName, int quantity, int price)
	{
		this.ownerName = ownerName;
		this.quantity = quantity;
		this.price = price;
	}



	//
	// --- Get & Set ----------------------------
	//
	public String getOwnerName()
	{
		return ownerName;
	}

	public void setOwnerName(String ownerName)
	{
		this.ownerName = ownerName;
	}

	public int getQuantity()
	{
		return quantity;
	}

	public void setQuantity(int quantity)
	{
		this.quantity = quantity;
	}

	public int getPrice()
	{
		return price;
	}

	public void setPrice(int price)
	{
		this.price = price;
	}
}
