import java.util.List;

class BubbleSortService implements SortingService {
	@Override
    public List<Double> sort(List<Double> L){
		BubbleSort.sortArray(L.stream().mapToDouble(Double::doubleValue).toArray());
        return L;
    }
}

