package beans;

public class Stock
{

	//
	// --- Attributes ----------------------------
	//
	private int id;
	private int quantity;
	private boolean opposite;
	private int ownerId;
	private int marketId;



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
		return this.ownerId;
	}

	public void setOwnerId(int ownerId)
	{
		this.ownerId = ownerId;
	}

	public int getMarketId()
	{
		return this.marketId;
	}

	public void setMarketId(int marketId)
	{
		this.marketId = marketId;
	}

}
