package lab3;

public class RationalNumber extends SpecialNumber implements Comparable<RationalNumber>{
	int numerator;
	int denominator;
	
	public RationalNumber(int numerator, int denominator) throws Lab3Exception {
		if (denominator == 0) {
			throw new Lab3Exception("Denominator cannot be zero");
		}
		
		this.numerator = numerator;
		this.denominator = denominator;
	}
	
	@Override
	public SpecialNumber add(SpecialNumber sn) throws Lab3Exception{
		if (!(sn instanceof RationalNumber)) {
			throw new Lab3Exception("Cannot add an incompatible type");
		}
		
		RationalNumber rn = (RationalNumber)sn;
		
	    int lcm = getLCM(this.denominator, rn.denominator);
	    
	    // Get new numerator based on LCM //
	    int newNumerator = (lcm / this.denominator) * this.numerator +
	                       (lcm / rn.denominator) * rn.numerator;
	    
	    return new RationalNumber(newNumerator, lcm); 
	}
	
	@Override
	public SpecialNumber divideByInt(int n) throws Lab3Exception{
		if (n == 0) {
			throw new Lab3Exception("Cannot divide by zero");
		}
		return new RationalNumber(this.numerator, n * this.denominator);
	}
	
	@Override
    public int compareTo(RationalNumber rn2) {
		double thisVal = (double) this.numerator / this.denominator;
        double rn2Val = (double) rn2.numerator / rn2.denominator;

        return Double.compare(thisVal, rn2Val);
    }
	
	@Override
	public boolean equals(Object obj) {
		if (obj == null || !(obj instanceof RationalNumber)) return false;
		
		RationalNumber other = (RationalNumber)obj;
		double thisVal = this.numerator / this.denominator;
		double otherVal = other.numerator / other.denominator;
		
		return (Double.compare(thisVal, otherVal) == 0);
	}
	
	@Override
	public int hashCode() {
//		int p = 37;
//		int res = 1;
//		res = p * res + numerator;
//		res = p * res + denominator;
		
		int res = this.numerator / this.denominator;
		
		return res;
	}
	
	/////////////////////////////////////
	///// Helper Functions go here /////
	///////////////////////////////////
	
	public int getLCM(int a, int b) {
	    return (a * b) / getGCD(a, b);
	}

	private int getGCD(int a, int b) {
	    if (b == 0) return a;
	    return getGCD(b, a % b);
	}
}
