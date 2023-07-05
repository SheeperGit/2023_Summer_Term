
public class Fraction {
	int numerator;
	int denominator;
	
	private Fraction() {
	}
	
	public Fraction(int numerator, int denominator) {
		this.numerator = numerator;
		this.denominator = denominator;
	}
	
	@Override
	public String toString() {
		return numerator + "/" + denominator;
	}
}