package com.microgen.quality.ut.testing.database_tests.schema_compare;

import com.microgen.quality.tlf.database.IDataComparisonOperator;
import com.microgen.quality.ut.*;
import org.apache.log4j.Logger;
import org.testng.Assert;
import org.testng.annotations.Test;

import java.nio.file.Files;
import java.nio.file.Path;

public class testCompareMetaTableToDBTable {

    private static final Logger LOG = Logger.getLogger(testCompareMetaTableToDBTable.class);
    private final IDataComparisonOperator DATA_COMP_OPS = DataComparisonOperatorFactory.getDataComparisonOperator(DatabaseConnectorFactory.getDatabaseConnectorG77_CFG());
    private final TokenReplacement TOKEN_OPS = new TokenReplacement();
    private final Path PATH_TO_RESOURCES = Resources.getPathToResource("testing/schema_compare");

    @Test
    public void testIfArchiveTablesHaveCorrectStructure() throws Exception {
        LOG.info("Test: Check if tables in T_META_TABLE exists in the database.");
        final Path PATH_TO_EXPECTED_RESULTS = PATH_TO_RESOURCES.resolve("tables_in_t_meta_table_expected_result.sql");
        final Path PATH_TO_ACTUAL_RESULTS = PATH_TO_RESOURCES.resolve("tables_in_all_tables_actual_result.sql");

        assert (Files.exists(PATH_TO_RESOURCES) && Files.isDirectory(PATH_TO_RESOURCES));
        assert (Files.exists(PATH_TO_EXPECTED_RESULTS) && Files.isRegularFile(PATH_TO_EXPECTED_RESULTS));
        assert (Files.exists(PATH_TO_ACTUAL_RESULTS) && Files.isRegularFile(PATH_TO_ACTUAL_RESULTS));

        Assert.assertEquals
                (
                        0
                        , DATA_COMP_OPS.countMinusQueryResultsOneDirection
                                (
                                        PATH_TO_EXPECTED_RESULTS
                                        , PATH_TO_ACTUAL_RESULTS
                                        , new String[0]
                                        , TOKEN_OPS
                                )
                );
    }
}