#!/bin/sh

# Script to make a backup of Nuxeo running on Ubuntu/AWS Presales template.
# IMPORTANT: will stop and start Nuxeo.

nuxeoRoot="/var/lib/nuxeo"
backupRoot="/var/lib/nuxeo/server/tmp/backups"
backupStamp=`date +%Y%m%d_%H%M%S`
nuxeoConf="/etc/nuxeo/nuxeo.conf"

# The dumped files will be placed here.
backupFolder="$backupRoot/$backupStamp"

# File for the postgres dump.
pgBackupFile="pg_db.sql"

# File for the binaries.
binaryBackupfile="binaries.tar.gz"

# Stop the server.
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
pg_dump -U nuxeo -p 5433 nuxeo -f $backupFolder/$pgBackupFile

# Create a zip of the 'binaries' directory using gzip
tar -zcf $backupFolder/$binaryBackupfile $nuxeoRoot/data/binaries/

# Start the server.
$nuxeoRoot/bin/nuxeoctl start

echo "Done! Your files are at $backupFolder"
