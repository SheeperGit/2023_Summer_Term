
public class DeliveryService implements DeliveryServiceInterface {
    private String serviceName;

    public DeliveryService(String serviceName) {
        this.serviceName = serviceName;
    }

    @Override
    public void deliver(Item item, Customer customer) {
        System.out.println("Delivering " + item.toString());
        System.out.println("Delivery service: " + serviceName);
        System.out.println("Box size: " + item.determineBoxSize());
        System.out.println("Address: " + customer.getPostalCode());
    }
}

