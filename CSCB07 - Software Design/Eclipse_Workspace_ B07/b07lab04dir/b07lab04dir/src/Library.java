public class Library extends ItemManagement<Book> {
    private DeliveryService deliveryService;

    public Library(DeliveryService deliveryService) {
        this.deliveryService = deliveryService;
    }

    public void deliver(Book book, Customer customer) {
        if (itemExists(book)) {
            deliveryService.deliver(book, customer);
            removeItem(book);
        }
    }
}
