public class BurgerStore {
	FoodItemInterface order() {
		Burger burger = new Burger();
		burger.customize();
		burger.prepare();
		burger.box();
		return new BurgerAdapter(burger);
	}
}
