
class Fraction2 implements Comparable<Fraction2>{
	int numerator;
	int denominator;
	
	public Fraction2(int numerator, int denominator) {
		this.numerator = numerator;
		this.denominator = denominator;
	}
	
	@Override
	public int compareTo(Fraction2 other) {
		double d1 = (double)numerator/(double) denominator;
		double d2 = (double)other.numerator/(double)other.denominator;
		if(d1 < d2)
			return -1;
		else if (d1 == d2)
			return 0;
		return 1;
	}
}
