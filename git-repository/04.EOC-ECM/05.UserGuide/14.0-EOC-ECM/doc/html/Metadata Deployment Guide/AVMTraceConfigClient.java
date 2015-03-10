package com.conceptwave.config;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.management.MBeanServerConnection;
import javax.management.ObjectName;
import javax.management.remote.JMXConnector;
import javax.management.remote.JMXConnectorFactory;
import javax.management.remote.JMXServiceURL;

/**
 * SAMPLE IMPLEMENTATION
 * 
 * JMX client for AVM Trace Configuration.  
 * 
 * 
 * <p>
 * This class is a utility to connect with the JMX agent running in the AVM 
 *  and invoke operations to view/modify the trace configuration in AVM
 *  
 * <p> 
 * Supported Operations:
 * <pre>
 *    Operation Name = CreateTraceJob, Description = Create a new trace job.
 *    parameters = {String interface, Date startDate, Date endDate, String coverage}
 *    return = String traceID
 *    
 *    Operation Name = DeleteTraceJob, Description = Delete a trace job.
 *    parameters = {String traceID}
 *    return = boolean success
 *    
 *    Operation Name = ListTraceJobs, Description = List all existing trace jobs.
 *    return = String[] list of trace jobs
 *    
 *    Operation Name = AddTraceInterface, Description = Activate an interface.
 *    parameters = {String traeInterface}
 *    return = void
 *    
 *    Operation Name = RemoveTraceInterface, Description = Remove an active interface.
 *    parameters = {String traceInterface}
 *    return = boolean success
 *    
 *    Operation Name = ListTraceInterface, Description = List all activated interfaces.
 *    return = String[] list of active interfaces 
 *    
 *    Operation Name = AddTraceObject, Description = Add a trace object to a trace job.
 *    parameters = {String traceID, String traceType, String traceValue, String matchType}
 *    matchType = [ STARTS_WITH | ENDS_WITH | EQUALS | CONTAINS ] 
 *    return = boolean success
 *    
 *    Operation Name = RemoveTraceObject, Description = Remove a trace object from a trace job.
 *    parameters = {String traceID, String traceType}
 *    return = boolean success
 *    
 *    Operation Name = ListTraceObjects, Description = List all trace objects., impact = MBeanOperationInfo.INFO)
 *    parameters = {String traceID}
 *    return = String[] list of trace objects
 *    
 *    Date format for arguments - dd/MM/yyyy-HH:mm:ss
 * </pre>
 * 
 * @author Tejinder Dhaliwal
 *
 */
public class AVMTraceConfigClient {

  private static final String STR_CLASS = String.class.getName();
  private static final String DT_CLASS = Date.class.getName();

  private static final SimpleDateFormat DT_FORMAT = new SimpleDateFormat("dd/MM/yyyy-HH:mm:ss");

