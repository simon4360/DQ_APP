package com.microgen.quality.tlf.csv;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.string.ITokenReplacement;

import java.nio.file.Path;

import java.nio.file.Files;
import java.io.Reader;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
import java.util.TreeMap;
import java.util.SortedMap;
import java.util.Map;
import java.text.SimpleDateFormat;

import org.apache.commons.csv.CSVRecord;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVParser;

import org.apache.log4j.Logger;

public class OracleCsvOperator implements ICSVOperator
{
    private static final Logger LOG = Logger.getLogger ( OracleCsvOperator.class );

    private IDatabaseConnector databaseConnector;

    private SortedMap<Integer,CsvColumnDetails> getCsvColumnDetails ( final CSVRecord pCSVHeaderInfo )
    {
        final SortedMap<Integer,CsvColumnDetails> CSVCOLDTLS = new TreeMap<Integer,CsvColumnDetails> ();
        
        int i = 0;
        
        for (Map.Entry<String, String> entry : pCSVHeaderInfo.toMap().entrySet()) {
           //ddl = ddl + ", " + entry.getKey().trim() + " " + entry.getValue().toString().trim() + " ";
           
           i++;
           
           CsvColumnDetails colDtls = new CsvColumnDetails ();
           
           colDtls.colName     =  entry.getKey() .trim ().toLowerCase ();
           
           colDtls.colIndex    =  i;
          
           colDtls.isDate      =  entry.getValue() .toString() .trim ().replaceAll("^\"|\"$", "").toLowerCase ().equals     ( "date" );
           
           colDtls.isTimestamp =  entry.getValue() .toString() .trim ().replaceAll("^\"|\"$", "").toLowerCase ().startsWith ( "timestamp" );
           
           colDtls.isNumber    =  entry.getValue() .toString() .trim ().replaceAll("^\"|\"$", "").toLowerCase ().startsWith ( "decimal" )
                               || entry.getValue() .toString() .trim ().replaceAll("^\"|\"$", "").toLowerCase ().startsWith ( "number"  );
           
           colDtls.isInteger   =  entry.getValue() .toString() .trim ().replaceAll("^\"|\"$", "").toLowerCase ().equals ( "integer" );
           
           String isSqlInd     = "N";

           colDtls.isSQL = isSqlInd.equals ( "Y" );
           
            LOG.debug ( "The column '"        + colDtls.colName + "' was found at index location '" + i + "'" );

            LOG.debug ( "Is it a date? "      + colDtls.isDate );

            LOG.debug ( "Is it a timestamp? " + colDtls.isTimestamp );

            LOG.debug ( "Is it a Number? "    + colDtls.isNumber );

            LOG.debug ( "Is it an integer ? " + colDtls.isInteger );

            LOG.debug ( "Is it SQL ? "        + colDtls.isSQL );
            
            CSVCOLDTLS.put ( i , colDtls );
        }
        return CSVCOLDTLS;
    }

    public OracleCsvOperator ( final IDatabaseConnector pIDatabaseConnector )
    {
        databaseConnector = pIDatabaseConnector;
    }
    
    public void createDatabaseTableFromCsvFile ( final String pTableOwner , final String pTableName , final Path pPathToCsvFile ) throws Exception
    {
        LOG.info ( "The table '" + pTableOwner + "." + pTableName + "' will be created, based on the csv file at '" + pPathToCsvFile + "'" );

        Reader csv = Files.newBufferedReader( pPathToCsvFile ) ;
        CSVFormat csvFormat = CSVFormat.EXCEL.withFirstRecordAsHeader();
        CSVParser csvParser = csvFormat.parse(csv);
        CSVRecord firstRecord = csvParser.iterator().next();
        final int SPREADSHEET_WIDTH = firstRecord.size();
        
        LOG.debug ( "The width of the CSV file calculated to be '" + SPREADSHEET_WIDTH + "' columns" );
        
        String            ddl   = "";
        Connection        conn  = null;
        PreparedStatement pStmt = null;
        
        for (Map.Entry<String, String> entry : firstRecord.toMap().entrySet()) {
           ddl = ddl + ", " + entry.getKey().trim() + " " + entry.getValue().toString().trim() + " ";
        }

        ddl = "create table " + pTableOwner + "." + pTableName + " ( " + ddl.replaceAll ( "^,+" , "" ) + " )";

        LOG.debug ( "The DDL '" + ddl + "' has been generated from the csv file " + pPathToCsvFile);
        
        try
        {
            conn = databaseConnector.getConnection ();

            LOG.debug ( "A connection to the database was successfully retrieved" );

            pStmt = conn.prepareStatement ( ddl );

            LOG.debug ( "The DDL statement was successfully prepared" );

            pStmt.executeUpdate ();

            LOG.debug ( "The DDL statement was successfully executed" );

            conn.commit ();
        }
        catch ( SQLException sqle )
        {
            LOG.fatal ( "SQL Exception: " + sqle );

            SQLException childsqle = sqle.getNextException();

            while (childsqle != null)
            {
                LOG.fatal ( "SQL Exception detail: " + childsqle);
                childsqle = childsqle.getNextException();
            }

            throw sqle;
        }
        finally
        {
            LOG.debug ( "Closing 'csv'" );
            
            csv.close();
            
            LOG.debug ( "Closing 'pStmt'" );

            pStmt.close ();

            LOG.debug ( "Closing 'conn'" );

            conn.close ();

            LOG.debug ( "Closed 'conn'" );

            LOG.debug ( "Closed 'pStmt'" );

            LOG.debug ( "Closed 'csv'" );
        }
    
        LOG.debug ( "The table '" + pTableOwner + "." + pTableName  + "' has been created successfully using the DDL '" + ddl + "'" );
    }


