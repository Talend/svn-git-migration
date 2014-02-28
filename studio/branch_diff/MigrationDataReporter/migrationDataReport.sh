#!/bin/sh
baseFolder="../../migration_data/branches"
reporterFile="MigrationData.report"

# Support filter repository, using "-Dfilter.values=tom,tem"
# Also, can compare the migration data between too branch, using "-Denable.compare.data=true"

java -cp MigrationDataReporter.jar org.talend.svn2git.migration.data.MigrationDataReporter $baseFolder > "$baseFolder/$reporterFile"
