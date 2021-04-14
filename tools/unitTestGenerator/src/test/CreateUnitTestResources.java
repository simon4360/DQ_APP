package test;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Scanner;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.text.StrSubstitutor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class CreateUnitTestResources {
	static final String tableDescSql = "select COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION from user_tab_cols where table_name = ?";

	static final String tableDescSqlWithSynonym = " SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE FROM all_tab_cols" + " WHERE table_name IN (SELECT UPPER (?) table_name FROM DUAL" + "                      UNION ALL" + "                      SELECT table_name FROM user_synonyms WHERE synonym_name = UPPER (?))"
			+ " group by COLUMN_NAME, DATA_TYPE, DATA_LENGTH, DATA_PRECISION, DATA_SCALE, table_name, COLUMN_ID " + " having table_name = max(table_name)" + " order by COLUMN_ID ";

	public static void main(String[] args) throws Exception {
		// Put the data in the functional name folder if we have that variable

		createComparisons();

		createUnitTest();

		// Currently not implemented
		createUnitTestData();

		// Currently not implemented
		runMicroflows();

		System.out.println("Creating Input data excels.");
		createExcelTables("data_input", "sourceTableName", false);

		System.out.println("Creating Expected results data excels.");
		createExcelTables("data_expected_results", "targetTableName", true);

		System.out.println("Cleaning up");
		cleanUp();

		System.out.println("Done");
	}

	private static void createUnitTest() throws Exception {
		Map<String, String> valuesMap = new HashMap<String, String>();

		// Copy the file to the output folder with new name
		UnitTestResourceGeneratorResources res = UnitTestResourceGeneratorResources.getInstance();
		String className = "test" + res.getTestProps().getProperty("projectName") + res.getTestProps().getProperty("functionalName");
		String destinationDir = "output/" + res.getTestProps().getProperty("functionalName");
		File destFile = new File(destinationDir + "/" + className + ".java");
		System.out.println(destFile);
		FileUtils.copyFile(new File("resources/templateTestClass.java"), destFile);
		valuesMap.put("className", className);

		// Copy the config for posterity
		FileUtils.copyFile(new File("resources/unittest.properties"), new File(destinationDir + "/unittest.properties"));

		// TestPrefix
		String TestPrefix = "";
		String projectName = res.getTestProps().getProperty("projectName");
		System.out.println(projectName);
		if (projectName.contains("tgt")) {
			TestPrefix = "T" + projectName.substring(projectName.length() - 3, projectName.length());
		} else if (projectName.contains("src")) {
			TestPrefix = "S" + projectName.substring(projectName.length() - 3, projectName.length());
		} else {
			TestPrefix = "CORE";
		}
		valuesMap.put("TestPrefix", TestPrefix);

		// Do replacements
		// Aptitude Projects
		String[] splitString = res.getTestProps().getProperty("workflowNames").split(",");

		String tempString = "";
		for (int i = 0; i < splitString.length; i++) {
			// new AptitudeProjectWorkflow(packageName, "statis_pf_wrapper"),
			tempString += "new AptitudeProjectWorkflow(packageName, \"" + splitString[i] + "\"),";
		}
		tempString = tempString.substring(0, tempString.length() - 1);

		valuesMap.put("l_aptitudeProjectsToRun", tempString);

		// Table Name replacements
		// TablenameConstants.T_STATIS_PF_CMPSTN,

		splitString = res.getTestProps().getProperty("sourceTableName").split(",");
		tempString = "";
		for (int i = 0; i < splitString.length; i++) {
			if (splitString[i].length() == 0)
				break;
			tempString += "TablenameConstants." + splitString[i] + ",";
		}
		if (tempString.length() > 0)
			tempString = tempString.substring(0, tempString.length() - 1);
		valuesMap.put("l_sourceTableName", tempString);

		splitString = res.getTestProps().getProperty("targetTableName").split(",");
		tempString = "";
		for (int i = 0; i < splitString.length; i++) {
			if (splitString[i].length() == 0)
				break;
			tempString += "TablenameConstants." + splitString[i] + ",";
		}
		if (tempString.length() > 0)
			tempString = tempString.substring(0, tempString.length() - 1);
		valuesMap.put("l_targetTableName", tempString);

		splitString = res.getTestProps().getProperty("intermediateDataTables").split(",");
		tempString = "";
		for (int i = 0; i < splitString.length; i++) {
			if (splitString[i].length() == 0)
				break;
			tempString += "TablenameConstants." + splitString[i] + ",";
		}
		if (tempString.length() > 0)
			tempString = tempString.substring(0, tempString.length() - 1);
		valuesMap.put("l_intermediateDataTables", tempString);

		splitString = res.getTestProps().getProperty("resourceDataTables").split(",");
		tempString = "";
		for (int i = 0; i < splitString.length; i++) {
			if (splitString[i].length() == 0)
				break;
			tempString += "TablenameConstants." + splitString[i] + ",";
		}
		if (tempString.length() > 0)
			tempString = tempString.substring(0, tempString.length() - 1);
		valuesMap.put("l_resourceDataTables", tempString);

		String content;

		content = new String(Files.readAllBytes(destFile.toPath()));
		String replace = StrSubstitutor.replace(content, valuesMap);
		replace = StrSubstitutor.replace(replace, res.getTestProps());
		Files.write(destFile.toPath(), replace.getBytes());

		// All the simple things

	}

	private static void createUnitTestData() throws Exception {

	}

	private static void runMicroflows() throws Exception {

	}

	private static void createComparisons() throws Exception {
		UnitTestResourceGeneratorResources res = UnitTestResourceGeneratorResources.getInstance();
		Properties testprops = res.getTestProps();
		File output = res.getOutput();
		String targetTableName = testprops.getProperty("targetTableName").toUpperCase();
		targetTableName = targetTableName.trim();

		List<String> targetTables = null;

		if (targetTableName != null && targetTableName.length() > 0) {
			targetTables = Arrays.asList(targetTableName.split(","));
		}

		String ignoreColumnsRaw = testprops.getProperty("ignoreColumns");
		ignoreColumnsRaw = ignoreColumnsRaw.trim().toUpperCase();

		List<String> variableColumns = null;

		if (ignoreColumnsRaw != null && ignoreColumnsRaw.length() > 0) {
			variableColumns = Arrays.asList(ignoreColumnsRaw.split(","));
		}

		System.out.println("Creating SQL comparisons");
		String defaultExpectedFileName = "expected";
		String defaultActualFileName = "actual";

		File expected_results = null;
		File actual_results = null;

		for (String table : targetTables) {
			table = table.toUpperCase();
			System.out.println("Creating comparison sql for: " + table);

			expected_results = new File(output + "/" + table + "_" + defaultExpectedFileName + ".sql");
			actual_results = new File(output + "/" + table + "_" + defaultActualFileName + ".sql");

			actual_results.createNewFile();
			expected_results.createNewFile();

			PreparedStatement pstmt = res.getConn().prepareStatement(tableDescSqlWithSynonym, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			pstmt.setString(1, table);
			pstmt.setString(2, table);

			ResultSet rs = pstmt.executeQuery();
			String returnString = getSelectFromResultSet(res, rs, variableColumns);
			rs.close();
			String select = returnString;

			String selectEr = select;
			select += "\n FROM " + table;
			selectEr += "\n FROM ER_" + table;

			BufferedWriter writer = new BufferedWriter(new FileWriter(actual_results));
			writer.write("(" + select + ")");
			writer.close();

			writer = new BufferedWriter(new FileWriter(expected_results));
			writer.write("(" + selectEr + ")");
			writer.close();
		}
	}

	private static void createExcelTables(String defaultFileName, String tablesProp, Boolean expectedResultTable) throws Exception {
		UnitTestResourceGeneratorResources res = UnitTestResourceGeneratorResources.getInstance();
		String tablesPropRaw = res.getTestProps().getProperty(tablesProp);
		File output = res.getOutput();
		tablesPropRaw = tablesPropRaw.trim().toUpperCase();
		List<String> intputTables = null;

		if (tablesPropRaw != null && tablesPropRaw.length() > 0) {
			intputTables = Arrays.asList(tablesPropRaw.split(","));
		}

		File outputFile = null;
		outputFile = new File(output + "/" + defaultFileName + ".xlsx");
		outputFile.createNewFile();

		Workbook wb;
		wb = new XSSFWorkbook();

		for (String table : intputTables) {

			System.out.println("Creating data excel for:" + table);
			createExcelFromDatabase(res, outputFile, wb, table, expectedResultTable, tablesProp);

		}

		FileOutputStream out = new FileOutputStream(outputFile);
		wb.write(out);
		out.close();
		wb.close();
	}

	private static String getSelectFromResultSet(UnitTestResourceGeneratorResources res, ResultSet rs) throws SQLException {
		return getSelectFromResultSet(res, rs, null);
	}

	private static String getSelectFromResultSet(UnitTestResourceGeneratorResources res, ResultSet rs, List<String> variableColumns) throws SQLException {
		rs.beforeFirst();
		String select = "select \n";
		select += " 1 ONE \n";

		HashMap<String, String> tempMap = res.getDefaultedColumns();

		while (rs.next()) {
			String columnName = rs.getString(1);
			// Comment out standard columns that we don't like
			if (variableColumns != null && variableColumns.size() > 0 && variableColumns.contains(columnName)) {
				select += " --," + columnName + "\n";
				// Next we default values for stupid things we always forget,
				// like event_status to 0
			} else if (variableColumns == null && tempMap.containsKey(columnName)) {
				select += " ," + tempMap.get(columnName) + "\n";
				System.out.println("Defaulting:" + columnName + " to " + tempMap.get(columnName));
			} else {
				select += " ," + columnName + "\n";
			}
		}
		select = select.substring(0, select.length() - 1);
		return select;
	}

	private static void createExcelFromDatabase(UnitTestResourceGeneratorResources res, File outputFile, Workbook wb, String tableName, Boolean expectedResultTable, String tablesProp) throws SQLException, FileNotFoundException, IOException {

		Connection conn = res.getConn();
		PreparedStatement pstmt;
		ResultSet rs;

		String sheetName = tableName;
		if (expectedResultTable) {
			sheetName = "er_" + tableName;
			if (sheetName.length() > 30) {
				sheetName = sheetName.substring(0, 30);
			}
		}
		Sheet sheet = wb.createSheet((sheetName).toLowerCase());
		pstmt = conn.prepareStatement(tableDescSqlWithSynonym, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
		// System.out.println(tableDescSqlWithSynonym);
		pstmt.setString(1, tableName);
		pstmt.setString(2, tableName);
		rs = pstmt.executeQuery();

		Row firstRow = sheet.createRow(0);
		Row secondRow = sheet.createRow(1);
		Row thirdRow = sheet.createRow(2);
		Cell cell;
		int i = 0;
		while (rs.next()) {
			String outputRow2 = "";
			cell = firstRow.createCell(i);
			cell.setCellValue(rs.getString(1));
			cell = secondRow.createCell(i);
			String dataType = rs.getString(2);
			String dataLength = rs.getString(3);
			String dataPrecision = rs.getString(4);
			String dataScale = rs.getString(5);

			if (dataType.equals("NUMBER")) {
				// Workaround for Oracle giving us lies about number precision.
				if (dataPrecision == null || dataPrecision.length() == 0) {
					outputRow2 = (dataType);
				} else {
					outputRow2 = (dataType + "(" + dataPrecision + "," + dataScale + ")");
				}

				cell.setCellValue(outputRow2);
			} else if (dataType.equals("DATE")) {
				outputRow2 = (dataType);
				cell.setCellValue(outputRow2);
			} else if (dataType.equals("BLOB")) {
				outputRow2 = (dataType);
				cell.setCellValue(outputRow2);
			} else {
				outputRow2 = (dataType + "(" + dataLength + ")");
				cell.setCellValue(outputRow2);
			}
			cell = thirdRow.createCell(i);
			cell.setCellValue("N");
			i++;
		}

		String defaultNumberOfRows = "10";

		String numberOfRowsTypeVar = "";

		if (tablesProp.equals("sourceTableName")) {
			numberOfRowsTypeVar = "sourceNumberOfRows";
		} else if (tablesProp.equals("targetTableName")) {
			numberOfRowsTypeVar = "targetNumberOfRows";
		}

		String configSetOfRows = res.getTestProps().getProperty(numberOfRowsTypeVar).toUpperCase();
		String numberOfRows = defaultNumberOfRows;
		if (configSetOfRows != null && configSetOfRows.length() > 0) {
			numberOfRows = configSetOfRows;
		}

		// System.out.println("tablesProp:" + tablesProp + "
		// numberOfRowsTypeVar:" + numberOfRowsTypeVar + " :configSetOfRows" +
		// configSetOfRows);

		String sql = getSelectFromResultSet(res, rs);
		sql += "\n FROM " + tableName + " WHERE 1=1 ";
		if (Integer.parseInt(numberOfRows) >= 0) {
			sql += " AND ROWNUM <=" + numberOfRows;
		}

		// System.out.println(sql);
		pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
		rs = pstmt.executeQuery();

		CellStyle cellStyleDate = wb.createCellStyle();
		CellStyle cellStyleNumber = wb.createCellStyle();
		CreationHelper createHelper = wb.getCreationHelper();
		cellStyleDate.setDataFormat(createHelper.createDataFormat().getFormat("dd/mm/yyyyy"));
		cellStyleNumber.setDataFormat(createHelper.createDataFormat().getFormat("#"));

		Cell currentCell;
		Row currentRow;
		ResultSetMetaData rsm = rs.getMetaData();
		int rownumber = 3;
		while (rs.next()) {
			/*
			 * rs.getMetaData().getColumnType(j) 2 = Number 12 = String 93 =
			 * Date 2004 = BLOB
			 */
			currentRow = sheet.createRow(rownumber);
			for (int j = 1; j < rsm.getColumnCount(); j++) {
				int excelCell = j - 1;
				int columnIndex = j + 1;
				currentCell = currentRow.createCell(excelCell);
				if (rsm.getColumnType(columnIndex) == 2 && (rs.getString(columnIndex) != null && rs.getString(columnIndex).length() != 0)) {
					currentCell.setCellValue(rs.getDouble(columnIndex));
				} else if (rsm.getColumnType(columnIndex) == 93 && (rs.getString(columnIndex) != null && rs.getString(columnIndex).length() != 0)) {
					currentCell.setCellValue(rs.getDate(columnIndex));
					currentCell.setCellStyle(cellStyleDate);
				} else if (rsm.getColumnType(columnIndex) == 2004) {
					Blob ablob = rs.getBlob(columnIndex);
					if (ablob != null && ablob.length() != 0) {
						String tmpString = new String(ablob.getBytes(1l, (int) ablob.length()));
						currentCell.setCellValue(tmpString);
					}
				} else if ((rs.getString(columnIndex) != null && rs.getString(columnIndex).length() != 0)) {
					currentCell.setCellValue(rs.getString(columnIndex));
				}
			}
			rownumber++;
		}
		rs.close();

	}

	private static void cleanUp() throws Exception {
		UnitTestResourceGeneratorResources res = UnitTestResourceGeneratorResources.getInstance();
		res.close();
		Scanner sc = new Scanner(System.in);
		System.out.println("We're done, press enter to quit");
		sc.nextLine();
		sc.close();
	}

}
