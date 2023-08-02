public class PizzaStore {
	Store<Pizza> pStore = new Store<>();
	
	public Pizza order() {
		return pStore.order(new Pizza());
	}
}
