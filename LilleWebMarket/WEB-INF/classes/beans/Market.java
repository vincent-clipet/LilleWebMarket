package beans;


public class Market
{

	//
	// --- Attributes ----------------------------
	//
	private int marketId;
	private String info;
	private String oppositeInfo;
	private String endDate;
	private boolean winner;
	private int creatorId;

	//
	// --- Constructors ----------------------------
	//

	public Market()
	{

	}

	public Market(int market_id, String info, String opposite_info, String end_date, boolean winner, int creator_id)
	{
		this.marketId = market_id;
		this.info = info;
		this.oppositeInfo = opposite_info;
		this.endDate = end_date;
		this.winner = winner;
		this.creatorId = creator_id;
	}

	//
	// --- Get & Set ----------------------------
	//
	public void setMarketId(int marketId)
	{
		this.marketId = marketId;
	}

	public int getMarketId()
	{
		return marketId;
	}

	public void setInfo(String info)
	{
		this.info = info;
	}

	public String getInfo()
	{
		return info;
	}

	public void setOppositeInfo(String oppositeInfo)
	{
		this.oppositeInfo = oppositeInfo;
	}

	public String getOppositeInfo()
	{
		return oppositeInfo;
	}

	public void setEndDate(String endDate)
	{
		this.endDate = endDate;
	}

	public String getEndDate()
	{
		return endDate;
	}

	public void setWinner(boolean winner)
	{
		this.winner = winner;
	}

	public boolean getWinner()
	{
		return winner;
	}

	public void setCreatorId(int creatorId)
	{
		this.creatorId = creatorId;
	}

	public int getCreatorId()
	{
		return creatorId;
	}
}
