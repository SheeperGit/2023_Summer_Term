public class Book extends Item{
	private String isbn;
	
	public Book(String isbn, String title, double length, double width, double height) {
        super(title, length, width, height);
        this.isbn = isbn;
    }

	@Override
    public String determineBoxSize() {
        double sizeMax = Math.max(length, Math.max(width, height));
        if (sizeMax < 5)
            return "small";
        else if (sizeMax < 15)
            return "medium";
        return "large";
    }

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		
		result = prime * result + ((isbn == null) ? 0 : isbn.hashCode());
		
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		
		if (obj == null || !(obj instanceof Book))
			return false;
		
		Book other = (Book) obj;
		
		if ((isbn == null && other.isbn != null) ||
			!(isbn.equals(other.isbn))) {
			return false;
		}
		
		return true;
	}
}
