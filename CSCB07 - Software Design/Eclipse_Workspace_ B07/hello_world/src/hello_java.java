import java.io.BufferedReader;
import java.io.File;
import java.util.Scanner;
import java.io.FileReader;
import java.io.PrintStream;

public class hello_java {
	
	public static void main(String [] args) throws Exception {
		PrintStream ps = new PrintStream("/home/sean_the_sheep/Desktop/University/2023_Summer_Term/CSCB07 - Software Design/Eclipse_Workspace_ B07/hello_world/src/createdbyJava.txt");
		ps.println("I'm the first line!");
		ps.println("And I'm the second!");
		ps.println("Third and so on...");
		
		
//		BufferedReader b = new BufferedReader(new FileReader ("/home/sean_the_sheep/Desktop/University/2023_Summer_Term/CSCB07 - Software Design/Eclipse_Workspace_ B07/hello_world/src/myfile.txt"));
//		String line = b.readLine();
//		while (line != null) {
//			String[] parts = line.split("\\+");
//			for (String part:parts) {
//				System.out.print(part + " ");
//			}
//			line = b.readLine();
//		}
//		
		
//		File f = new File("/home/sean_the_sheep/Desktop/University/2023_Summer_Term/CSCB07 - Software Design/Eclipse_Workspace_ B07/hello_world/src");
//		System.out.println(f.exists());
//		System.out.println(f.isDirectory());
//		
//		if (f.isDirectory()) {
//			File[] files = f.listFiles();
//			for (File x:files) {
//				System.out.println(x.getName() + ", " + x.isDirectory());
//			}
//		}
//		Scanner scan = new Scanner(System.in);
//		
//		System.out.println("Enter an int: ");
//		int input = scan.nextInt();
//		int square = input * input;
//		
//		System.out.println("Sqaure = " + square);
		
//		int x = 3;
//		double pi = 3.1415;
//		char c = '@';
//		boolean b = true;
//		
//		System.out.println("Hello, Java! " + x + ", " + pi);
//		System.out.println(c + ", " + b);
//		
//		// Uses data from Point.java //
//		Point p1 = new Point(1, 2);
//		Point p2 = new Point(3, 4);
//		
//		p1.display();
//		p1.translate(1, 0);
//		p1.display();
//		
//		double d = p1.distance(p2);
//		System.out.println(d);
//		
//		int [][] M = new int[2][3]; // 2 rows, 3 cols.
//		M[0][1] = 7;
//		//...
//		int[][] M2 = new int[][]{ {1, 2, 3},
//								  {4, 5, 6}
//					   			  };
	}
}