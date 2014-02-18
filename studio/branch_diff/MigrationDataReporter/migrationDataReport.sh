#!/bin/sh
baseFolder="../../migration_data/branches"
reporterFile="MigrationData.report"

java -cp MigrationDataReporter.jar org.talend.svn2git.migration.data.MigrationDataReporter $baseFolder > "$baseFolder/$reporterFile"
