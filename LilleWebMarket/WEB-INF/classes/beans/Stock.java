package beans;

public class Stock
{

	//
	// --- Attributes ----------------------------
	//
	private int id;
	private int quantity;
	private boolean opposite;
	private int owner_id;
	private int market_id;



	//
	// --- Constructors ----------------------------
	//
	public Stock()
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

	public int getQuantity()
	{
		return this.quantity;
	}

	public void setQuantity(int quantity)
	{
		this.quantity = quantity;
	}

	public boolean getOpposite()
	{
		return this.opposite;
	}

	public void setOpposite(boolean opposite)
	{
		this.opposite = opposite;
	}

	public int getOwnerId()
	{
		return this.owner_id;
	}

	public void setOwnerId(int owner_id)
	{
		this.owner_id = owner_id;
	}

	public int getMarketId()
	{
		return this.market_id;
	}

	public void setMarketId(int market_id)
	{
		this.market_id = market_id;
	}

}