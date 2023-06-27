public abstract class Item {
    // All class fields are protected, //
    // because we want them to be accessible only to classes Book, GroceryItem. //

    protected String id;
    protected String name;
    protected double length;
    protected double width;
    protected double height;

    public Item(String id, String name, double length, double width, double height) {
        this.id = id;
        this.name = name;
        this.length = length;
        this.width = width;
        this.height = height;
    }

    public abstract String determineBoxSize();

    public String getName() {
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

