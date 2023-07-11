
public class UnitFraction2 extends Fraction2 {
	public UnitFraction2(int denominator) {
		super(1, denominator);
	}
	
	@Override
	public int compareTo(UnitFraction2 other) {
		double d1 = 1/(double)denominator;
		double d2 = 1/(double)other.denominator;
		if(d1 < d2)
			return -1;
		else if (d1 == d2)
			return 0;
		return 1;
	}
}
