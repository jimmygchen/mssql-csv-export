#!/bin/node
const fs = require('fs')
const { execSync } = require('child_process')

const dir = 'target'
const result = fs.readFileSync('table_names.txt', { encoding: 'utf-8' })
const tables = result.split('\n')

const sqlcmd = '\
docker exec -i sql1 /opt/mssql-tools/bin/sqlcmd -S localhost \
-U SA -P "P@ssw0rd" -d MY_RESTORED_DB -W -w 1024 -s"," -Q'

if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir);
}

tables
    .filter(name => !!name)
    .map(name => name.trim())
    .forEach(table => {
        execSync(`${sqlcmd} "SET NOCOUNT ON;SELECT * FROM ${table}" > ${dir}/${table}.csv`)
        console.log(`Table ${table} exported to ${dir}/${table}.csv`)
    })

console.log('Successfully exported the database.')
