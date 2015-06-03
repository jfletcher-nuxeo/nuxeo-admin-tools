#!/bin/sh

# Script to make a backup of Nuxeo running on local system.
# Only supports Postgres database for now.

# You should pass the path to Nuxeo and the database name.
if [ ! -z "$1" ]
then
    nuxeoRoot=$1
    database=$2
else
    echo 'usage: backup-local path_to_Nuxeo database_name'
    exit 1
fi

backupRoot="$nuxeoRoot/tmp/backups"
backupStamp=`date +%Y%m%d_%H%M%S`
nuxeoConf="$nuxeoRoot/bin/nuxeo.conf"

# The backuped files will be placed here.
backupFolder="$backupRoot/$backupStamp"

# File for the postgres backup.
pgBackupFile="pg_db.sql"

# File for the binaries.
binaryBackupfile="binaries.tar.gz"

# Stop the server in case you forgot.
$nuxeoRoot/bin/nuxeoctl stop

if [ ! -d "$backupRoot" ]; then
   mkdir $backupRoot
fi

if [ ! -d "$backupFolder" ]; then
   mkdir $backupFolder
fi

# Backup nuxeo.conf.
cp $nuxeoConf $backupFolder

# Backup the data.
pg_dump -U nuxeo $database -f $backupFolder/$pgBackupFile

# Create a zip of the 'binaries' directory using gzip
tar -czf $backupFolder/$binaryBackupfile $nuxeoRoot/nxserver/data/binaries/

echo "Done! Your files are at $backupFolder"
