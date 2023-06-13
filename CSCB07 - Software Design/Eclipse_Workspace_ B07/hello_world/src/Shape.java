// abstract == No constructor //


public abstract class Shape {
	String color;
	
	// abstract "constructor" //
//	public Shape() {
//		
//	}
	
	void foo() {
		System.out.println("foo in Shape");
	}
	
	// You must know define bar() in any subclass due to the line below. Error, o/w. //
	abstract void bar();
}
