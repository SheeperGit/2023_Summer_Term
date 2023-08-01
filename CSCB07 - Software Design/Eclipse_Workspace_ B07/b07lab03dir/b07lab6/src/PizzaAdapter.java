
public class PizzaAdapter implements FoodItemInterface {
	private Pizza pizza;
	
	public PizzaAdapter(Pizza pizza) {
		this.pizza = pizza;
	}
	
	@Override
	public void customize() {
		pizza.customize();
	}

	@Override
	public void prepare() {
		pizza.prepare();
	}
	
	@Override
	public void box() {
		pizza.box();
	}
}
