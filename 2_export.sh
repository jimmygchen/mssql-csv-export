#!/bin/bash
set -e
set -u

db_pass=P@ssw0rd

# ACTION REQUIRED: replace the the logical names using results from previous script
echo "Restoring database from backup..."
docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P "${db_pass}" \
   -Q 'RESTORE DATABASE MY_RESTORED_DB FROM DISK = "/var/opt/mssql/backup" WITH MOVE "<data_file_logical_name>" TO "/var/opt/mssql/data/<data_file_logical_name>.mdf", MOVE "<log_file_logical_name>" TO "/var/opt/mssql/data/<log_file_logical_name>.ldf"'

echo "Verifying the restored database..."
docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P "${db_pass}" \
   -Q 'SELECT Name FROM sys.Databases'

echo "Exporting list of table names..."
docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd \
   -S localhost -U SA -P "${db_pass}" -d MY_RESTORED_DB -h-1 \
   -Q 'SET NOCOUNT ON;SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES GO' > table_names.txt

echo "Exporting tables to CSV..."
node export-tables.js

echo "Cleaning up..."
docker stop sql1 &> /dev/null
echo "Script completed successfully."
