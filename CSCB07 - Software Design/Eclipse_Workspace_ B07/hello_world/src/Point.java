public class Point {
	double x;
	double y;
	
	// Constructor - Should have same name as the class. //
	public Point(double a, double b) {
		x = a;
		y = b;
	}
	
	// Has access to the point already. //
	// (i.e., double x, double y)       // 
	public void translate(double dx, double dy) {
		x += dx;
		y += dy;
	}
	
	// Same for this.
	public void display() {
		System.out.println("(" + x + ", " + y + ")");
	}
	
	public double distance(Point q) {
		return Math.sqrt(Math.pow(x - q.x, 2) + Math.pow(y - q.y, 2));
	}
}
