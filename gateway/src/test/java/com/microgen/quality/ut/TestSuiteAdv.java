package com.microgen.quality.ut;

import com.microgen.quality.tlf.database.IDatabaseConnector;
import com.microgen.quality.tlf.database.OracleDatabaseConnector;
import com.microgen.quality.ut.CommonTestOperations;
import com.microgen.quality.ut.DatabaseConnectorFactory;
import com.microgen.quality.ut.Execution;
import com.microgen.quality.ut.TablenameConstants;
import org.testng.Assert;

import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;

public abstract class TestSuiteAdv {

    public enum TestSuiteType {
        ONE_TO_ONE_EQUAL_RECS_SAME_VALUES, ONE_TO_MANY_RECS_SAME_VALUES, DERIVATION_EQUAL_RECS_SAME_VALUES, DERIVATION_MANY_RECS_SAME_VALUES, DERIVATION_EXPECT_EMPTY_TARGET;
    }

    protected String schemaOwner = "G77_CFG";
    protected TablenameConstants sourceTable;
    protected TablenameConstants targetTable;
    protected String aptitudeProject;
    protected String microFlow;
    protected int linesNum = 1;
    protected TestSuiteType testSuiteType = TestSuiteType.ONE_TO_ONE_EQUAL_RECS_SAME_VALUES;
    protected String keyColumn = "SOURCE_SYSTEM_ID";
    protected String bucketColumn = "SESSION_ID";
    protected String bucketValue = "UnitTest";
    protected boolean validateColumnOrder = false;

    private Map<String, String> overrideValueMap = new HashMap<>();
    private Map<String, String> columnMap = new HashMap<>();
    private Map<String, String> expectedValueMap = new HashMap<>();
    private List<String> ignoreColumn = new ArrayList<>();
    private List<String> ignoreValue = new ArrayList<>();
    private List<Metadata> source;
    private List<Metadata> target;

    private static final IDatabaseConnector DB_G77_CFG_CONN_OPS = DatabaseConnectorFactory.getDatabaseConnectorG77_CFG();
    //private IDatabaseConnector DB_G77_CFG_CONN_OPS = null;
    private Connection conn = null;
    private PreparedStatement pStmt = null;
    private static final String GET_METADATA_SQL = "with metadata AS\n" +
            " (select data_type,\n" +
            "         data_length,\n" +
            "         case when rpad('9', data_precision, '9') / power(10, data_scale) > 999999999 then 999999999 else rpad('9', data_precision, '9') / power(10, data_scale) end maxval,\n" +
            "         column_id,\n" +
            "         column_name,\n" +
            "         nullable,\n" +
            "         identity_column\n" +
            "    from all_tab_columns\n" +
            "   where owner = upper(:p_owner)\n" +
            "     and table_name = upper(:p_table_name)\n" +
            "   order by column_id),\n" +
            "expressions as\n" +
            " (select column_name,\n" +
            "         column_id,\n" +
            "         data_type,\n" +
            "         nullable,\n" +
            "         identity_column,\n" +
            "         case\n" +
            "           when (data_type in ('NUMBER', 'FLOAT')) then\n" +
            "            'round(dbms_random.value(1,' || nvl(maxval, 10000) || '),4)'\n" +
            "           when (data_type = 'DATE') then\n" +
            "            'sysdate+dbms_random.value+dbms_random.value(1,1000)'\n" +
            "           else\n" +
            "            'dbms_random.string(''A'',' || data_length || ')'\n" +
            "         end expression  \n" +
            "    from metadata d)\n" +
            "select column_name, data_type, expression, column_id, nullable, identity_column from expressions order by column_id";

    private static final String GET_DATA_SET_SQL = "SELECT * FROM <owner.tableName> WHERE 1=1";

    /**
     * Apply custom source value for all dummy rows in source table
     *
     * @param columnName DB column name
     * @param value      DB value
     */
    public void overrideValue(String columnName, String value) {
        overrideValueMap.put(columnName, value);
    }

