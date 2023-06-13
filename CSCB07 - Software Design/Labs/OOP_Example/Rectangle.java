
public class Rectangle extends Shape {
	double length;
	double width;
	
	public Rectangle(double length, double width, String color) throws B07Exception {
		super(color);
		if(length<=0 || width<=0) {
			throw new B07Exception("Length and width should be greater than zero"); 
		}
		this.length = length;
		this.width = width;
	}
	
	public double computeArea() {
		return length * width;
	}

}
