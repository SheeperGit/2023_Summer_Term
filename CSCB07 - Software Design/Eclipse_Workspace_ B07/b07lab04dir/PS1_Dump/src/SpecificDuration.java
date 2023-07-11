
public class SpecificDuration extends Duration {
	int milliseconds;
	
	public SpecificDuration(int minutes, int seconds, int milliseconds) {
		super(minutes, seconds);
		this.milliseconds = milliseconds;
	}
	
	@Override
	public boolean equals(Object obj) {
		if (obj == null)
			return false;
		if (!(obj instanceof Duration))
			return false;
		if (!(obj instanceof SpecificDuration))
			return super.equals(obj);
		SpecificDuration other = (SpecificDuration) obj;
		return super.equals(other) && milliseconds == other.milliseconds;
	}
}
