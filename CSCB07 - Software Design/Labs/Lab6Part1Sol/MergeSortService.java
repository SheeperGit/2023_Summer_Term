import java.util.List;

class MergeSortService implements SortingService {
	@Override
    public List<Double> sort(List<Double> L){
		MergeSort.sort(L.stream().mapToDouble(Double::doubleValue).toArray(), 0, L.size() - 1);
        return L;
    }
}
