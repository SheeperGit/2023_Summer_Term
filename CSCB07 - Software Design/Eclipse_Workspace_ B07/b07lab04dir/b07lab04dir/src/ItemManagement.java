import java.util.HashSet;

public abstract class ItemManagement<T extends Item> {
    protected HashSet<T> items;

    public ItemManagement() {
        items = new HashSet<>();
    }

    public void addItem(T item) {
        items.add(item);
    }

    public void removeItem(T item) {
        items.remove(item);
    }

    public boolean itemExists(T item) {
        return items.contains(item);
    }
}

