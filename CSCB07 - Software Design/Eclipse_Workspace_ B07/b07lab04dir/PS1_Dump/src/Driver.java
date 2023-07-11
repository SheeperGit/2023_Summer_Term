

/* Suppose x = new SpecificDuration(1, 1, 1), y = new Duration(1, 1), and z = new SpecificDuration(1, 1, 2).
 * Therefore, Transitivity doesn't hold.
 * */
public class Driver {
	public static void main(String[] args) {
		Duration x = new SpecificDuration(1, 1, 1);
		Duration y = new Duration(1, 1);
		Duration z = new SpecificDuration(1, 1, 2);
		
		System.out.println(x.equals(y));
		System.out.println(y.equals(z));
		System.out.println(x.equals(z));
		
		Fraction2 f = new Fraction2(2, 4);
		Fraction2 uf = new UnitFraction2(4);
	}
}
