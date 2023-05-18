public class hello_java {
	
	public static void main(String [] args) {
		int x = 3;
		double pi = 3.1415;
		char c = '@';
		boolean b = true;
		
		System.out.println("Hello, Java! " + x + ", " + pi);
		System.out.println(c + ", " + b);
		
		// Uses data from Point.java //
		Point p1 = new Point(1, 2);
		Point p2 = new Point(3, 4);
		
		p1.display();
		p1.translate(1, 0);
		p1.display();
		
		double d = p1.distance(p2);
		System.out.println(d);
	}
}