    public void loadCsvFileToDatabaseTable ( final String pTableOwner , final String pTableName , final Path pPathToCsvFile , final ITokenReplacement pITokenReplacement ) throws Exception
    {
        LOG.info ( "Data will be loaded into the table '" + pTableOwner + "." + pTableName + "', based on the csv file at '" + pPathToCsvFile + "'" );

              String            ddl                = "";
              String            colddl             = "";
              String            valddl             = "";
              boolean           ddlContainsSQL     = false;
              int               numRecordsToInsert = 0;
              Connection        conn               = null;
              PreparedStatement pStmt              = null;
              
              Reader csv = Files.newBufferedReader( pPathToCsvFile ) ;
              Iterable<CSVRecord> records = CSVFormat.EXCEL.withFirstRecordAsHeader().parse(csv);
        final SortedMap<Integer,CsvColumnDetails> CSVCOLDTLS = getCsvColumnDetails ( records.iterator().next() ) ;

        LOG.info ( "Build an insert statement to target '" + pTableOwner + "." + pTableName + "'" );

        for ( SortedMap.Entry<Integer,CsvColumnDetails> cvsCol : CSVCOLDTLS.entrySet () )
        {
            CsvColumnDetails colDtls = cvsCol.getValue ();
        
            colddl = colddl + ", " + colDtls.colName;
        
            if ( colDtls.isSQL )
            {
                valddl         = valddl + ", ( <" + colDtls.colIndex + "> ) ";
        
                ddlContainsSQL = true;
            }
            else
            {
                valddl = valddl + ", ? ";
            }
        }
        
        ddl = "insert into " + pTableOwner + "." + pTableName + " ( " + colddl.replaceAll ( "^,+" , "" ) + " ) values ( " + valddl.replaceAll ( "^,+" , "" ) + " ) ";
        
        LOG.info ( "The SQL will be used to load data is '" + ddl + "'" );
        
        try
        {
            conn = databaseConnector.getConnection ();
                      
            LOG.info ( "The insert statement contains only values" );
        
            LOG.info ( "Prepare the statement '" + pITokenReplacement.replaceTokensInString ( ddl ) + "'" );
        
            LOG.debug ( "Connection is null? '" + ( conn == null ) + "'" );
            
            pStmt = conn.prepareStatement ( pITokenReplacement.replaceTokensInString ( ddl ) );
            
            LOG.debug ( "The SQL '" + ddl + "' was successfully prepared" );
        
            for (CSVRecord record : records) 
            {
                Integer           ColId   = 0;
            
                if ( record.getRecordNumber() >= 3 ) 
                {
                    ColId   = 0;
                    for (Map.Entry<String, String> entry : record.toMap().entrySet()) 
                    {
                        ColId++;
                        CsvColumnDetails currColDtls = CSVCOLDTLS.get ( new Integer ( ColId ) );
                        String currCell = entry.getValue().toString().replaceAll("^\"|\"$", "").trim() ;
                
                        LOG.debug ( "Examining record " + record.getRecordNumber() + ", attribute " + ColId + ", " + currColDtls.colName + "', value : '" + currCell + "'" );
                       
                        if ( currCell == null || currCell.equals(""))
                        {
                            LOG.debug ( "Cell '" + ColId + "' will be treated as being blank / null" );
                
                            if ( currColDtls.isDate )
                            {
                                LOG.debug ( "Cell '" + ColId + "': binding null date to DDL" );
                              
                                pStmt.setNull ( currColDtls.colIndex , Types.DATE );
                            }
                            else if ( currColDtls.isTimestamp )
                            {
                                LOG.debug ( "Cell '" + ColId + "': binding null timestamp to DDL" );
                              
                                pStmt.setNull ( currColDtls.colIndex , Types.TIMESTAMP );
                            }
                            else if ( currColDtls.isNumber )
                            {
                                LOG.debug ( "Cell '" + ColId + "': binding null number to DDL" );
                              
                                pStmt.setNull ( currColDtls.colIndex , Types.DOUBLE );
                            }
                            else if ( currColDtls.isInteger )
                            {
                                LOG.debug ( "Cell '" + ColId + "': binding null integer to DDL" );
                              
                                pStmt.setNull ( currColDtls.colIndex , Types.INTEGER );
                            }
                            else
                            {
                                LOG.debug ( "Cell '" + ColId + "': binding null string to DDL" );
                              
                                pStmt.setNull ( currColDtls.colIndex  , Types.VARCHAR );
                            }
                        }
                        else
                        {
                            if ( currColDtls.isDate )
                            {
                                LOG.debug ( "Cell '" + ColId + "': binding date to DDL" );
                             
                                pStmt.setDate ( currColDtls.colIndex , new java.sql.Date ( new SimpleDateFormat("dd/MM/yyyy").parse (currCell).getTime () ) );
                            }
                            else if ( currColDtls.isTimestamp )
                            {
                                LOG.debug ( "Cell '" + ColId + "': binding timestamp to DDL" );
                             
                                pStmt.setTimestamp ( currColDtls.colIndex  , new java.sql.Timestamp ( new SimpleDateFormat("dd/MM/yyyy").parse (currCell).getTime ()  ) );
                            }
                            else if ( currColDtls.isNumber )
                            {
                                LOG.debug ( "Cell '" + ColId + "': binding number to DDL" );
                             
                                pStmt.setDouble ( currColDtls.colIndex , Double.valueOf(currCell));
                            }
                            else if ( currColDtls.isInteger )
                            {
                                LOG.debug ( "Cell '" + ColId + "': binding integer to DDL" );
                             
                                pStmt.setInt ( currColDtls.colIndex , ( int ) ( Integer.parseInt(currCell) ) );
                            }
                            else
                            {
                                LOG.debug ( "Cell '" +  ColId  + "': binding string to DDL" );
                             
                                pStmt.setString ( currColDtls.colIndex , currCell );
                                  
                            }
                        }
                    }
                    
                    LOG.debug ( "Adding insert statement to the batch of insert statements" );
                
                    pStmt.addBatch ();
                
                    numRecordsToInsert++;
                }
            }
            if ( numRecordsToInsert > 0 )
            {
                LOG.debug ( "Executing batch" );
            
                int [] batchCount = pStmt.executeBatch ();
            
                if ( batchCount == null )
                {
                    throw new Exception ( "No records were inserted" );
                }
                else if ( batchCount.length != numRecordsToInsert )
                {
                    LOG.debug ( "The batch insert created '" + batchCount.length + "' records. '" + numRecordsToInsert + "' was expected." );
            
                    conn.rollback ();
            
                    throw new Exception ( "The batch insert created '" + batchCount.length + "' records. '" + numRecordsToInsert + "' was expected." );
                }
                else
                {
                    conn.commit ();
                }
            }
        }
        catch ( SQLException sqle )
        {
          LOG.fatal ( "SQL Exception: " + sqle );
        
          SQLException childsqle = sqle.getNextException();
        
          while (childsqle != null)
          {
            LOG.fatal ( "SQL Exception detail: " + childsqle);
            childsqle = childsqle.getNextException();
          }
        
          throw sqle;
        }
        finally
        {
          LOG.debug ( "Closing 'csv'" );
          csv.close();
          LOG.debug ( "Closing 'pStmt'" );
          pStmt.close ();
          LOG.debug ( "Closing 'conn'" );
          conn.close ();
          LOG.debug ( "Closed 'conn'" );
          LOG.debug ( "Closing 'pStmt'" );
          LOG.debug ( "Closed 'csv'" );
        }
        
        LOG.debug ( "'" + numRecordsToInsert + " records were successfully loaded into the database table " + pTableOwner + "." + pTableName + "'" );
    }
}
