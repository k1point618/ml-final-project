package main;

import java.util.Date;
import java.util.Set;

public interface StockHistory {

    public Set<Date> getDates();

    public Date getNext(Date date);

    public DayQuote getValue(Date date);
}
