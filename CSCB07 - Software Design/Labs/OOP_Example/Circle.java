
public class Circle extends Shape {
	Point center;
	double radius;
	
	public Circle(Point center, double radius, String color) throws B07Exception {
		super(color);
		if(radius <= 0)
			throw new B07Exception("Radius should be greater than zero");
		this.center = center;
		this.radius = radius;
	}
	
	public double computeArea() {
		return Math.PI * radius * radius;
	}

}
