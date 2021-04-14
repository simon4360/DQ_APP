package test;

import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.util.HashMap;
import java.util.LinkedList;

public class UnitTestResourceGeneratorResources {

	private static UnitTestResourceGeneratorResources instance = null;
	private static Connection conn = null;
	private Properties testProps = null;
	private File output = null;
	private HashMap<String, String> defaultedColumns = new HashMap<String, String>();



	static File testproperties = new File("resources/unittest.properties");

	public void close() throws Exception {
		conn.close();
	}

	protected UnitTestResourceGeneratorResources() throws Exception {
		testProps = new Properties();
		testProps.load(new FileInputStream(testproperties));

//		String outputPath = testProps.getProperty("targetFolderName");
		String outputPath = testProps.getProperty("functionalName");		
		
		output = new File("output/" + outputPath);
		output.mkdir();
		System.out.println("Output path:" + output.getAbsolutePath());

		setConnection(testProps);
		setDefaultedColumns(testProps);

	}

	private void setDefaultedColumns(Properties testProps) {
		String tempString = "";
		String[] parts = null;
		for (int i = 0; i < 10; i++) {
			tempString = testProps.getProperty("columnToDefault" + i);
			if (tempString != null && tempString.length() > 0 && tempString.contains(",")) {
				// System.out.println(tempString);
				parts = tempString.split(",");
				defaultedColumns.put(parts[0].toUpperCase(), parts[1]);
			}
		}
	}
	
	public HashMap<String, String> getDefaultedColumns() {
		return defaultedColumns;
	}

	public static UnitTestResourceGeneratorResources getInstance() throws Exception {
		if (instance == null) {
			instance = new UnitTestResourceGeneratorResources();
		}
		return instance;
	}

	private static void setConnection(Properties testProps) throws Exception, ClassNotFoundException, SQLException {
		String encPassword = testProps.getProperty("databasePassword").substring(10);
		String oracleJdbcUrl = testProps.getProperty("oracleJdbcUrl");
		String masterPassword = testProps.getProperty("databaseMasterPW");
		TwoWayEncryption enc = new TwoWayEncryption(masterPassword);
		String password = enc.decryptString(encPassword);
		String userName = testProps.getProperty("databaseUsername");
		String DRIVER_CLASS = testProps.getProperty("databaseDriverClass");

		System.out.println("Connected to: " + DRIVER_CLASS + " : " + oracleJdbcUrl + " : " + userName + "/" + password);

		Class.forName(DRIVER_CLASS);
		conn = DriverManager.getConnection(oracleJdbcUrl, userName, password);
		conn.setAutoCommit(false);
	}

	public Connection getConn() {
		return conn;
	}

	public Properties getTestProps() {
		return testProps;
	}

	public File getOutput() {
		return output;
	}

}
