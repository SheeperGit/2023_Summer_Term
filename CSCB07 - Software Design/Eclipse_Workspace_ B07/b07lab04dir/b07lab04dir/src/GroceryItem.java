public class GroceryItem extends Item {
	public GroceryItem(String id, String name, double length, double width, double height) {
        super(id, name, length, width, height);
    }

    @Override
    public String determineBoxSize() {
        double max = Math.max(length, Math.max(width, height));
        if (max < 10)
            return "small";
        else if (max < 20)
            return "medium";
        else if (max < 30)
            return "large";
        else
            return "x-large";
    }

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (!(obj instanceof GroceryItem))
			return false;
		GroceryItem other = (GroceryItem) obj;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return name;
	}
}
