package main;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class StockHistoryImpl implements StockHistory {

    // we assume uniqueness among the list
    private final List<Date> sortedKeys;
    private final Map<Date, DayQuote> values;

    public StockHistoryImpl(Map<Date, DayQuote> values) {
        this.values = values;
        this.sortedKeys = new ArrayList<Date>(values.keySet());
        Collections.sort(sortedKeys);
    }

    @Override
    public Set<Date> getDates() {
        return values.keySet();
    }

    @Override
    public DayQuote getValue(Date date) {
        return values.get(date);
    }

    @Override
    public String toString() {
        return "StockHistoryImpl [values="
                + values + "]";
    }

    @Override
    public Date getNextAfter(Date today) {
        int index = Collections.binarySearch(sortedKeys, today);
        int returnIndex = (index >= 0) ? index + 1 : -1 * index;
        if (returnIndex < this.sortedKeys.size()) {
            return this.sortedKeys.get(returnIndex);
        }
        return null;
    }

    @Override
    public Date getLastUpTo(Date today) {
        int index = Collections.binarySearch(sortedKeys, today);
        
        int returnIndex = (index >= 0) ? index : -1 * index - 1;
        if (returnIndex >= 0) {
            return this.sortedKeys.get(returnIndex);
        }
        return null;
    }

    @Override
    public List<Date> getLastNUpTo(Date today, int n) {
        if (n < 1) {
            throw new IllegalArgumentException();
        }

        int index = Collections.binarySearch(sortedKeys, today);
        int maxIndex = (index >= 0) ? index : -1 * index - 1; // >= 0
        int minIndex = Math.max(0, maxIndex - n + 1);

        // return everything that falls in (maxIndex - n, maxIndex]
        List<Date> list = new ArrayList<Date>();
        for (int i = minIndex; i <= maxIndex; i++) {
            list.add(this.sortedKeys.get(i));
        }
        return list;
    }
}