    /**
     * Map the source column with the target table
     * in case different column names
     *
     * @param columnSource DB source column name
     * @param columnTarget DB target column name
     */
    public void mapColumns(String columnSource, String columnTarget) {
        columnMap.put(columnSource, columnTarget);
    }

    /**
     * Map the source column with the target table
     * in case in columns have the same names
     *
     * @param column DB column name
     */
    public void mapColumns(String column) {
        mapColumns(column, column);
    }

    /**
     * Expected value for column in target table
     *
     * @param targetColumn DB target column name
     * @param value        DB value
     */
    public void expectedValue(String targetColumn, String value) {
        expectedValueMap.put(targetColumn, value);
    }

    /**
     * To skip column in comparison of result data sets
     * Available in OneToOne test suite
     *
     * @param columnName DB column name
     */
    public void ignoreColumn(String columnName) {
        ignoreColumn.add(columnName);
    }

    /**
     * To skip value in comparison of result data sets, however,
     * the value has to be populated with value
     * Available in OneToOne test suite
     *
     * @param columnName DB column name
     */
    public void ignoreValue(String columnName) {
        ignoreValue.add(columnName);
    }

    /**
     * Insert dummy data into source table
     */
    public void generateDummyData() {
        if (sourceTable == null)
            throw new AssertionError("The validation of variables is not passed for sourceTable!");

        String insertLine = null;
        try {
            setUpConnection();
            cleanUp();

            if (source == null) {
                source = getMetadata(sourceTable);
                applyCustomLayer(source);
            }

            insertLine = getInsertLine(source, linesNum);
            executeDML(insertLine);
        } catch (Exception e) {
            System.out.println(insertLine);
            e.printStackTrace();
        }
    }

