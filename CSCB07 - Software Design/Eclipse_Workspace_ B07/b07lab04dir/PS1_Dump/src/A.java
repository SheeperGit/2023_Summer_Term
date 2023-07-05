
public class A {
	public int x;
	
	public A() {
		x = 1;
	}
	
	void foo() {
		bar();
	}
	
	void bar() {
		x++;
	}
}
