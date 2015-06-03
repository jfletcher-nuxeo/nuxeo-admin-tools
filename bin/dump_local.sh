#!/bin/sh

# Script to make a backup of Nuxeo running on local system.
# Place this in your Nuxeo 'bin' folder.

nuxeoRoot="`pwd`/../"
backupRoot="$nuxeoRoot/tmp/backups"
backupStamp=`date +%Y%m%d_%H%M%S`

# The backuped files will be placed here.
backupFolder="$backupRoot/$backupStamp"

# File for the postgres backup.
pgBackupFile="pg_db.sql"

# File for the binaries.
binaryBackupfile="binaries.tar.gz"

# Stop the server in case you forgot.
./nuxeoctl stop

if [ ! -d "$backupRoot" ]; then
   mkdir $backupRoot
fi

if [ ! -d "$backupFolder" ]; then
   mkdir $backupFolder
fi

# backup the data.
pg_backup -U nuxeo -p 5433 nuxeo -f $backupFolder/$pgBackupFile

# Get the binaries
tar -zcf $backupFolder/$binaryBackupfile $nuxeoRoot/data/binaries/

echo "Done! Your files are at $backupFolder"
