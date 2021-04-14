package uk.co.microgen.batch.control.task;

import java.math.BigDecimal;
import java.util.Calendar;
import java.text.SimpleDateFormat;
import java.text.DateFormat;
import java.util.Date;
import java.util.TimeZone;

import org.apache.log4j.Logger;

import uk.co.microgen.aptitude.bus.response.ServiceCallResponseWrapper;
import uk.co.microgen.aptitude.data.dataobject.DataObject;
import uk.co.microgen.aptitude.data.dataobject.DataObjectMessage;
import uk.co.microgen.aptitude.data.dataobject.DataSegmentValues;
import uk.co.microgen.aptitude.data.NumericAttributeValue;
import uk.co.microgen.aptitude.data.StringAttributeValue;
import uk.co.microgen.aptitude.exceptions.MalformedXMLException;
import uk.co.microgen.batch.CallAptitude;
import uk.co.microgen.batch.util.CallAptitudeUtils;

public class StartTask
{
    private static final Logger LOGGER = Logger.getLogger ( StartTask.class );

    public static void main ( String args [] ) throws Exception , MalformedXMLException
    {
        final String APTITUDE_BUS_HOST        = args [ 0 ];
        final int    APTITUDE_BUS_PORT        = Integer.parseInt ( args [ 1 ] );
        final String FOLDER_NAME              = args [ 2 ];
        final String UTILITIES_PROJECT        = args [ 3 ];
        final String PROJECT_NAME             = args [ 4 ];
        final String MICROFLOW_NAME           = args [ 5 ];
        final String SESSION_ID               = args [ 6 ];
        final String USE_CASE_ID              = args [ 7 ];
        final int    UC4_RUN_ID               = Integer.parseInt ( args [ 8 ] );
        final String MAINTAIN_DATA_ID         = args [ 9 ];
        final String MESSAGE_TEXT             = args [ 10 ];
              int    returnCode               = 0;
              String BATCH_STATUS             = "C";
              String BATCH_STATUS_STARTABLE   = "";
              String BATCH_STATUS_TOTALS      = "";
              String BATCH_STATUS_ROWS        = "";
              String BATCH_STATUS_HELD        = "";
              String BATCH_STATUS_MICRO       = "";
              String mainProcessEndState      = "";
              String returnedDataObject       = "";
              int    RECORDS_PROCESSED        = 0;
              int    RECORDS_IN_ERROR         = 0;
              int    PROCESS_ID               = -1;
              int    FAILURE_RETURN_CODE      = 3;
              int    STOP_RETURN_CODE         = 9;
              String PREV_RUN_TIME;
              String CURR_RUN_TIME;
              String PREV_RUN_TIME_GMT;
              String CURR_RUN_TIME_GMT;
              String COUNTERPARTY;
              String DATA_OBJECT_XML_FORMAT  = "BatchTaskStatus.xml";
                Date date = new Date();

              DateFormat df = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
              df.setTimeZone(TimeZone.getDefault());

              DateFormat df_gmt = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
              df_gmt.setTimeZone(TimeZone.getTimeZone("GMT"));

        LOGGER.info ( "Execution Folder = '" + FOLDER_NAME      + "'" );
        LOGGER.info ( "Project name     = '" + PROJECT_NAME     + "'" );
        LOGGER.info ( "Microflow name   = '" + MICROFLOW_NAME   + "'" );
        LOGGER.info ( "session id       = '" + SESSION_ID       + "'" );
        LOGGER.info ( "use case id      = '" + USE_CASE_ID      + "'" );
        LOGGER.info ( "UC4 run id       = '" + UC4_RUN_ID       + "'" );
        LOGGER.info ( "Maintain Data ID = '" + MAINTAIN_DATA_ID + "'" );
        LOGGER.info ( "Message Text     = '" + MESSAGE_TEXT     + "'" );

        try
        {
            final DataObject        TRIGGERING_DATA_OBJECT         = CallAptitude.getTriggeringDataObject        ( StartTask.class.getResourceAsStream ( DATA_OBJECT_XML_FORMAT ) );
            final DataObjectMessage TRIGGERING_DATA_OBJECT_MESSAGE = CallAptitude.getTriggeringDataObjectMessage ( TRIGGERING_DATA_OBJECT );
            final DataSegmentValues TRIGGERING_OBJECT_MESSAGE_ROOT = TRIGGERING_DATA_OBJECT_MESSAGE.createRootSegment ();

            TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "aptitude_project" , new StringAttributeValue  ( PROJECT_NAME ) );
            TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "microflow"        , new StringAttributeValue  ( MICROFLOW_NAME ) );
            TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "session_id"       , new StringAttributeValue  ( SESSION_ID ) );
            TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "use_case_id"      , new StringAttributeValue  ( USE_CASE_ID ) );
            TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "process_id"       , new NumericAttributeValue ( new BigDecimal ( UC4_RUN_ID ) ) );
            TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "return_code"      , new NumericAttributeValue ( BigDecimal.ZERO ) );
            TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "maintain_data_id" , new StringAttributeValue  ( MAINTAIN_DATA_ID ) );
            TRIGGERING_OBJECT_MESSAGE_ROOT.setValue ( "message_text"     , new StringAttributeValue  ( MESSAGE_TEXT ) );
            
            String  REG_BATCH_START_MICROFLOW  = "start_batch_task";
            ServiceCallResponseWrapper response = CallAptitude.startMicroflow
                                                   (
                                                       FOLDER_NAME
                                                   ,   UTILITIES_PROJECT
                                                   ,   APTITUDE_BUS_HOST
                                                   ,   APTITUDE_BUS_PORT
                                                   ,   REG_BATCH_START_MICROFLOW
                                                   ,   TRIGGERING_DATA_OBJECT_MESSAGE
                                                   ,   TRIGGERING_DATA_OBJECT
                                                   );
                                                   
           BATCH_STATUS_STARTABLE        = new String  ( response.getMessage().getRoot().get ( 0 ).getValue ( "batch_status" ).toString() );
           
           if ( BATCH_STATUS_STARTABLE.equals("E") )
           {
            LOGGER.error ( "Batch Task cannot be started. Check if process " + PROJECT_NAME + "." + MICROFLOW_NAME +" is already running for session id " + SESSION_ID );
            System.exit  ( FAILURE_RETURN_CODE );
           }
           
           PROCESS_ID          = new Integer ( response.getMessage().getRoot().get ( 0 ).getValue ( "process_id" ).toString() );
           TRIGGERING_OBJECT_MESSAGE_ROOT.setValue (  "process_id", new NumericAttributeValue ( new BigDecimal ( PROCESS_ID ) ) );
           
           // Set run time variables
           // both in local timezone (default) and gmt so either variable can be used
           PREV_RUN_TIME       = new String  ( response.getMessage().getRoot().get ( 0 ).getValue ( "previous_run_time" ).toString() );
           TRIGGERING_OBJECT_MESSAGE_ROOT.setValue (  "previous_run_time", new StringAttributeValue ( PREV_RUN_TIME ) );

           PREV_RUN_TIME_GMT   = new String  ( response.getMessage().getRoot().get ( 0 ).getValue ( "previous_run_time_gmt" ).toString() );
           TRIGGERING_OBJECT_MESSAGE_ROOT.setValue (  "previous_run_time_gmt", new StringAttributeValue ( PREV_RUN_TIME_GMT ) );

           CURR_RUN_TIME = df.format(date);
           TRIGGERING_OBJECT_MESSAGE_ROOT.setValue (  "current_run_time", new StringAttributeValue ( CURR_RUN_TIME ) );

           CURR_RUN_TIME_GMT = df_gmt.format(date);
           TRIGGERING_OBJECT_MESSAGE_ROOT.setValue (  "current_run_time_gmt", new StringAttributeValue ( CURR_RUN_TIME_GMT) );
           
           COUNTERPARTY       = new String  ( response.getMessage().getRoot().get ( 0 ).getValue ( "counterparty_system" ).toString() );
           TRIGGERING_OBJECT_MESSAGE_ROOT.setValue (  "counterparty_system", new StringAttributeValue ( COUNTERPARTY ) );

           LOGGER.info ( "");
           LOGGER.info ( "PROCESS_ID is        '" + PROCESS_ID        + "'");
           LOGGER.info ( "PREV_RUN_TIME is     '" + PREV_RUN_TIME     + "'");
           LOGGER.info ( "PREV_RUN_TIME_GMT is '" + PREV_RUN_TIME_GMT + "'");
           LOGGER.info ( "CURR_RUN_TIME is     '" + CURR_RUN_TIME     + "'");
           LOGGER.info ( "CURR_RUN_TIME_GMT is '" + CURR_RUN_TIME_GMT + "'");
           LOGGER.info ( "Counterparty is      '" + COUNTERPARTY      + "'");
           
           LOGGER.info ( "The local time frame is set from '" + PREV_RUN_TIME + "' to '" + CURR_RUN_TIME + "'" );
           LOGGER.info ( "The GMT time frame is set from '" + PREV_RUN_TIME_GMT + "' to '" + CURR_RUN_TIME_GMT + "'" );

            response = CallAptitude.startMicroflow
                                                  (
                                                      FOLDER_NAME
                                                  ,   PROJECT_NAME
                                                  ,   APTITUDE_BUS_HOST
                                                  ,   APTITUDE_BUS_PORT
                                                  ,   MICROFLOW_NAME
                                                  ,   TRIGGERING_DATA_OBJECT_MESSAGE
                                                  ,   TRIGGERING_DATA_OBJECT
                                                  );

            BATCH_STATUS        = new String  ( response.getMessage().getRoot().get ( 0 ).getValue ( "batch_status" ).toString() );
            RECORDS_PROCESSED   = new Integer ( response.getMessage().getRoot().get ( 0 ).getValue ( "records_processed" ).toString() );
            RECORDS_IN_ERROR    = new Integer ( response.getMessage().getRoot().get ( 0 ).getValue ( "records_in_error" ).toString() );
            returnedDataObject  = new String  ( response.getMessage().getRoot().get ( 0 ).toString() );
            mainProcessEndState = BATCH_STATUS;

            String  DQ_TOTALS_COMPLEX_RULE  = "pr_dq_wrapper_totals";
            ServiceCallResponseWrapper dqwrappertotals = CallAptitude.startComplexRule
                                                        (
                                                            FOLDER_NAME
                                                        ,   UTILITIES_PROJECT
                                                        ,   APTITUDE_BUS_HOST
                                                        ,   APTITUDE_BUS_PORT
                                                        ,   DQ_TOTALS_COMPLEX_RULE
                                                        ,   TRIGGERING_DATA_OBJECT_MESSAGE
                                                        ,   TRIGGERING_DATA_OBJECT
                                                        ,   "BatchTaskStatus"
                                                        );

            BATCH_STATUS_TOTALS        = new String  ( dqwrappertotals.getMessage().getRoot().get ( 0 ).getValue ( "batch_status").toString() );

            LOGGER.info ( "batch_status returned by pr_dq_wrapper_totals = " + BATCH_STATUS_TOTALS );

            String  DQ_ROW_COMPLEX_RULE  = "pr_dq_wrapper_row";
            ServiceCallResponseWrapper dqwrapperrow = CallAptitude.startComplexRule
                                                        (
                                                            FOLDER_NAME
                                                        ,   UTILITIES_PROJECT
                                                        ,   APTITUDE_BUS_HOST
                                                        ,   APTITUDE_BUS_PORT
                                                        ,   DQ_ROW_COMPLEX_RULE
                                                        ,   TRIGGERING_DATA_OBJECT_MESSAGE
                                                        ,   TRIGGERING_DATA_OBJECT
                                                        ,   "BatchTaskStatus"
                                                        );

            BATCH_STATUS_ROWS          = new String  ( dqwrapperrow.getMessage().getRoot().get ( 0 ).getValue ( "batch_status").toString() );

            LOGGER.info ( "batch_status returned by pr_dq_wrapper_row = " + BATCH_STATUS_ROWS );

            String  RESET_EVENTS_COMPLEX_RULE  = "pr_reset_events_on_hold";
            ServiceCallResponseWrapper reseteventsonhold = CallAptitude.startComplexRule
                                                        (
                                                            FOLDER_NAME
                                                        ,   UTILITIES_PROJECT
                                                        ,   APTITUDE_BUS_HOST
                                                        ,   APTITUDE_BUS_PORT
                                                        ,   RESET_EVENTS_COMPLEX_RULE
                                                        ,   TRIGGERING_DATA_OBJECT_MESSAGE
                                                        ,   TRIGGERING_DATA_OBJECT
                                                        ,   "BatchTaskStatus"
                                                        );

            BATCH_STATUS_HELD          = new String  ( reseteventsonhold.getMessage().getRoot().get ( 0 ).getValue ( "batch_status").toString() );

            LOGGER.info ( "batch_status returned by pr_reset_events_on_hold = " + BATCH_STATUS_HELD );

        }
        catch ( MalformedXMLException mxe )
        {
            LOGGER.error ( mxe );
            BATCH_STATUS = "E";
            returnCode = FAILURE_RETURN_CODE;
        }
        catch ( Exception e )
        {
            LOGGER.error ( e );
            BATCH_STATUS = "E";
            returnCode = FAILURE_RETURN_CODE;
        }
        finally
        {
            if ( PROCESS_ID != -1 )
            {
                  // Always run registerBatchStepCompleted if job was registered (PROCESS_ID set)
                  returnCode = CallAptitudeUtils.registerBatchStepCompleted
                                                 (
                                                      APTITUDE_BUS_HOST
                                                  ,   APTITUDE_BUS_PORT
                                                  ,   FOLDER_NAME
                                                  ,   UTILITIES_PROJECT
                                                  ,   PROCESS_ID
                                                  ,   USE_CASE_ID
                                                  ,   SESSION_ID
                                                  ,   BATCH_STATUS
                                                  ,   RECORDS_PROCESSED
                                                  ,   RECORDS_IN_ERROR
                                                  ,   PROJECT_NAME
                                                  ,   MICROFLOW_NAME
                                                  );
                 
                 LOGGER.debug ( "Return Code  = " + returnCode);
                 
                 if  ( ! mainProcessEndState.equals ( "C" ) || returnCode != 0 )
                   {
                     // In case of an error print out the data object, which contains the error message
                     LOGGER.error ( "The data object '" + returnedDataObject + "' was returned." );
                   }
            }

          if ( mainProcessEndState.equals ( "H" ) )
          {
            System.exit  ( STOP_RETURN_CODE );
          }
          
          if ( ! BATCH_STATUS_TOTALS.equals("C") )
          {
            LOGGER.error ( "DQ Totals batch status was not C" );
            returnCode = FAILURE_RETURN_CODE;
          }
          if ( ! BATCH_STATUS_ROWS.equals("C") )
          {
            LOGGER.error ( "DQ Rows batch status was not C" );
            returnCode = FAILURE_RETURN_CODE;
          }
          if ( ! BATCH_STATUS_HELD.equals("C") )
          {
            LOGGER.error ( "DQ held events batch status was not C" );
            returnCode = FAILURE_RETURN_CODE;
          }

          if ( returnCode != 0 )
          {
            LOGGER.error ( "Non zero return code" );
            System.exit  ( FAILURE_RETURN_CODE );
          }
        }
    }
}
