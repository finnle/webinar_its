package Ant;

import java.io.*;
import org.apache.tools.ant.*;


/**
 *
 * @author leroy
 */
public class AntCommandLine {
    //empty constructor
    public AntCommandLine(){
    }
    
    //Execute ant script
    public void execute(String datacat,String type,String locationParserBuildFile){
      Project project = new Project();
      project.init();
      DefaultLogger logger = new DefaultLogger();
      logger.setMessageOutputLevel(Project.MSG_INFO);
      logger.setErrorPrintStream(System.err);
      logger.setOutputPrintStream(System.out);
      project.addBuildListener(logger);

      File buildFile = new File(locationParserBuildFile+"build.xml");

      ProjectHelper.configureProject(project, buildFile);
      project.setProperty("ant.file", buildFile.getAbsolutePath());
      project.setProperty("inputfile", "sample/translate/inputfile.xml");
      project.setProperty("datacategories", datacat);

     try {
         project.executeTarget("nodelist-tab-delimited");
      } catch(Exception e) {System.err.println(e.getMessage()+"dasdas");}
    
    }
   
}
