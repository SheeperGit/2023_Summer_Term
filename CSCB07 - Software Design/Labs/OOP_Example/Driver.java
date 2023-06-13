import java.util.ArrayList;

public class Driver {
	
	public static void main(String [] args) {
		try{
			ArrayList<Shape> shapes = new ArrayList<Shape>();	
			shapes.add(new Rectangle(2, 3, "blue"));
			shapes.add(new Circle(new Point(1,2), 3, "red"));
			for(Shape shape:shapes)
				System.out.println(shape.computeArea());
			System.out.println("Execution successful");
		}
		catch(B07Exception ex) {
			System.out.println(ex.message);
			System.exit(0);
		}
	}

}
