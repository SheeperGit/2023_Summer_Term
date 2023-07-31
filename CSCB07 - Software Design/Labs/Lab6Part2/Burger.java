import java.util.Scanner;

public class Burger {
	String type;
	
	public void customize() {
		Scanner scan = new Scanner(System.in);
		System.out.println("Enter the burger type: ");
		type = scan.next();
		scan.close();
	}
	
	public void prepare() {
		System.out.println("Preparing " + type + " burger");
	}
	
	public void box() {
		System.out.println("Boxing " + type + " burger");
	}
}
