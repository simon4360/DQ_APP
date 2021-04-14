package com.microgen.quality.tlf.excel;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.string.ITokenReplacement;

import java.nio.file.Path;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
import java.util.TreeMap;
import java.util.SortedMap;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFRow;

import org.apache.log4j.Logger;

public class TeradataExcelOperator implements IExcelOperator
{
    private static final Logger LOG = Logger.getLogger ( TeradataExcelOperator.class );

    private IDatabaseConnector databaseConnector;

    private SortedMap<Integer,ExcelColumnDetails> getExcelColumnDetails ( final XSSFSheet pExcelWorksheetSheet )
    {
        final SortedMap<Integer,ExcelColumnDetails> XLCOLDTLS = new TreeMap<Integer,ExcelColumnDetails> ();

        for ( Cell stCell : pExcelWorksheetSheet.getRow ( 0 ) )
        {
            ExcelColumnDetails colDtls = new ExcelColumnDetails ();

            colDtls.colName     = stCell.getStringCellValue ().trim ().toLowerCase ();

            colDtls.colIndex    = stCell.getColumnIndex ();

            colDtls.isDate      = pExcelWorksheetSheet .getRow ( 1 ).getCell ( colDtls.colIndex ).getStringCellValue ().trim ().toLowerCase ().equals     ( "date" );

            colDtls.isTimestamp = pExcelWorksheetSheet .getRow ( 1 ).getCell ( colDtls.colIndex ).getStringCellValue ().trim ().toLowerCase ().startsWith ( "timestamp" );

            colDtls.isNumber    =    pExcelWorksheetSheet .getRow ( 1 ).getCell ( colDtls.colIndex ).getStringCellValue ().trim ().toLowerCase ().startsWith ( "decimal" )
                                  || pExcelWorksheetSheet .getRow ( 1 ).getCell ( colDtls.colIndex ).getStringCellValue ().trim ().toLowerCase ().equals     ( "number" );

            colDtls.isInteger   = pExcelWorksheetSheet .getRow ( 1 ).getCell ( colDtls.colIndex ).getStringCellValue ().trim ().toLowerCase ().equals ( "integer" );

            String isSqlInd     = pExcelWorksheetSheet .getRow ( 2 ).getCell ( colDtls.colIndex ).getStringCellValue ().trim ();

            if ( ! ( isSqlInd.equals ( "Y") || isSqlInd.equals ( "N") ) )
            {
                LOG.debug ( "The 'IS SQL? INDICATOR' must have a value of 'Y' or 'N' - it has a value of '" + isSqlInd + "' for column '" + colDtls.colName + "'" );

                assert ( false );
            }

            colDtls.isSQL = isSqlInd.equals ( "Y" );

            LOG.debug ( "The column '"        + colDtls.colName + "' was found at index location '" + colDtls.colIndex + "'" );

            LOG.debug ( "Is it a date? "      + colDtls.isDate );

            LOG.debug ( "Is it a timestamp? " + colDtls.isTimestamp );

            LOG.debug ( "Is it a Number? "    + colDtls.isNumber );

            LOG.debug ( "Is it an integer ? " + colDtls.isInteger );

            LOG.debug ( "Is it SQL ? "        + colDtls.isSQL );

            XLCOLDTLS.put ( new Integer ( colDtls.colIndex ) , colDtls );
        }

        return XLCOLDTLS;
    }


