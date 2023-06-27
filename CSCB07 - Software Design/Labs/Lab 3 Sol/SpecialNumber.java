package lab3;
import java.util.List;

/// I accidently wrote doc comments for every method in SpecialNumber ///
///            Oops... Please don't let this backfire!               ///

public abstract class SpecialNumber {
	/** 
	 * Adds the calling obj w/ the arg and returns the result. 
	 * @param sn, the SpecialNumber to be added to the calling obj.
	 * @throws Lab3Exception, If sn is not an instanceof the corresponding class type
	 * @return a SpecialNumber that is the result of adding the calling obj w/ sn.
	 */
	abstract SpecialNumber add(SpecialNumber sn) throws Lab3Exception;
	
	/**
	 *  Divides the calling obj by the arg and returns the result.
	 *  @param n, the integer which will divide the SpecialNumber
	 *  @throws Lab3Exception	If n == 0
	 *  @return the division of the calling obj by the integer n
	 */
	abstract SpecialNumber divideByInt(int n) throws Lab3Exception;
	
	/** 
	 * Returns the avg of Lsn using add() and divideByInt().
	 * @param Lsn a List containing objs of type SpecialNumber
	 * @throws Lab3Exception If Lsn == null or Lsn is empty
	 * @return Returns the avg of Lsn, using the methods add() and divideByInt()
	 */
	public static SpecialNumber computeAverage(List<SpecialNumber> Lsn) throws Lab3Exception {
		if (Lsn == null) { throw new Lab3Exception("List cannot be empty"); }
		
		int Listlen = Lsn.size();
		if (Listlen == 0) { throw new Lab3Exception("List cannot be empty"); }
		
		if (Lsn.get(0) instanceof ComplexNumber) {
			ComplexNumber cnAccum = new ComplexNumber(0, 0);
			
			for (SpecialNumber sn:Lsn) { cnAccum = (ComplexNumber)cnAccum.add(sn); }
			cnAccum = (ComplexNumber)cnAccum.divideByInt(Listlen);
			
			return cnAccum;
		}
		
		RationalNumber rnAccum = new RationalNumber(0, 1);
		if (Lsn.get(0) instanceof RationalNumber) {
			for (SpecialNumber sn:Lsn) { rnAccum = (RationalNumber)rnAccum.add(sn); }
			rnAccum = (RationalNumber)rnAccum.divideByInt(Listlen);
		}
		return rnAccum;
	}
}
