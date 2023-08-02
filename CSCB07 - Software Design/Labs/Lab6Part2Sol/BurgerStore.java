public class BurgerStore {
	Store<Burger> bStore = new Store<>();
	
	public Burger order() {
		return bStore.order(new Burger());
	}
}
