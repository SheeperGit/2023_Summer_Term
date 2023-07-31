import java.util.Scanner;

public class Pizza {
	String type;
	String size;
	
	public void customize() {
		Scanner scan = new Scanner(System.in);
		System.out.println("Enter the pizza type: ");
		type = scan.next();
		System.out.println("Enter the pizza size (small/medium/large): ");
		size = scan.next();
		scan.close();
	}
	
	public void prepare() {
		System.out.println("Preparing " + size + " " + type + " pizza");
	}
	
	public void box() {
		System.out.println("Boxing " + size + " " + type + " pizza");
	}
}
