package main;

import java.util.Date;
import java.util.Map;
import java.util.Set;

public class StockHistoryImpl implements StockHistory {

    private final Map<Date, Date> successors;
    private final Map<Date, DayQuote> values;

    public StockHistoryImpl(Map<Date, Date> successors,
            Map<Date, DayQuote> values) {
        this.successors = successors;
        this.values = values;
    }

    @Override
    public Set<Date> getDates() {
        return values.keySet();
    }

    @Override
    public Date getNext(Date date) {
        return successors.get(date);
    }

    @Override
    public DayQuote getValue(Date date) {
        return values.get(date);
    }

    @Override
    public String toString() {
        return "StockHistoryImpl [successors=" + successors + ", values="
                + values + "]";
    }
}
