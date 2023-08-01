public class PizzaStore {
	FoodItemInterface order() {
		Pizza pizza = new Pizza();
		pizza.customize();
		pizza.prepare();
		pizza.box();
		return new PizzaAdapter(pizza);
	}
}
