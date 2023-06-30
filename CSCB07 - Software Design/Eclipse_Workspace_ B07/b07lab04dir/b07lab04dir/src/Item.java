public abstract class Item {
    // All class fields are protected, //
    // because we want them to be accessible only to classes Book, GroceryItem. //

    protected String name;
    protected double length;
    protected double width;
    protected double height;

    public Item(String name, double length, double width, double height) {
        this.name = name;
        this.length = length;
        this.width = width;
        this.height = height;
    }

    public abstract String determineBoxSize();

    @Override
    public String toString() {
        return name;
    }

    public double getLength() {
        return length;
    }

    public double getWidth() {
        return width;
    }

    public double getHeight() {
        return height;
    }
   
}

