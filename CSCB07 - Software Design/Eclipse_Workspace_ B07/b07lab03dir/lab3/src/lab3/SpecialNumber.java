package lab3;
import java.util.List;

public abstract class SpecialNumber {
	// Adds the calling obj w/ the arg and returns the result. //
	abstract SpecialNumber add(SpecialNumber sn) throws Lab3Exception;
	
	// Divides the calling obj by the arg and returns the result. //
	abstract SpecialNumber divideByInt(int n) throws Lab3Exception;
	
	// Returns the avg of Lsn using add() and divideByInt(). //
	// If Lsn is null or empty, throw a Lab3Exception w/ the msg: //
	// "List cannot be empty" //
	public static SpecialNumber computeAverage(List<SpecialNumber> Lsn) throws Lab3Exception {
		if (Lsn == null) { throw new Lab3Exception("List cannot be empty"); }
		
		int Listlen = Lsn.size();
		if (Listlen == 0) { throw new Lab3Exception("List cannot be empty"); }
		
		if (Lsn instanceof ComplexNumber) {
			ComplexNumber cnAccum = new ComplexNumber(0, 0);
			for (SpecialNumber sn:Lsn) 
				cnAccum.add(sn);
			cnAccum.divideByInt(Listlen);
			
			return cnAccum;
		}
		
		RationalNumber rnAccum = new RationalNumber(0, Listlen);
		if (Lsn instanceof RationalNumber) {
			for (SpecialNumber sn:Lsn) 
				rnAccum.add(sn);
				rnAccum.denominator -= 1;
			rnAccum.divideByInt(Listlen);
		}
		return rnAccum;
	}
}
