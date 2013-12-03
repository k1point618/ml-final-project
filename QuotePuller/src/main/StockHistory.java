package main;

import java.util.Date;
import java.util.List;
import java.util.Set;

public interface StockHistory {

    public Set<Date> getDates();

    public DayQuote getValue(Date date);

    public Date getNextAfter(Date today);

    public Date getLastUpTo(Date today);

    public List<Date> getLastNUpTo(Date today, int n);
}
