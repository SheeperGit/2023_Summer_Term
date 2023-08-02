import java.util.ArrayList;

public class Driver {
	public static void main(String[] args) {
		ArrayList<Double> arr = new ArrayList<>();
		arr.add(6.4);
		arr.add(9.9);
		arr.add(3.12);
		arr.add(5.5);
		arr.add(2.1);
		SortingService ss = new MergeSortService();
		DataAnalysis da = new DataAnalysis(arr, ss);
		
        for (Double value : da.numbers) {
            System.out.println(value);
        }
		
		System.out.println("Median: " + da.median());
	}
}
