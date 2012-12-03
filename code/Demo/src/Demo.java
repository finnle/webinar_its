import Ant.AntCommandLine;
import java.io.*;
import java.util.*;
import testsuitefunctions.TestSuiteFunctions;

/**
 * @author leroy
 */
public class Demo {

    public static void main(String args[]) {
        List<String> fileList = new ArrayList<String>();
        String dc = "languageinformation";
        String type = "xml";
        
        //CHANGE THESE TO YOU PATH LOCATIONS
        String parserPath="/home/leroy/Desktop/XMLDemo/temp/";
        String locationParserBuildFile="/home/leroy/Desktop/XMLDemo/";
        
        AntCommandLine nc = new AntCommandLine();
        nc.execute(dc, type, locationParserBuildFile);

        //put data in correct order
        BufferedReader br = null;
        ArrayList<String> lines = new ArrayList<String>();
        ArrayList<String> alphabeticOrderElements = new ArrayList<String>();

        try {
            //tidy content 
            TestSuiteFunctions.tidyXSLTOutput(parserPath);

            br = new BufferedReader(new FileReader(parserPath+"output.txt"));
            lines=TestSuiteFunctions.organiseRulesOuput(br);
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (br != null) {
                    br.close();
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }

        //put elements in alpabetic order
        alphabeticOrderElements = TestSuiteFunctions.alphabeticOrder(lines);

        //remove any duplicate lines
        TestSuiteFunctions.removeDuplicates(alphabeticOrderElements);

        //write the gold standard output to a file
        TestSuiteFunctions.writeOutput(alphabeticOrderElements, "XMLDemo", fileList, 1, dc,parserPath);
    }
}