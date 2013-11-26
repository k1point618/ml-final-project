package main;

public class DayQuote {

    private final double high, low, open, close, volume;

    public DayQuote(double high, double low, double open, double close,
            double volume) {
        this.high = high;
        this.low = low;
        this.open = open;
        this.close = close;
        this.volume = volume;
    }

    public double getHigh() {
        return high;
    }

    public double getLow() {
        return low;
    }

    public double getOpen() {
        return open;
    }

    public double getClose() {
        return close;
    }

    public double getVolume() {
        return volume;
    }

    @Override
    public String toString() {
        return "DayQuote [high=" + high + ", low=" + low + ", open=" + open
                + ", close=" + close + ", volume=" + volume + "]";
    }
}
