package uk.co.microgen.batch.util;

import java.io.IOException;
import java.lang.ClassNotFoundException;
import java.math.BigDecimal;
import java.util.concurrent.TimeoutException;

import org.apache.log4j.Logger;

import uk.co.microgen.aptitude.bus.exceptions.BusException;
import uk.co.microgen.aptitude.exceptions.DataObjectInvalidException;
import uk.co.microgen.aptitude.exceptions.MalformedXMLException;
import uk.co.microgen.aptitude.bus.protocol.exceptions.BusServerException;
import uk.co.microgen.aptitude.bus.response.ServiceCallResponseWrapper;
import uk.co.microgen.aptitude.data.dataobject.DataObject;
import uk.co.microgen.aptitude.data.dataobject.DataObjectMessage;
import uk.co.microgen.aptitude.data.dataobject.DataSegmentValues;
import uk.co.microgen.aptitude.data.StringAttributeValue;
import uk.co.microgen.aptitude.data.NumericAttributeValue;
import uk.co.microgen.batch.CallAptitude;

public class CallAptitudeUtils
{
    private static final Logger LOGGER = Logger.getLogger ( CallAptitudeUtils.class );

    public static int registerBatchStepStarted
    (
        final String pAptitudeBusHost
    ,   final int    pAptitudeBusPort
    ,   final String pExecutionFolder
    ,   final String pUtilsProject
    ,   final String pProjectName
    ,   final String pMicroflow
    ,   final String pSessionID
    ,   final String pUseCaseID
    )
    throws IOException , BusException , DataObjectInvalidException , BusServerException , ClassNotFoundException , TimeoutException , Exception , MalformedXMLException
    {
        final String            COMPLEX_RULE_NAME              = "pr_register_batch_step_started";
        final DataObject        TRIGGERING_DATA_OBJECT         = CallAptitude.getTriggeringDataObject        ( CallAptitudeUtils.class.getResourceAsStream ( "BatchTaskStatus.xml" ) );
        final DataObjectMessage TRIGGERING_DATA_OBJECT_MESSAGE = CallAptitude.getTriggeringDataObjectMessage ( TRIGGERING_DATA_OBJECT );
        final DataSegmentValues TRIGGERING_OBJECT_MESSAGE_ROOT = TRIGGERING_DATA_OBJECT_MESSAGE.createRootSegment ();

        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "aptitude_project" , new StringAttributeValue  ( pProjectName ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "microflow"        , new StringAttributeValue  ( pMicroflow ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "session_id"       , new StringAttributeValue  ( pSessionID ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "use_case_id"      , new StringAttributeValue  ( pUseCaseID ) );
        
        LOGGER.debug ( "Invoking the complex rule: '" + COMPLEX_RULE_NAME + "'" );

        ServiceCallResponseWrapper response = CallAptitude.startComplexRule
                                              (
                                                  pExecutionFolder
                                              ,   pUtilsProject
                                              ,   pAptitudeBusHost
                                              ,   pAptitudeBusPort
                                              ,   COMPLEX_RULE_NAME
                                              ,   TRIGGERING_DATA_OBJECT_MESSAGE
                                              ,   TRIGGERING_DATA_OBJECT
                                              ,   "BatchTaskStatus"
                                              );

        LOGGER.debug ( "Successfully invoked the complex rule: '" + COMPLEX_RULE_NAME + "'" );

        return new Integer ( response.getMessage().getRoot().get ( 0 ).getValue ( "process_id" ).toString() );
    }

    public static int registerBatchStepCompleted
    (
        final String pAptitudeBusHost
    ,   final int    pAptitudeBusPort
    ,   final String pExecutionFolder
    ,   final String pUtilsProject
    ,   final int    pProcessId
    ,   final String pUseCaseID
    ,   final String pSessionID
    ,   final String pBatchStatus
    ,   final int    pRecordsProcessed
    ,   final int    pRecordsInError
    ,   final String pProjectName
    ,   final String pMicroflow
    )
    throws IOException , BusException , DataObjectInvalidException , BusServerException , ClassNotFoundException , TimeoutException , Exception , MalformedXMLException
    {
        final String            COMPLEX_RULE_NAME              = "pr_register_batch_step_comp";
        final DataObject        TRIGGERING_DATA_OBJECT         = CallAptitude.getTriggeringDataObject        ( CallAptitudeUtils.class.getResourceAsStream ( "BatchTaskStatus.xml" ) );
        final DataObjectMessage TRIGGERING_DATA_OBJECT_MESSAGE = CallAptitude.getTriggeringDataObjectMessage ( TRIGGERING_DATA_OBJECT );
        final DataSegmentValues TRIGGERING_OBJECT_MESSAGE_ROOT = TRIGGERING_DATA_OBJECT_MESSAGE.createRootSegment ();
        
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "process_id"        , new NumericAttributeValue ( new BigDecimal ( pProcessId ) ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "batch_status"      , new StringAttributeValue  ( pBatchStatus ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "records_processed" , new NumericAttributeValue ( new BigDecimal ( pRecordsProcessed ) ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "records_in_error"  , new NumericAttributeValue ( new BigDecimal ( pRecordsInError ) ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "use_case_id"       , new StringAttributeValue  ( pUseCaseID ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "session_id"        , new StringAttributeValue  ( pSessionID ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "aptitude_project"  , new StringAttributeValue  ( pProjectName ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "microflow"         , new StringAttributeValue  ( pMicroflow ) );

        LOGGER.debug ( "Invoking the complex rule: '" + COMPLEX_RULE_NAME + "'" );

        ServiceCallResponseWrapper response = CallAptitude.startComplexRule
                                              (
                                                  pExecutionFolder
                                              ,   pUtilsProject
                                              ,   pAptitudeBusHost
                                              ,   pAptitudeBusPort
                                              ,   COMPLEX_RULE_NAME
                                              ,   TRIGGERING_DATA_OBJECT_MESSAGE
                                              ,   TRIGGERING_DATA_OBJECT
                                              ,   "BatchTaskStatus"
                                              );

        LOGGER.debug ( "Successfully invoked the complex rule: '" + COMPLEX_RULE_NAME + "'" );
        
        return new Integer ( response.getMessage().getRoot().get ( 0 ).getValue ( "return_code" ).toString() );
    }
    
    public static Integer checkProcessEndState
    (
        final String pAptitudeBusHost
    ,   final int    pAptitudeBusPort
    ,   final String pExecutionFolder
    ,   final String pUtilsProject
    ,   final int    pProcessId
    ,   final String pUseCaseID
    )
    throws IOException , BusException , DataObjectInvalidException , BusServerException , ClassNotFoundException , TimeoutException , Exception , MalformedXMLException
    {
        final String            COMPLEX_RULE_NAME              = "pr_check_process_end_state";
        final DataObject        TRIGGERING_DATA_OBJECT         = CallAptitude.getTriggeringDataObject        ( CallAptitudeUtils.class.getResourceAsStream ( "BatchTaskStatus.xml" ) );
        final DataObjectMessage TRIGGERING_DATA_OBJECT_MESSAGE = CallAptitude.getTriggeringDataObjectMessage ( TRIGGERING_DATA_OBJECT );
        final DataSegmentValues TRIGGERING_OBJECT_MESSAGE_ROOT = TRIGGERING_DATA_OBJECT_MESSAGE.createRootSegment ();


        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "process_id"    , new NumericAttributeValue ( new BigDecimal ( pProcessId ) ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "use_case_id"   , new StringAttributeValue  ( pUseCaseID ) );
       
        LOGGER.debug ( "Invoking the complex rule: '" + COMPLEX_RULE_NAME + "'" );

        ServiceCallResponseWrapper response = CallAptitude.startComplexRule
                                              (
                                                  pExecutionFolder
                                              ,   pUtilsProject
                                              ,   pAptitudeBusHost
                                              ,   pAptitudeBusPort
                                              ,   COMPLEX_RULE_NAME
                                              ,   TRIGGERING_DATA_OBJECT_MESSAGE
                                              ,   TRIGGERING_DATA_OBJECT
                                              ,   "BatchTaskStatus"
                                              );

        LOGGER.debug ( "Successfully invoked the complex rule: '" + COMPLEX_RULE_NAME + "'" );
        
        return new Integer ( response.getMessage().getRoot().get ( 0 ).getValue ( "return_code" ).toString() );
        
    }
    
    public static void main ( String args [] ) throws Exception , MalformedXMLException
    {  
    	  final String APTITUDE_BUS_HOST   = args [ 1 ];
        final int    APTITUDE_BUS_PORT   = Integer.parseInt ( args [ 2 ] );
        final String FOLDER_NAME         = args [ 3 ];
        final String UTILITIES_PROJECT   = args [ 4 ];
        final String SQL_TYPE            = args [ 5 ];   
        final String QUERY               = args [ 6 ];      
        int    FAILURE_RETURN_CODE       = 3;          
        int    returnCode                = 0;
   	    
   	    try
        { 
   	      if ( args[0].equals("getUnixVariable") )
            returnCode =  getUnixVariable(     
                                 APTITUDE_BUS_HOST
                             ,   APTITUDE_BUS_PORT
                             ,   FOLDER_NAME
                             ,   UTILITIES_PROJECT
                             ,   SQL_TYPE
                             ,   QUERY
                           );           
        }
        catch ( Exception e )
        {
            LOGGER.error ( e );
            returnCode = FAILURE_RETURN_CODE;
        }
        finally 
        {
        	if ( returnCode != 0 )
          {
            LOGGER.error ( "Non zero return code" );
            System.exit  ( FAILURE_RETURN_CODE );
          } 
        }
    }  
    
    public static Integer getUnixVariable
    (
        final String pAptitudeBusHost
    ,   final int    pAptitudeBusPort
    ,   final String pExecutionFolder
    ,   final String pUtilsProject
    ,   final String pSqlType
    ,   final String pQuery 
    )
    throws IOException , BusException , DataObjectInvalidException , BusServerException , ClassNotFoundException , TimeoutException , Exception , MalformedXMLException
    {   
        final String            COMPLEX_RULE_NAME              = "pr_get_unix_variable";
        final DataObject        TRIGGERING_DATA_OBJECT         = CallAptitude.getTriggeringDataObject        ( CallAptitudeUtils.class.getResourceAsStream ( "UnixVariable.xml" ) );
        final DataObjectMessage TRIGGERING_DATA_OBJECT_MESSAGE = CallAptitude.getTriggeringDataObjectMessage ( TRIGGERING_DATA_OBJECT );
        final DataSegmentValues TRIGGERING_OBJECT_MESSAGE_ROOT = TRIGGERING_DATA_OBJECT_MESSAGE.createRootSegment ();
        String VARIABLE_VALUE;    
        Integer RET_CODE;   
        
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "sql_type"   , new StringAttributeValue  ( pSqlType ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "query"   , new StringAttributeValue  ( pQuery ) );
               
        LOGGER.debug ( "Invoking the complex rule: '" + COMPLEX_RULE_NAME + "'" );
          
        ServiceCallResponseWrapper response = CallAptitude.startComplexRule
                                              (     
                                                    pExecutionFolder
                                                ,   pUtilsProject
                                                ,   pAptitudeBusHost
                                                ,   pAptitudeBusPort
                                                ,   COMPLEX_RULE_NAME
                                                ,   TRIGGERING_DATA_OBJECT_MESSAGE
                                                ,   TRIGGERING_DATA_OBJECT
                                                ,   "UnixVariable"
                                              );
                                                       

        LOGGER.debug ( "Successfully invoked the complex rule: '" + COMPLEX_RULE_NAME + "'" );
        
        VARIABLE_VALUE  = new String   ( response.getMessage().getRoot().get ( 0 ).getValue ( "variable" ).toString() );
        System.out.println ( VARIABLE_VALUE ) ;
        return new Integer  ( response.getMessage().getRoot().get ( 0 ).getValue ( "return_code" ).toString() );          
    }  
    
    public static String getBatchParameters
    (
        final String pAptitudeBusHost
    ,   final int    pAptitudeBusPort
    ,   final String pExecutionFolder
    ,   final String pUtilsProject
    ,   final String pProjectName
    ,   final String pMicroflow
    ,   final String pSessionID
    ,   final String pUseCaseID
    )
    throws IOException , BusException , DataObjectInvalidException , BusServerException , ClassNotFoundException , TimeoutException , Exception , MalformedXMLException
    {
        final String            COMPLEX_RULE_NAME              = "set_run_parameters";
        final DataObject        TRIGGERING_DATA_OBJECT         = CallAptitude.getTriggeringDataObject        ( CallAptitudeUtils.class.getResourceAsStream ( "BatchTaskStatus.xml" ) );
        final DataObjectMessage TRIGGERING_DATA_OBJECT_MESSAGE = CallAptitude.getTriggeringDataObjectMessage ( TRIGGERING_DATA_OBJECT );
        final DataSegmentValues TRIGGERING_OBJECT_MESSAGE_ROOT = TRIGGERING_DATA_OBJECT_MESSAGE.createRootSegment ();

        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "aptitude_project" , new StringAttributeValue  ( pProjectName ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "microflow"        , new StringAttributeValue  ( pMicroflow ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "session_id"       , new StringAttributeValue  ( pSessionID ) );
        TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "use_case_id"      , new StringAttributeValue  ( pUseCaseID ) );
        
        LOGGER.debug ( "Invoking the complex rule: '" + COMPLEX_RULE_NAME + "'" );

        ServiceCallResponseWrapper response = CallAptitude.startComplexRule
                                              (
                                                  pExecutionFolder
                                              ,   pUtilsProject
                                              ,   pAptitudeBusHost
                                              ,   pAptitudeBusPort
                                              ,   COMPLEX_RULE_NAME
                                              ,   TRIGGERING_DATA_OBJECT_MESSAGE
                                              ,   TRIGGERING_DATA_OBJECT
                                              ,   "BatchTaskStatus"
                                              );

        LOGGER.debug ( "Successfully invoked the complex rule: '" + COMPLEX_RULE_NAME + "'" );

        return new String ( response.getMessage().getRoot().get ( 0 ).getValue ( "previous_run_time" ).toString() );
    }                  
}
