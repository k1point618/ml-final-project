package main;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class CSVHistoryGenerator {

    private static DateFormat format = new SimpleDateFormat("d-MMM-yy");
    public static void main(String[] args) throws IOException, ParseException {
        StockHistory history = getHistory("aapl");

        System.out.println(history);
    }

    public static StockHistory getHistory(String ticker) throws IOException,
            ParseException {

        String path = "../data_ticker_csvs/" + ticker + ".csv";
        FileReader reader = new FileReader(new File(path));
        BufferedReader br = new BufferedReader(reader);

        br.readLine(); // ignore header
        // header should be: Date Open High Low Close Volume

        Map<Date, DayQuote> values = new HashMap<Date, DayQuote>();

        Date nextTradingDay = null;
        while (br.ready()) {
            String line = br.readLine();
            String[] columns = line.split(",");

            // TODO timezone?
            Date today;
            DayQuote quote;
            try {
                today = format.parse(columns[0]);
                double open = Double.parseDouble(columns[1]);
                double high = Double.parseDouble(columns[2]);
                double low = Double.parseDouble(columns[3]);
                double close = Double.parseDouble(columns[4]);
                double volume = Double.parseDouble(columns[5]);

                quote = new DayQuote(high, low, open, close, volume);
            } catch (NumberFormatException e) {
                throw new RuntimeException(line, e);
            }

            values.put(today, quote);
        }
        br.close();
        return new StockHistoryImpl(values);
    }

}