    public void createDatabaseTableFromExcelTab ( final String pTableOwner , final Path pPathToExcelFile , final String pExcelTabName ) throws Exception
    {
        LOG.debug ( "The table '" + pTableOwner + "." + pExcelTabName + "' will be created, based on the excel file at '" + pPathToExcelFile + "'" );

        final XSSFWorkbook XL = new XSSFWorkbook ( pPathToExcelFile.toFile () );

        LOG.debug ( "A reference to the excel file was retrieved" );

        final XSSFSheet ST  = XL.getSheet ( pExcelTabName );

        if ( ST == null )
        {
            LOG.fatal ( "The tab '" + pExcelTabName + "' within the excel file at '" + pPathToExcelFile + "' does not exist" );

            assert ( false );
        }

        final XSSFRow CN = ST.getRow        ( 0 );

        LOG.debug ( "A reference to row '0' in the excel tab '" + pExcelTabName + "' was retrieved" );

        final XSSFRow DT = ST.getRow        ( 1 );

        LOG.debug ( "A reference to row '1' in the excel tab '" + pExcelTabName + "' was retrieved" );

        String            ddl   = "";
        Connection        conn  = null;
        PreparedStatement pStmt = null;

        for ( Cell cnCell : CN )
        {
            ddl = ddl + ", " + cnCell.getStringCellValue ().trim () + " " + DT.getCell ( cnCell.getColumnIndex() ).getStringCellValue ().trim () + " ";
        }

        ddl = "create table " + pTableOwner + "." + pExcelTabName + " ( " + ddl.replaceAll ( "^,+" , "" ) + " ) no primary index ";

        LOG.debug ( "The DDL '" + ddl + "' has been generated from the excel" );

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
            LOG.debug ( "Closing 'pStmt'" );

            pStmt.close ();

            LOG.debug ( "Closed 'pStmt'" );

            LOG.debug ( "Closing 'conn'" );

            conn.close ();

            LOG.debug ( "Closed 'conn'" );

            LOG.debug ( "Closing 'XL'" );

            LOG.debug ( "Closed 'XL'" );
        }

