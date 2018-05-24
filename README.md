# export-mssql-backup-to-csv
Scripts for exporting a SQL Server backup to csv files.

## Prerequisites
- Docker
- Node.js

## Steps
1. Run mssql in a container and load your backup file into the container.
```
$ ./1_start.sh <your_backup_file>
```
2. Copy the logical names of the files and update the restore db command in `2_export.sh`
3. Run `./2_export.sh`.

## References
https://docs.microsoft.com/en-au/sql/linux/tutorial-restore-backup-in-sql-server-container?view=sql-server-linux-2017#restore-the-database

@jchen86