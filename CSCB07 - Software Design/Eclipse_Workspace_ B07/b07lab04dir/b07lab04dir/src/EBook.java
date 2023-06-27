public class EBook extends Book {
	
	public EBook(String isbn, String title) {
		super(isbn, title, 0, 0, 0);
	}

	@Override
	public double getLength() {
		throw new RuntimeException("EBooks have no length!");
	}

	@Override
	public double getHeight() {
		throw new RuntimeException("EBooks have no height!");
	}
	
	@Override
	public double getWidth() {
		throw new RuntimeException("EBooks have no width!");
	}

	@Override
	public String determineBoxSize() {
		throw new RuntimeException("EBooks don't need boxes!");
	}
}
