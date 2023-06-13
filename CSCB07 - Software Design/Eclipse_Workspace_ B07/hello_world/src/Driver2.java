import java.util.ArrayList;


public class Driver2 {
	public static void main (String[] args) {
		int center = -1;
		double radius = -1.0;
		
		try {
			Shape s = new Circle(center, radius);
			System.out.println("Construction Successful!");
			System.out.println(s.toString());
		}
		catch(B07Exception ex) {
			System.out.println(ex.msg);
			System.exit(0);
		}
		
		ArrayList<Circle> cList = new ArrayList<Circle>();
	}
}
