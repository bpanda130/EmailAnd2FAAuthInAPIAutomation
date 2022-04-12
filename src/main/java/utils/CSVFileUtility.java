package utils;

import com.opencsv.CSVReader;
import com.opencsv.CSVWriter;
import com.opencsv.exceptions.CsvException;

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CSVFileUtility {
    List<List<String>> userDetails = new ArrayList<>();
    private static final String SAMPLE_CSV_FILE_PATH = "src/main/resources/credentials/UserTokenDetails.csv";
    boolean flag = false;

    public void addUserTokenDetailsToFile(String username, String secretKey) throws IOException {
        CSVWriter writer = null;
        try{
            List<String[]> csvBody = updateUserTokenDetailsToFile(username, secretKey);
            // Write to CSV file which is open
            if(flag){
                writer = new CSVWriter(new FileWriter(SAMPLE_CSV_FILE_PATH, false));
                writer.writeAll(csvBody);
                writer.flush();
                writer.close();
            }
            else{
                String[] details = new String[] {username, secretKey};
                writer = new CSVWriter(new FileWriter(SAMPLE_CSV_FILE_PATH, true));
                writer.writeNext(details);

                writer.close();
            }
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public List<String[]> updateUserTokenDetailsToFile(String username, String secretKey) throws IOException {
        CSVReader csvReader = null;
        try
        {
            // Read existing file
            csvReader = new CSVReader(new FileReader(SAMPLE_CSV_FILE_PATH));
            List<String[]> csvBody = csvReader.readAll();
            // get CSV row column and replace with by using row and column
            for(int i=0; i<csvBody.size(); i++){
                String[] strArray = csvBody.get(i);
                for(int j=0; j<strArray.length; j++){
                    if(strArray[j].equalsIgnoreCase(username)){ //String to be replaced
                        csvBody.get(i)[j+1] = secretKey; //Target replacement
                        flag = true;
                        return csvBody;
                    }
                }
            }
        }catch(Exception e){
            e.printStackTrace();
        }finally {
            csvReader.close();
        }
        return null;
    }

    public String getUserTokenDetailsFromFile(String username) {
        CSVReader csvReader = null;
        try{
            csvReader = new CSVReader(new FileReader(SAMPLE_CSV_FILE_PATH));
            List<String[]> csvBody = csvReader.readAll();
            for(int i=0; i<csvBody.size(); i++){
                String[] strArray = csvBody.get(i);
                for(int j=0; j<strArray.length; j++){
                    if(strArray[j].equalsIgnoreCase(username)){ //Required Username
                        return csvBody.get(i)[j+1];
                    }
                }
            }
        }catch(IOException | CsvException ie) {
            ie.printStackTrace();
        }finally {
            try{
                csvReader.close();
            }catch(IOException e){
                e.printStackTrace();
            }
        }
        return null;
    }
}
