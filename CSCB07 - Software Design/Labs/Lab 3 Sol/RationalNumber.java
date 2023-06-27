package lab3;

/** 
 * A rational number is denoted by a numerator, and a denominator. 
 * The denominator should not be equal to zero.
 */
public class RationalNumber extends SpecialNumber implements Comparable<RationalNumber>{
	/** 
	 * The numerator field of RationalNumber represents the numerator found in rational numbers.
	 */
	int numerator;
	/** 
	 * The denominator field of RationalNumber represents the denominator found in rational numbers.
	 */
	int denominator;
	
	/** 
	 * Constructor function for RationalNumber. 
	 * Initializes RationalNumber using numerator, denominator. 
	 * @param numerator represents the numerator of the RationalNumber
	 * @param denominator represents the denominator of the RationalNumber
	 * @throws Lab3Exception If sn is not an instanceof the corresponding class type
	 * @return a SpecialNumber that is the result of adding the calling obj w/ sn.
	 */
	public RationalNumber(int numerator, int denominator) throws Lab3Exception {
		if (denominator == 0) {	throw new Lab3Exception("Denominator cannot be zero"); }
		
		this.numerator = numerator;
		this.denominator = denominator;
	}
	
	/** 
	 * Adds two RationalNumber objects using the LCM method. 
	 * @param sn a SpecialNumber, for addition to work: must be a RationalNumber
	 * @throws Lab3Exception If sn is not an instanceof RationalNumber
	 * @return a RationalNumber resulting from the addition of the calling obj
	 * 		   and sn
	 */
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
	
	/** 
	 * Divides a RationalNumber by an integer, n. 
	 * @param n the integer used to divide the calling obj
	 * @throws Lab3Exception If n is equal to 0 (Division by zero not allowed!)
	 * @return a RationalNumber resulting from the division of the integer n and
	 * 		   the calling obj
	 */
	@Override
	public SpecialNumber divideByInt(int n) throws Lab3Exception{
		if (n == 0) {
			throw new Lab3Exception("Cannot divide by zero");
		}
		return new RationalNumber(this.numerator, n * this.denominator);
	}
	
	/** 
	 * Compares two RationalNumber objects. 
	 * @param rn2 the second RationalNumber to be compareed to w/ the calling obj
	 * @return 0, if the two RationalNumber objects are equal, -1 if the calling obj
	 * 		   is less than rn2, and 1 o/w
	 */
	@Override
    public int compareTo(RationalNumber rn2) {
		double thisVal = (double) this.numerator / this.denominator;
        double rn2Val = (double) rn2.numerator / rn2.denominator;

        return Double.compare(thisVal, rn2Val);
    }
	
	/** 
	 * Asserts the equality of two RationalNumber objects. 
	 * @param obj possibly a RationalNumber used to compare equality w/ calling obj
	 * @throws Lab3Exception If obj is null or obj is not an instanceof RationalNumber
	 * @return true if the calling obj is equal to obj (argument), and false o/w 
	 */
	@Override
	public boolean equals(Object obj) {
		if (obj == null || !(obj instanceof RationalNumber)) return false;
		
		RationalNumber other = (RationalNumber)obj;
		double thisVal = this.numerator / this.denominator;
		double otherVal = other.numerator / other.denominator;
		
		return (Double.compare(thisVal, otherVal) == 0);
	}
	
	/** 
	 * Generates a hash code of a RationalNumber. 
	 * @return an integer hash code based on the division of the calling obj's
	 * 		   numerator and denominator
	 */
	@Override
	public int hashCode() {
		return (this.numerator / this.denominator);
	}
	
	/////////////////////////////////////
	///// Helper Functions go here /////
	///////////////////////////////////
	
	/** 
	 * Gets the Least Common Multiple of a RationalNumber. 
	 * @param a the numerator of the RationalNumber
	 * @param b the denominator of the RationalNumber
	 * @return the Least Common Multiple (lcm) of the RationalNumber, denoted by (a / b) 
	 */
	public int getLCM(int a, int b) {
	    return (a * b) / getGCD(a, b);
	}

	/** 
	 * Gets the Greatest Common Divisor of a RationalNumber. 
	 * @param a the numerator of the RationalNumber
	 * @param b the denominator of the RationalNumber
	 * @return the Greatest Common Divisor (gcd) of the RationalNumber, denoted by (a / b) 
	 */
	private int getGCD(int a, int b) {
	    if (b == 0) return a;
	    return getGCD(b, a % b);
	}
}
