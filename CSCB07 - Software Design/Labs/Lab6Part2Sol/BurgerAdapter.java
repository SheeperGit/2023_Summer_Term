public class BurgerAdapter implements FoodItemInterface {
	private Burger burger;
	
	public BurgerAdapter(Burger burger) {
		this.burger = burger;
	}
	
	@Override
	public void customize() {
		burger.customize();
	}
	
	@Override
	public void prepare() {
		burger.prepare();
	}
	
	@Override
	public void box() {
		burger.box();
	}

}
