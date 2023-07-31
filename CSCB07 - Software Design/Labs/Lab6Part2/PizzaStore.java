public class PizzaStore {
	Pizza order() {
		Pizza pizza = new Pizza();
		pizza.customize();
		pizza.prepare();
		pizza.box();
		return pizza;
	}
}
