
public abstract class FoodItem implements FoodItemInterface {
	String type;
	
	public abstract void customize();
	public abstract void prepare();
	public abstract void box();
}
