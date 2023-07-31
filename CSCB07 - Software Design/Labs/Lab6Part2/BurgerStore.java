public class BurgerStore {
	Burger order() {
		Burger burger = new Burger();
		burger.customize();
		burger.prepare();
		burger.box();
		return burger;
	}
}
