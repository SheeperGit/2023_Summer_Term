
public class Store<T extends FoodItem> {
	public T order(T fooditem) {
		fooditem.customize();
		fooditem.prepare();
		fooditem.box();
		return fooditem;
	}
}
