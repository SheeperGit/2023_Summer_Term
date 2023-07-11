
public class Duration {
	int minutes;
	int seconds;
	
	public Duration(int minutes, int seconds) {
		this.minutes = minutes;
		this.seconds = seconds;
	}
	
	@Override
	public boolean equals(Object obj) {
		if (obj == null)
			return false;
		if (!(obj instanceof Duration))
			return false;
		Duration other = (Duration) obj;
		return minutes == other.minutes && seconds == other.seconds;
	}
}