  /**
   * 
   * @param args
   * @throws Exception
   */
  public static void main(String[] args) {

    echo("JMX client for AVM Trace Configuration");

    if (args.length == 0 || args[0].contains("help") || args[0].contains("help")) {
      echoHelp();
    }

    String ip = args[0];
    String port = args[1];

    String urlString = String.format("service:jmx:rmi:///jndi/rmi://%s:%s/jmxrmi", ip, port);
    JMXConnector jmxc = null;
    MBeanServerConnection mbsc = null;

    try {
      echo("Connecting to AVM " + urlString);
      JMXServiceURL url = new JMXServiceURL(urlString);
      jmxc = JMXConnectorFactory.connect(url, null);
      mbsc = jmxc.getMBeanServerConnection();
    } catch (Exception e) {
      echo("Couldn't connect to AVM");
      e.printStackTrace();
      return;
    }

    try {

      String operationName = args[2];
      echo("\nInvoking Operation:" + operationName);
      echo("");

      ObjectName traceConfig = new ObjectName("com.conceptwave.AVM:type=AVM Trace");
      Object result = null;

      switch (operationName) {

      case "CreateTraceJob":

        result = mbsc.invoke(traceConfig, operationName,
            new Object[] { args[3], DT_FORMAT.parse(args[4]), DT_FORMAT.parse(args[5]), args[6] },
            new String[] { STR_CLASS, DT_CLASS, DT_CLASS, STR_CLASS });
        echo("Trace Job Created. Trace ID " + result);

        break;

      case "DeleteTraceJob":
        result = mbsc.invoke(traceConfig, operationName, new Object[] { args[3] },
            new String[] { STR_CLASS });
        echo("Trace Job " + ((boolean)result ? "successfully" : "could not be") + " deleted");
        break;

      case "ListTraceJobs":
        result = mbsc.invoke(traceConfig, operationName, new Object[0], new String[0]);
        String[] tracejobs = (String[])result;
        echo("List of Trace Jobs");
        for (int i = 0; i < tracejobs.length; i += 5) {
          echo("\t Trace ID         " + tracejobs[i]);
          echo("\t Trace Interface  " + tracejobs[i + 1]);
          echo("\t Trace StartTime  " + tracejobs[i + 2]);
          echo("\t Trace EndTime    " + tracejobs[i + 3]);
          echo("\t Trace Coverage   " + tracejobs[i + 4]);
          echo("");
        }
        break;

      case "AddTraceInterface":
        result = mbsc.invoke(traceConfig, operationName, new Object[] { args[3] },
            new String[] { STR_CLASS });
        echo("Trace interface activated.");
        break;

      case "RemoveTraceInterface":
        result = mbsc.invoke(traceConfig, operationName, new Object[] { args[3] },
            new String[] { STR_CLASS });
        echo("Trace interface " + ((boolean)result ? "successfully" : "could not be") + " removed.");
        break;

      case "ListTraceInterface":
        result = mbsc.invoke(traceConfig, operationName, new Object[0], new String[0]);
        String[] traceIfs = (String[])result;
        echo("List of active interfaces");
        for (String traceIf : traceIfs)
          echo("\t" + traceIf);
        break;

      case "AddTraceObject":
        result = mbsc.invoke(traceConfig, operationName, new Object[] { args[3], args[4], args[5],
            args[6] }, new String[] { STR_CLASS, STR_CLASS, STR_CLASS, STR_CLASS });
        echo("Trace object " + ((boolean)result ? "successfully" : "could not be") + " added.");
        break;

      case "RemoveTraceObject":
        result = mbsc.invoke(traceConfig, operationName, new Object[] { args[3], args[4] },
            new String[] { STR_CLASS, STR_CLASS });
        echo("Trace Job " + ((boolean)result ? "successfully" : "could not be") + " removed.");
        break;

      case "ListTraceObjects":
        result = mbsc.invoke(traceConfig, operationName, new Object[] { args[3] },
            new String[] { STR_CLASS });
        String[] traceObjs = (String[])result;
        echo("List of trace objects");
        for (int i = 0; i < traceObjs.length; i += 3) {
          echo("\t Trace Type      " + traceObjs[i]);
          echo("\t Trace Values    " + traceObjs[i + 1]);
          echo("\t Trace MacthType " + traceObjs[i + 2]);
          echo("");
        }
        break;

      default:
        echo("Operation not supported");
        echoHelp();
        break;
      }

    } catch (Exception e) {
      e.printStackTrace();
    }

    try {
      echo("\nClosing connection with AVM");
      jmxc.close();
    } catch (IOException e) {
      echo("\nError in closing connection with AVM");
      e.printStackTrace();
    }
  }

  private static void echo(String msg) {
    System.out.println(msg);
  }

  private static void echoHelp() {
    echo("Correct uasage: java com.conceptwave.config.AVMTraceConfigClient  AVM_IP JMX_Port Operation_Name [Operation_Parameters . . . ]");
    echo("Please check the documenataion for valid operation names and parameters for each operation");
  }

}
