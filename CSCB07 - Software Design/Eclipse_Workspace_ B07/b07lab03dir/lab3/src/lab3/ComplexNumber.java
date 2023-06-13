package lab3;

public class ComplexNumber extends SpecialNumber implements Comparable<ComplexNumber>{
	double real;
	double imaginary;
	
	public ComplexNumber(double real, double imaginary) {
		this.real = real;
		this.imaginary = imaginary;
	}
	
	@Override
	public SpecialNumber add(SpecialNumber sn) throws Lab3Exception {
		if (!(sn instanceof ComplexNumber)) {
			throw new Lab3Exception("Cannot add an incompatible type");
		}
		
		ComplexNumber cn = (ComplexNumber)sn;
		cn.real += this.real;
		cn.imaginary += this.imaginary;
		
		return cn;
	}
	
	@Override
	public SpecialNumber divideByInt(int n) throws Lab3Exception {
		if (n == 0) {
			throw new Lab3Exception("Cannot divide by zero");
		}
		return new ComplexNumber(this.real / n, this.imaginary / n);
	}
	
	@Override
	public int compareTo(ComplexNumber cn2) {
		double thisMag = Math.sqrt(this.real * this.real + this.imaginary * this.imaginary);
		double cn2Mag = Math.sqrt(cn2.real * cn2.real + cn2.imaginary * cn2.imaginary);
		
		return Double.compare(thisMag, cn2Mag);
	}
	
	@Override
	public boolean equals(Object obj) {
		if (obj == null || !(obj instanceof ComplexNumber)) return false;
		
		ComplexNumber cn2 = (ComplexNumber)obj;
		return (Double.compare(this.real, cn2.real) == 0) && (Double.compare(this.imaginary, cn2.imaginary) == 0);
	}
	
	@Override
	public int hashCode() {
//		double res = 3;
//		int n = 41;
//        res = n * res + this.real;
//        res = n * res + this.imaginary;
//        return (int)res;
		
		int res = (int)Math.sqrt(this.real * this.real + this.imaginary * this.imaginary);
		
		return res;
	}
}