        LOG.debug ( "The table '" + pTableOwner + "." + pExcelTabName + "' has been created successfully using the DDL '" + ddl + "'" );
    }

    public void loadExcelTabToDatabaseTable ( final String pTableOwner , final Path pPathToExcelFile , final String pExcelTabName , final ITokenReplacement pITokenReplacement ) throws Exception
    {
        LOG.debug ( "Data will be loaded into the table '" + pTableOwner + "." + pExcelTabName + "', based on the excel file at '" + pPathToExcelFile + "'" );

        final XSSFWorkbook XL = new XSSFWorkbook ( pPathToExcelFile.toFile () );

        LOG.debug ( "A reference to the excel file was retrieved" );

        final XSSFSheet ST = XL.getSheet ( pExcelTabName );

        if ( ST == null )
        {
            LOG.fatal ( "The tab '" + pExcelTabName + "' within the excel file at '" + pPathToExcelFile + "' does not exist" );

            assert ( false );
        }

        final int SPREADSHEET_WIDTH = ST.getRow ( 0 ).getPhysicalNumberOfCells ();

        LOG.debug ( "The width of the spreadsheet's tab was calculated to be '" + SPREADSHEET_WIDTH + "' cells" );

        final SortedMap<Integer,ExcelColumnDetails> XLCOLDTLS = getExcelColumnDetails ( ST );

              Connection        conn    = null;
              PreparedStatement pStmt   = null;

        String  ddl                = "";
        String  colddl             = "";
        String  valddl             = "";
        boolean ddlContainsSQL     = false;
        int     numRecordsToInsert = 0;

        LOG.debug ( "Build an insert statement to target '" + pTableOwner + "." + pExcelTabName + "'" );

        for ( SortedMap.Entry<Integer,ExcelColumnDetails> xlCol : XLCOLDTLS.entrySet () )
        {
            ExcelColumnDetails colDtls = xlCol.getValue ();

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

        ddl = "insert into " + pTableOwner + "." + pExcelTabName + " ( " + colddl.replaceAll ( "^,+" , "" ) + " ) values ( " + valddl.replaceAll ( "^,+" , "" ) + " ) ";

        LOG.debug ( "The SQL will be used to load data is '" + ddl + "'" );

        try
        {
            conn = databaseConnector.getConnection ();

            if ( ddlContainsSQL )
            {
                LOG.debug ( "The insert statement contains both values AND sql" );

                throw new Exception ( "Unlucky --- support for SQL statements in the spreadsheets hasn't been implemented yet" );
            }
            else
            {
                LOG.debug ( "The insert statement contains only values" );

                LOG.debug ( "Prepare the statement '" + pITokenReplacement.replaceTokensInString ( ddl ) + "'" );

                LOG.debug ( "Connection is null? '" + ( conn == null ) + "'" );

                pStmt = conn.prepareStatement ( pITokenReplacement.replaceTokensInString ( ddl ) );

                LOG.debug ( "The SQL '" + ddl + "' was successfully prepared" );

                for ( Row stRow : ST )
                {
                    LOG.debug ( "Loading excel row # '" + stRow.getRowNum () + "'" );

                    if ( stRow.getRowNum () >= 3 )
                    {
                        for ( int i = 0 ; i < SPREADSHEET_WIDTH ; i++ )
                        {
                            ExcelColumnDetails currColDtls = XLCOLDTLS.get ( new Integer ( i ) );

                            LOG.debug ( "Examining column '" + currColDtls.colName + "'" );

                            Cell currCell = stRow.getCell ( i );

                            LOG.debug ( "Examining cell '" + i + "' - value - '" + currCell + "'" );

                            if ( currCell == null || currCell.getCellType () == Cell.CELL_TYPE_BLANK )
                            {
                                LOG.debug ( "Cell '" + i + "' will be treated as being blank / null" );

                                if ( currColDtls.isDate )
                                {
                                    LOG.debug ( "Cell '" + i + "': binding null date to DDL" );

                                    pStmt.setNull ( currColDtls.colIndex + 1 , Types.DATE );
                                }
                                else if ( currColDtls.isTimestamp )
                                {
                                    LOG.debug ( "Cell '" + i + "': binding null timestamp to DDL" );

                                    pStmt.setNull ( currColDtls.colIndex + 1 , Types.TIMESTAMP );
                                }
                                else if ( currColDtls.isNumber )
                                {
                                    LOG.debug ( "Cell '" + i + "': binding null number to DDL" );

                                    pStmt.setNull ( currColDtls.colIndex + 1 , Types.DOUBLE );
                                }
                                else if ( currColDtls.isInteger )
                                {
                                    LOG.debug ( "Cell '" + i + "': binding null integer to DDL" );

                                    pStmt.setNull ( currColDtls.colIndex + 1 , Types.INTEGER );
                                }
                                else
                                {
                                    LOG.debug ( "Cell '" + i + "': binding null string to DDL" );

                                    pStmt.setNull ( currColDtls.colIndex + 1 , Types.VARCHAR );
                                }
                            }
                            else
                            {
                                if ( currColDtls.isDate )
                                {
                                    LOG.debug ( "Cell '" + i + "': binding date to DDL" );

                                    pStmt.setDate ( currColDtls.colIndex + 1 , new java.sql.Date ( currCell.getDateCellValue ().getTime () ) );
                                }
                                else if ( currColDtls.isTimestamp )
                                {
                                    LOG.debug ( "Cell '" + i + "': binding timestamp to DDL" );

                                    pStmt.setTimestamp ( currColDtls.colIndex + 1 , new java.sql.Timestamp ( currCell.getDateCellValue ().getTime () ) );
                                }
                                else if ( currColDtls.isNumber )
                                {
                                    LOG.debug ( "Cell '" + i + "': binding number to DDL" );

                                    pStmt.setDouble ( currColDtls.colIndex + 1 , currCell.getNumericCellValue () );
                                }
                                else if ( currColDtls.isInteger )
                                {
                                    LOG.debug ( "Cell '" + i + "': binding integer to DDL" );

                                    pStmt.setInt ( currColDtls.colIndex + 1 , ( int ) ( currCell.getNumericCellValue () ) );
                                }
                                else
                                {
                                    if ( currCell.getCellType () == Cell.CELL_TYPE_NUMERIC )
                                    {
                                        LOG.debug ( "Cell '" + i + "': binding number stored as a string to DDL" );

                                        pStmt.setString ( currColDtls.colIndex + 1 , String.valueOf ( currCell.getNumericCellValue () ) );
                                    }
                                    else
                                    {
                                        LOG.debug ( "Cell '" + i + "': binding string to DDL" );

                                        pStmt.setString ( currColDtls.colIndex + 1 , currCell.getStringCellValue () );
                                    }
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
            LOG.debug ( "Closing 'pStmt'" );

            pStmt.close ();

            LOG.debug ( "Closed 'pStmt'" );

            LOG.debug ( "Closing 'conn'" );

            conn.close ();

            LOG.debug ( "Closed 'conn'" );

            LOG.debug ( "Closing 'XL'" );
         
            LOG.debug ( "Closed 'XL'" );
        }

        LOG.debug ( "'" + numRecordsToInsert + "' records were successfully loaded into the database table '" + pTableOwner + "." + pExcelTabName + "'" );
    }
}