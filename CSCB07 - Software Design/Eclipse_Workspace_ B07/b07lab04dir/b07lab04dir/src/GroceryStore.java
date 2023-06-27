
public class GroceryStore extends ItemManagement<GroceryItem> {
    private DeliveryService deliveryService;

    public GroceryStore(DeliveryService deliveryService) {
        this.deliveryService = deliveryService;
    }

    public void deliver(GroceryItem item, Customer customer) {
        if (itemExists(item)) {
            deliveryService.deliver(item, customer);
            removeItem(item);
        }
    }
}

