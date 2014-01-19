package beans;


public class Market
{

    //
    // --- Attributes ----------------------------
    //
    private int market_id;
    private String info;
    private String opposite_info;
    private String end_date; // TODO: Voir l'utilisation des types Date de java
    private boolean result;
    private int creator_id;
	
    //
    // --- Constructors ----------------------------
    //
	
    public Market()
    {
	
    }
	
    public Market(int market_id, String info, String opposite_info, String end_date, boolean result, int creator_id)
    {
	this.market_id = market_id;
	this.info = info;
	this.opposite_info = opposite_info;
	this.end_date = end_date;
	this.result = result;
	this.creator_id = creator_id;
    }
	
    //
    // --- Get & Set ----------------------------
    //
    
    public void setMarket_id(int market_id)
    {
	this.market_id = market_id;
    }

    public int getMarket_id ()
    {
	return market_id;
    }


    public void setInfo(String info)
    {
	this.info = info;
    }

    public String getInfo ()
    {
	return info;
    }

    public void setOpposite_info(String opposite_info)
    {
	this.opposite_info = opposite_info;
    }

    public String getOpposite_info ()
    {
	return opposite_info;
    }

    public void setEnd_date(String end_date)
    {
	this.end_date = end_date;
    }

    public String getEnd_date ()
    {
	return end_date;
    }

    public void setResult(boolean result)
    {
	this.result = result;
    }

    public boolean getResult ()
    {
	return result;
    }

    public void setCreator_id(int creator_id)
    {
	this.creator_id = creator_id;
    }

    public int getCreator_id ()
    {
	return creator_id;
    }
}
