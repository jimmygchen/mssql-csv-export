#!/bin/bash
set -e
set -u

db_file=$1
db_pass=P@ssw0rd

echo 'Running mssql server in docker...'
docker run --rm -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=P@ssw0rd" \
   -e 'MSSQL_PID=Express' -p 1433:1433 --name sql1 \
   -d microsoft/mssql-server-linux:2017-latest

echo 'Copying backup file into container...'
docker cp "${db_file}" sql1:/var/opt/mssql/backup

echo 'Getting list of logical file names inside the backup...'
docker exec -it sql1 /opt/mssql-tools/bin/sqlcmd -S localhost \
   -U SA -P ${db_pass} \
   -Q 'RESTORE FILELISTONLY FROM DISK = "/var/opt/mssql/backup"' \
   | tr -s ' ' | cut -d ' ' -f 1-2

echo 'Script completed. Copy the logical names to the restore command in 2_export.sh before running it.'
