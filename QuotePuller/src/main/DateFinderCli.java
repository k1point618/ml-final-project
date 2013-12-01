package main;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author ernest
 *
 *         Finds the ticker prices used to construct sample data labels.
 *
 *         Output format: - row i corresponds with article i - each row contains
 *         [today close],[tomorrow open],[tomorrow close],[today timestamp]
 */
public class DateFinderCli {

    private final File inputDirectory, outputFile;
    private Map<String, StockHistory> knownHistories = new HashMap<String, StockHistory>();

    private static final DateFormat format = new SimpleDateFormat(
            "E, d MMM yyyy HH:mma z");

    public static void main(String[] args) throws IOException, ParseException {
        String path1 = args[0];
        String path2 = args[1];
        File inputDirectory = new File(path1);
        File outputFile = new File(path2);
        DateFinderCli dfc = new DateFinderCli(inputDirectory, outputFile);
        dfc.run();
    }

    public DateFinderCli(File inputDirectory, File outputFile) {

        if (outputFile.isDirectory() || !inputDirectory.isDirectory()) {
            throw new IllegalArgumentException();
        }
        this.inputDirectory = inputDirectory;
        this.outputFile = outputFile;
    }

    public void run() throws IOException, ParseException {

        Map<Integer, String> finalAnswer = new HashMap<Integer, String>();
        System.out.println("Reading from " + inputDirectory.getCanonicalPath());
        File[] files = inputDirectory.listFiles();
        for (File file : files) {

            String name = file.getName();
            String[] tokens = name.split("_");

            if (!name.endsWith(".data")) {
                System.out.println("ignoring " + name);
                continue; // ignore
            }

            if (tokens.length != 2) {
                throw new IllegalArgumentException("bad file name: " + name);
            }

            String ticker = tokens[0];
            ticker = ticker.toLowerCase();

            Integer id = Integer.parseInt(tokens[1].substring(0,
                    tokens[1].length() - 5));

            if (!knownHistories.containsKey(ticker)) {

                knownHistories.put(ticker,
                        CSVHistoryGenerator.getHistory(ticker));
            }
            StockHistory history = this.knownHistories.get(ticker);

            BufferedReader br = new BufferedReader(new FileReader(file));

            // ignore the first 4 lines
            br.readLine(); // ticker name
            br.readLine(); // source
            br.readLine(); // url
            br.readLine(); // title

            Date datetime = format.parse(br.readLine());

            Date today = round(datetime);
            Date mostRecentTradingDay = history.getLastUpTo(today);
            Date nextTradingDay = history.getNextAfter(today);

            DayQuote quote1 = history.getValue(mostRecentTradingDay);
            DayQuote quote2 = history.getValue(nextTradingDay);

            if (quote2 == null) {
                // tomorrow hasn't happened yet!
                throw new IllegalArgumentException(
                        "Can't predict tomorrow's prices :(");
            }

            String line = quote1.getClose() + "," + quote2.getOpen() + ","
                    + quote2.getClose() + "," + today.getTime();

            if (finalAnswer.containsKey(id)) {
                throw new RuntimeException("Ids must be unique! " + id
                        + " already used!");
            }

            finalAnswer.put(id, line);
        }

        ArrayList<String> lines = new ArrayList<String>();
        for (int i = 0; i < finalAnswer.size(); i++) {

            int id = i + 1;
            String line = finalAnswer.get(id);

            if (line == null) {
                throw new IllegalArgumentException(
                        "Ids must go up sequentially starting with 1. Couldnt find "
                                + id);
            }
            lines.add(line);
        }
        System.out.println("Outputing data for " + lines.size() + " articles");
        System.out.println("Outputing to " + this.outputFile.getCanonicalPath());
        write(lines, this.outputFile);
    }

    private Date round(Date datetime) {
        Calendar cal = Calendar.getInstance(); // locale-specific
        cal.setTime(datetime);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        long time = cal.getTimeInMillis();
        return new Date(time);
    }

    private static void write(ArrayList<String> lines, File outputFile)
            throws IOException {
        
        BufferedWriter bw = new BufferedWriter(new FileWriter(outputFile));
        for (String line : lines) {
            bw.write(line);
            bw.newLine();
        }
        bw.flush();
        bw.close();
    }

}
