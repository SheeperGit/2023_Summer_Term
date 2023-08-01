
public class Driver {
	public static void main(String[] args) {
		BurgerAdapter ba = new BurgerAdapter(new Burger());
		// FoodItem fi = new FoodItem();
		ba.customize();
		ba.prepare();
		ba.box();
	}
}
