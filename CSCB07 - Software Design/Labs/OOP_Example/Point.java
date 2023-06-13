
public class Point {
	
	double x;
	double y;
	
	public Point(double x, double y) {
		this.x = x;
		this.y = y;
	}
	
	@Override
	public boolean equals(Object obj) {
		if(obj == null)
			return false;
		if(!(obj instanceof Point))
			return false;
		Point other = (Point)obj;
		return x==other.x && y==other.y;
	}
	
	@Override
	public int hashCode() {
		return (int)x + (int)y;
	}
	
	@Override
	public String toString() {
		return "(" + x + ", " + y + ")";
	}

}
