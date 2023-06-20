
public class Circle extends Shape implements Comparable<Rectangle> {
	int x;
	int y;
	int center;
	double radius;
	
	public Circle(int center, double radius) throws B07Exception {
		if (center < 0 || radius < 0) {
			throw new B07Exception("Negative vals not allowed!");
		}
		
		this.center = center;
		this.radius = radius;
	}
	
	@Override
	void foo() {
		System.out.println("foo in Circle");
	}
	
	// Not overriding, but overloading. //
	void foo(int n) {
		
	}
	
	// Signature: funcName, paramType1, paramType2, ... //
	
	void bar() {
		foo();
	}
	
	@Override
	public boolean equals(Object obj) {
		if (obj == null) return false;
		
		if (!(obj instanceof Circle)) return false;
		
		// Since obj is of type Object. //
		Point other = (Point)obj; 
		return x == other.x && y == other.y;
	}
	
	@Override
	public int hashCode() {
		// return 0; // BAD HASHCODE!!! //
		// return (int)x; // Better... but still bad! //
		// return (int)x + (int)y; // Meh... //
		
		// There are more possible Circles than there are unique hash codes! //
		// Try to make it as unique as possible. //
		// Most of the time, it is impossible to make it completely unique. //
		
		return (int)x * (int)y * (int)x + (int)y;
	}
	
	@Override
	public String toString() {
		return "(" + x + ", " + y + ")";
	}
	
	@Override
	public int compareTo(Rectangle r) {
		
		
	}
}