    /**
     * Execute processes:
     * getting source/tables table metadata
     * generating dummy data and insert in source table
     * executing aptitude microFlow
     * getting result sets for source and target
     * comparison of result data sets
     */
    public void run() {
        try {
            if (isValidationOfVariablesPassed()) {
                try {
                    setUpConnection();

                    source = getMetadata(sourceTable);
                    target = getMetadata(targetTable);

                    applyCustomLayer(source);
                    applyCustomLayer(target);

                    if (isCompareMetadataPassed(source, target)) {

                        generateDummyData();

                        callAptitudeMicroFlow();

                        Map<Integer, Map<String, String>> sourceDataSet = getDataSet(sourceTable);
                        Map<Integer, Map<String, String>> targetDataSet = getDataSet(targetTable);

                        compareDataSets(sourceDataSet, targetDataSet);
                    } else {
                        throw new AssertionError("The comparison of source and target metadata is failed! See log above...");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                throw new AssertionError("The validation of variables is not passed (sourceTable, targetTable, aptitudeProject, microFlow, sourceTable, targetTable, testSuiteType)!");
            }
        } finally {
            resetVariables();
        }
    }

    public void resetVariables() {
        sourceTable = null;
        targetTable = null;
        microFlow = null;
        aptitudeProject = null;
        testSuiteType = TestSuiteType.ONE_TO_ONE_EQUAL_RECS_SAME_VALUES;
        keyColumn = "SOURCE_SYSTEM_ID";
        bucketColumn = "SESSION_ID";
        bucketValue = "UnitTest";
        linesNum = 1;
        overrideValueMap = new HashMap<>();
        columnMap = new HashMap<>();
        expectedValueMap = new HashMap<>();
        ignoreColumn = new ArrayList<>();
        ignoreValue = new ArrayList<>();
        source = null;
        target = null;
        validateColumnOrder = false;
    }

    private boolean isValidationOfVariablesPassed() {
        return (sourceTable != null && targetTable != null && aptitudeProject != null && microFlow != null && testSuiteType != null);
    }

    private void setUpConnection() throws Exception {
        if (conn == null) {
            conn = DB_G77_CFG_CONN_OPS.getConnection();
        }
    }


    public void cleanUp() throws Exception {
        String whereClause = null;
        if (bucketColumn != null && bucketValue != null) {
            whereClause = bucketColumn + " = '" + bucketValue + "'";
        }
        smartDeleteData(sourceTable, whereClause);

        if (targetTable != null) {
            smartDeleteData(targetTable, whereClause);
        }
    }

    private void smartDeleteData(TablenameConstants pTableName, String whereClause) throws Exception {
        String deleteStm = "DELETE FROM " + schemaOwner + "." + pTableName.getTableName();
        if (whereClause != null) {
            deleteStm = deleteStm + " WHERE " + whereClause;
        }
        executeDML(deleteStm);
    }

    private void executeDML(String dml) throws Exception {
        try {
            conn = DB_G77_CFG_CONN_OPS.getConnection();
            pStmt = conn.prepareStatement(dml);
            pStmt.executeUpdate();
            conn.commit();
        } finally {
            pStmt.close();
            conn.close();
        }
    }

    private ResultSet executeSQL(String sql, String[] params) throws Exception {
        ResultSet rs;
        conn = DB_G77_CFG_CONN_OPS.getConnection();
        pStmt = conn.prepareStatement(sql);
        if (params != null) {
            for (int i = 0; i < params.length; i++) {
                pStmt.setString(i + 1, params[i]);
            }
        }
        rs = pStmt.executeQuery();
        return rs;
    }

    private ResultSet executeSQL(String sql) throws Exception {
        return executeSQL(sql, null);
    }

    private List<Metadata> getMetadata(TablenameConstants table) throws Exception {
        try {
            String[] params = {schemaOwner, table.getTableName()};
            ResultSet rs = executeSQL(GET_METADATA_SQL, params);
            List<Metadata> columns = new LinkedList<>();
            while (rs.next()) {
                String column = rs.getString("column_name");
                String data_type = rs.getString("data_type");
                String expression = rs.getString("expression");
                String columnId = rs.getString("column_id");
                String nullable = rs.getString("nullable");
                String identityColumn = rs.getString("identity_column");
                columns.add(new Metadata(column, data_type, expression, columnId, nullable, identityColumn));
            }
            return columns;

        } finally {
            pStmt.close();
            conn.close();
        }
    }

    private Map<Integer, Map<String, String>> getDataSet(TablenameConstants table) throws Exception {
        Map<Integer, Map<String, String>> dataSet = new LinkedHashMap<>();
        List<String> columns = new LinkedList<>();

        try {
            String sql = GET_DATA_SET_SQL
                    .replace("<owner.tableName>", schemaOwner + "." + table.getTableName().toUpperCase());
            if (bucketColumn != null && bucketValue != null) {
                sql = sql.replace("1=1", bucketColumn + " = '" + bucketValue + "'");
            }

            ResultSet rs = executeSQL(sql);

            ResultSetMetaData md = rs.getMetaData();
            int colCount = md.getColumnCount();

            for (int i = 1; i <= colCount; i++) {
                columns.add(md.getColumnName(i));
            }

            int rowId = 0;
            while (rs.next()) {
                Map<String, String> row = new LinkedHashMap<>();
                columns.forEach(c -> {
                    try {
                        Object v = rs.getObject(c);
                        row.put(c, v == null ? "NULL" : v.toString());
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                });
                dataSet.put(rowId, row);
                rowId++;
            }

            return dataSet;
        } finally {
            pStmt.close();
            conn.close();
        }
    }

    private boolean isColumnThere(List<Metadata> metadata, String columnName) {
        return metadata.stream().anyMatch(m -> m.getColumn().equalsIgnoreCase(columnName));
    }

    private Metadata getColumnMetadata(List<Metadata> metadata, String columnName) {
        return metadata.stream().filter(m -> m.getColumn().equalsIgnoreCase(columnName)).findFirst().orElse(null);
    }

    private String getInsertLine(List<Metadata> metadata, int linesNum) {

        String listOfColumns = metadata.stream().filter(m -> !m.isIgnore()).map(Metadata::getColumn).collect(Collectors.joining(","));
        String listOfValues = metadata.stream().filter(m -> !m.isIgnore()).map(Metadata::getExpression).collect(Collectors.joining(","));

        return "INSERT INTO " +
                schemaOwner +
                "." +
                sourceTable.getTableName().toUpperCase() +
                " ( " +
                listOfColumns +
                " ) SELECT " +
                listOfValues +
                " FROM all_objects WHERE rownum <= " + linesNum;
    }

    private void applyCustomLayer(final List<Metadata> metadata) {
        if (bucketColumn != null && isColumnThere(source, bucketColumn)) {
            overrideValue(bucketColumn, bucketValue);
        }

        setUpIgnoreFlagForDerivationNotUsedAttributes(metadata);

        overrideValueMap.forEach((key, value) -> metadata.stream().filter(m -> m.getColumn().equalsIgnoreCase(key)).forEach(m -> {
            if (value == null) {
                m.setExpression("NULL");
            } else {
                String val = value;
                if (m.getDataType().equals("VARCHAR2") || m.getDataType().equals("CHAR") || m.getDataType().equals("LONG") || m.getDataType().equals("CLOB")) {
                    val = "'" + val + "'";
                }
                m.setExpression(val);
            }
        }));

        Metadata columnMetadata = getColumnMetadata(metadata, keyColumn);

        if (columnMetadata != null && !columnMetadata.getDataType().equals("DATE")) {
            columnMetadata.setExpression("rownum");
        } else {
            throw new AssertionError("Cannot identify the key attribute in the table for comparison '" + keyColumn + "'!");
        }

        Metadata identity = metadata.stream().filter(m -> m.getIdentityColumn().equals("YES")).findFirst().orElse(null);
        if (identity != null && !overrideValueMap.containsKey(identity.getColumn())) {
            ignoreColumn(identity.getColumn());
        }

        ignoreColumn.forEach(c -> metadata.stream().filter(m -> m.getColumn().equalsIgnoreCase(c)).filter(m -> m.getNullable().equals("Y")).forEach(m -> m.setIgnore(true)));

        if (!testSuiteType.name().startsWith("DERIVATION")) {
            columnMap.forEach((k, v) -> {
                Metadata md = getColumnMetadata(metadata, v);
                if (md != null) {
                    md.setColumn(k);
                }
            });
        }
    }

    private void setUpIgnoreFlagForDerivationNotUsedAttributes(final List<Metadata> metadata) {
        if (testSuiteType.name().startsWith("DERIVATION"))
            metadata.forEach(m -> {
                if (!overrideValueMap.containsKey(m.getColumn()) && !columnMap.containsKey(m.getColumn()) && !keyColumn.equals(m.getColumn()) && !bucketColumn.equals(m.getColumn()))
                    ignoreColumn(m.getColumn());
            });
    }

    private boolean isCompareMetadataPassed(List<Metadata> source, List<Metadata> target) {

        if (!isColumnThere(source, bucketColumn)) {
            System.err.println("The bucket column '" + bucketColumn + "' doesn't exist in source table '" + sourceTable.getTableName().toUpperCase() + "'. Please set up another column for variable bucketColumn");
            return false;
        }
        String tBucketColumn = bucketColumn;
        if (columnMap.containsKey(bucketColumn)) {
            tBucketColumn = columnMap.get(bucketColumn);
        }
        if (!isColumnThere(target, tBucketColumn)) {
            System.err.println("The bucket column '" + bucketColumn + "' doesn't exist in target table '" + targetTable.getTableName().toUpperCase() + "'. Please set up another column for variable bucketColumn");
            return false;
        }

        boolean[] result = {true};

        overrideValueMap.entrySet().stream().filter(o -> !isColumnThere(source, o.getKey())).forEach(o -> {
            System.err.println("The override column '" + o.getKey() + "' doesn't exist in source table '" + sourceTable.getTableName().toUpperCase() + "'.");
            result[0] = false;
        });

        if (!result[0]) return false;

        expectedValueMap.entrySet().stream().filter(o -> !isColumnThere(target, o.getKey())).forEach(o -> {
            System.err.println("The expected column '" + o.getKey() + "' doesn't exist in target table '" + targetTable.getTableName().toUpperCase() + "'.");
            result[0] = false;
        });

        if (!result[0]) return false;

        columnMap.entrySet().stream().filter(o -> !isColumnThere(source, o.getKey())).forEach(o -> {
            System.err.println("The map column '" + o.getKey() + "' doesn't exist in source table '" + sourceTable.getTableName().toUpperCase() + "'.");
            result[0] = false;
        });

        if (!result[0]) return false;

        columnMap.entrySet().stream().filter(o -> !isColumnThere(target, o.getValue())).forEach(o -> {
            System.err.println("The map column '" + o.getValue() + "' doesn't exist in target table '" + targetTable.getTableName().toUpperCase() + "'.");
            result[0] = false;
        });

        if (!result[0]) return false;

        if (testSuiteType.equals(TestSuiteType.ONE_TO_ONE_EQUAL_RECS_SAME_VALUES)||testSuiteType.equals(TestSuiteType.ONE_TO_MANY_RECS_SAME_VALUES)) {
            return isCompareOneToOneMetadataPassed(source, target);
        }

        if (testSuiteType.equals(TestSuiteType.DERIVATION_EQUAL_RECS_SAME_VALUES) || testSuiteType.equals(TestSuiteType.DERIVATION_EXPECT_EMPTY_TARGET) ||testSuiteType.equals(TestSuiteType.DERIVATION_MANY_RECS_SAME_VALUES)) {
            return isCompareDerivationMetadataPassed(source, target);
        }

        throw new AssertionError("Unsupported test suite " + testSuiteType);
    }

    private boolean isCompareOneToOneMetadataPassed(List<Metadata> source, List<Metadata> target) {
        List<Metadata> cpInSource = compare(source, target, "source");
        List<Metadata> cpInTarget = compare(target, source, "target");
        if (!cpInSource.isEmpty()) {
            cpInSource.forEach(m -> System.err.println("The column '" + m.getColumn() + "' exists in source table '" + sourceTable.getTableName().toUpperCase() + "' but not in the target '" + targetTable.getTableName().toUpperCase() + "'!"));
        }
        if (!cpInTarget.isEmpty()) {
            cpInTarget.forEach(m -> System.err.println("The column '" + m.getColumn() + "' exists in target table '" + targetTable.getTableName().toUpperCase() + "' but not in the source '" + sourceTable.getTableName().toUpperCase() + "'!"));
        }
        return cpInSource.isEmpty() && cpInTarget.isEmpty();
    }

    private List<Metadata> compare(List<Metadata> l1, List<Metadata> l2, final String direction) {
        ArrayList<Metadata> cp = new ArrayList<>();
        l1.stream().filter(m -> !m.isIgnore()).filter(m -> !isColumnThere(l2, m.getColumn())).forEach(cp::add);

        l1.stream().filter(m -> !m.isIgnore()).filter(m -> isColumnThere(l2, m.getColumn())).filter(m -> !m.getDataType().equals(getColumnMetadata(l2, m.getColumn()).getDataType())).forEach(l -> {
            System.out.println("WARNING: The " + direction + " column '" + l.getColumn() + "' has different dataType '" + l.getDataType() + "'!");
        });
        return cp;
    }

    private boolean isCompareDerivationMetadataPassed(List<Metadata> source, List<Metadata> target) {
        boolean[] success = {true};
        columnMap.forEach((sCol, tCol) -> {
            Metadata sMetadata = getColumnMetadata(source, sCol);
            Metadata tMetadata = getColumnMetadata(target, tCol);

            if (sMetadata == null) {
                System.err.println("The column '" + sCol + "' is used in mapColumns but doesn't exist in source table '" + sourceTable.getTableName().toUpperCase() + "'");
                success[0] = false;
            }
            if (tMetadata == null) {
                System.err.println("The column '" + tCol + "' is used in mapColumns but doesn't exist in target table '" + targetTable.getTableName().toUpperCase() + "'");
                success[0] = false;
            }

            if (sMetadata != null && tMetadata != null && !sMetadata.getDataType().equals(tMetadata.getDataType()))
                System.out.println("WARNING: The datTypes are different in source '" + sourceTable.getTableName().toUpperCase() + "' and target '" + targetTable.getTableName().toUpperCase() + "'. The source column '" + sMetadata.getColumn() + "' :'" + sMetadata.getDataType() + "' vs the target column '" + sMetadata.getColumn() + "' :'" + sMetadata.getDataType() + "'!");
        });
        return success[0];
    }


    private void callAptitudeMicroFlow() {
        try {
            CommonTestOperations.aptitudeProjectCommand(aptitudeProject, "start");
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }

        Assert.assertTrue(Execution.runMF(aptitudeProject, microFlow, bucketValue, "dummy"), "The microFlow " + microFlow + " returned unsuccessful result!");
    }


    private Integer getIdByKeyColumn(final Map<String, String> sourceRow, Map<Integer, Map<String, String>> targetDataSet) {
        String sourceId = sourceRow.get(keyColumn);
        final String tKeyColumn;
        if (columnMap.containsKey(keyColumn)) {
            tKeyColumn = columnMap.get(keyColumn);
        } else {
            tKeyColumn = keyColumn;
        }
        return targetDataSet.entrySet().stream().filter(m -> m.getValue().get(tKeyColumn).equals(sourceId)).map(Map.Entry::getKey).findFirst().orElse(null);
    }

    //Compare dataSets
    private void compareDataSets(Map<Integer, Map<String, String>> sourceDataSet, Map<Integer, Map<String, String>> targetDataSet) {

        if (testSuiteType.name().contains("_EQUAL_RECS")) {

            if (sourceDataSet.size() != linesNum) {
                throw new AssertionError("[" + testSuiteType.name() + "] The source table '" + sourceTable.getTableName().toUpperCase() + "' contains [" + sourceDataSet.size() + "] actual rows when expected id [" + linesNum + "]");
            }
            if (targetDataSet.size() != linesNum) {
                throw new AssertionError("[" + testSuiteType.name() + "] The target table '" + targetTable.getTableName().toUpperCase() + "' contains [" + targetDataSet.size() + "] records. Expected number of rows is [" + linesNum + "]");
            }
            if (sourceDataSet.size() != targetDataSet.size()) {
                throw new AssertionError("[" + testSuiteType.name() + "] The target table '" + targetTable.getTableName().toUpperCase() + "' and the source table '" + sourceTable.getTableName().toUpperCase() + "' have different number of rows [" + targetDataSet.size() + "] vs [" + sourceDataSet.size() + "]");
            }
        }
        if (testSuiteType.name().contains("_MANY_RECS")) {

            if (sourceDataSet.size() != linesNum) {
                throw new AssertionError("[" + testSuiteType.name() + "] The source table '" + sourceTable.getTableName().toUpperCase() + "' contains [" + sourceDataSet.size() + "] actual rows when expected id [" + linesNum + "]");
            }
            if (targetDataSet.size() != linesNum) {
                System.out.println("WARNING: [" + testSuiteType.name() + "] The target table '" + targetTable.getTableName().toUpperCase() + "' contains [" + targetDataSet.size() + "] records. Source number of rows is [" + linesNum + "]");
            }
            if (sourceDataSet.size() > targetDataSet.size()) {
                throw new AssertionError("[" + testSuiteType.name() + "] The target table '" + targetTable.getTableName().toUpperCase() + "' and the source table '" + sourceTable.getTableName().toUpperCase() + "' have less number of rows [" + targetDataSet.size() + "] vs [" + sourceDataSet.size() + "]");
            }
        }

        boolean success = true;

        if (testSuiteType.equals(TestSuiteType.ONE_TO_ONE_EQUAL_RECS_SAME_VALUES)||testSuiteType.equals(TestSuiteType.ONE_TO_MANY_RECS_SAME_VALUES)) {
            success = compareOneToOneDataSets(sourceDataSet, targetDataSet);
        } else if (testSuiteType.equals(TestSuiteType.DERIVATION_EQUAL_RECS_SAME_VALUES)||testSuiteType.equals(TestSuiteType.DERIVATION_MANY_RECS_SAME_VALUES)) {
            success = compareDerivationDataSets(sourceDataSet, targetDataSet);
        } else if (testSuiteType.equals(TestSuiteType.DERIVATION_EXPECT_EMPTY_TARGET)) {
            success = compareDerivationEmptyDataSets(targetDataSet);
        } else {
            throw new AssertionError("Unsupported test suite " + testSuiteType);
        }

        if (!success) {
            System.out.println("MapColumns:");
            columnMap.forEach((s, t) -> System.out.println(sourceTable.getTableName().toUpperCase() + "." + s + " to " + targetTable.getTableName().toUpperCase() + "." + t));
            System.out.println("OverrideValue:");
            overrideValueMap.forEach((col, val) -> System.out.println(sourceTable.getTableName().toUpperCase() + "." + col + "=" + val));
            System.out.println("ExpectedValue:");
            expectedValueMap.forEach((col, val) -> System.out.println(targetTable.getTableName().toUpperCase() + "." + col + "=" + val));
        }

        Assert.assertTrue(success, "The comparison of source and target data sets is failed! See log above...");
    }

    private boolean compareOneToOneDataSets(Map<Integer, Map<String, String>> sourceDataSet, Map<Integer, Map<String, String>> targetDataSet) {
        boolean[] success = {true};
        sourceDataSet.forEach((sRowID, sRowColVal) -> {
            Integer targetId = getIdByKeyColumn(sRowColVal, targetDataSet);

            if (targetId != null) {

                expectedValueMap.forEach((col, val) -> {
                    sourceDataSet.forEach((sRowId, sRowColValMap) -> {
                        String value = val;
                        if (val == null)
                            value = "NULL";

                        sRowColVal.put(col, value);
                    });
                });

                if (!compareRows(sRowColVal, targetDataSet.get(targetId))) {
                    success[0] = false;
                }
            } else {
                System.err.println("[" + keyColumn + "='" + sRowColVal.get(keyColumn) + "'] The source row is not found in '" + targetTable.getTableName().toUpperCase() + "' table");
                success[0] = false;
            }
        });
        return success[0];
    }

    private boolean compareRows(final Map<String, String> sourceRow, final Map<String, String> targetRow) {
        final boolean[] success = {true};

        columnMap.forEach((k, v) -> {
            if (targetRow.containsKey(v)) {
                targetRow.put(k, targetRow.get(v));
            }
        });

        sourceRow.entrySet().stream().filter(s -> !ignoreColumn.contains(s.getKey())).forEach(s -> {

            if (targetRow.containsKey(s.getKey())) {

                if (!s.getValue().equals(targetRow.get(s.getKey()))) {
                    String message = "[" + keyColumn + "=" + targetRow.get(keyColumn) + "] The target column '" + sourceTable.getTableName().toUpperCase() + "." + s.getKey() + "' has actual value [" + targetRow.get(s.getKey()) + "] but expected value is [" + s.getValue() + "].";
                    if (!ignoreValue.contains(s.getKey())) {
                        System.err.println(message);
                        success[0] = false;
                    } else {
                        if (targetRow.get(s.getKey()) == null || targetRow.get(s.getKey()).length() == 0) {
                            System.err.println(message + " The 'ignoreValue' is applied for this column and value is expected to be populated.");
                            success[0] = false;
                        }
                    }
                }
            } else {
                System.err.println("[" + keyColumn + "=" + sourceRow.get(keyColumn) + "] The source column '" + sourceTable.getTableName().toUpperCase() + "." + s.getKey() + "' from result set doesn't exist in target result set!");
                success[0] = false;
            }
        });
        return success[0];
    }

    private boolean compareDerivationDataSets(Map<Integer, Map<String, String>> sourceDataSet, Map<Integer, Map<String, String>> targetDataSet) {
        boolean[] success = {true};
        expectedValueMap.forEach((col, val) -> {
            targetDataSet.forEach((tRowId, tRowColValMap) -> {
                if (!tRowColValMap.get(col).equals(val)) {
                    System.err.println("[" + keyColumn + "='" + tRowColValMap.get(keyColumn) + "'] The expected value for column '" + col + "' in target table '" + targetTable.getTableName().toUpperCase() + "' is '" + val + "', however actual value is '" + tRowColValMap.get(col) + "'");
                    success[0] = false;
                }
            });
        });


        sourceDataSet.forEach((sRowId, sRowColValMap) -> {
            Integer targetId = getIdByKeyColumn(sRowColValMap, targetDataSet);
            if (targetId != null) {
                columnMap.forEach((sCol, tCol) -> {
                    String expectedValue = sRowColValMap.get(sCol);
                    String actualValue = targetDataSet.get(targetId).get(tCol);

                    if (!expectedValue.equals(actualValue)) {
                        if (!ignoreValue.contains(sCol) || !ignoreValue.contains(tCol)) {
                            System.err.println("[" + keyColumn + "='" + sRowColValMap.get(keyColumn) + "'] The expected value for column '" + tCol + "' in target table '" + targetTable.getTableName() + "' is '" + expectedValue + "', however actual value is '" + actualValue + "'");
                            success[0] = false;
                        }
                    }
                });
            } else {
                System.err.println("[" + keyColumn + "='" + sRowColValMap.get(keyColumn) + "']  The source row is not found in '" + sourceTable.getTableName().toUpperCase() + "' table");
                success[0] = false;
            }
        });
        return success[0];
    }

    private boolean compareDerivationEmptyDataSets(Map<Integer, Map<String, String>> targetDataSet) {
        if (targetDataSet.size() != 0) {
            System.err.println("[" + testSuiteType.name() + "] The target table '" + targetTable.getTableName().toUpperCase() + "' is expected to be empty, however found '" + targetDataSet.size() + "'");
            return false;
        }
        return true;
    }

    private class Metadata {
        private String column;
        private String dataType;
        private String expression;
        private String columnId;
        private String nullable;
        private String identityColumn;
        private boolean ignore = false;

        Metadata(String column, String dataType, String expression, String columnId, String nullable, String identityColumn) {
            this.column = column;
            this.dataType = dataType;
            this.expression = expression;
            this.columnId = columnId;
            this.nullable = nullable;
            this.identityColumn = identityColumn;
        }

        public String getColumn() {
            return column;
        }

        public String getDataType() {
            return dataType;
        }

        public String getExpression() {
            return expression;
        }

        public void setColumn(String column) {
            this.column = column;
        }

        public void setExpression(String expression) {
            this.expression = expression;
        }

        public boolean isIgnore() {
            return ignore;
        }

        public void setIgnore(boolean ignore) {
            this.ignore = ignore;
        }

        public String getIdentityColumn() {
            return identityColumn;
        }

        public String getColumnId() {
            return columnId;
        }

        public String getNullable() {
            return nullable;
        }

        @Override
        public String toString() {
            return "Metadata{" +
                    "column='" + column + '\'' +
                    ", dataType='" + dataType + '\'' +
                    ", expression='" + expression + '\'' +
                    ", columnId='" + columnId + '\'' +
                    ", identityColumn='" + identityColumn + '\'' +
                    ", ignore='" + ignore + '\'' +
                    '}';
        }
    }

}