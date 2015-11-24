#!/bin/sh

logMessage(){
	messagePrefix="[backup-message]"
	echo "$messagePrefix $1"
}

# Script to make a backup of Nuxeo running on Ubuntu/AWS Presales template.
# IMPORTANT: will stop and start Nuxeo.

nuxeoRoot="/var/lib/nuxeo"
backupRoot="/var/lib/nuxeo/server/tmp/backups"
backupStamp=`date +%Y%m%d_%H%M%S`
nuxeoConf="/etc/nuxeo/nuxeo.conf"

# The dumped files will be placed here.
backupFolder="$backupRoot/$backupStamp"
backupFile="$backupStamp.tar.gz"

# File for the postgres dump.
pgBackupFile="pg_db.sql"

# File for the binaries.
binaryBackupfile="binaries.tar.gz"

# Stop the server.
logMessage "Stopping Nuxeo at $nuxeoRoot"
$nuxeoRoot/server/bin/nuxeoctl stop

if [ ! -d "$backupRoot" ]; then
	logMessage "Creating backup root $backupRoot"
   mkdir $backupRoot
fi

if [ ! -d "$backupFolder" ]; then
	logMessage "Creating backup folder $backupFolder"
   mkdir $backupFolder
fi

# Backup nuxeo.conf.
logMessage "Copying nuxeo.conf from $nuxeoConf to $backupFolder"
cp $nuxeoConf $backupFolder

# Backup the data.
logMessage "Dumping PostgreSQL database to $backupFolder/$pgBackupFile"
pg_dump -U nuxeo -p 5433 nuxeo -f $backupFolder/$pgBackupFile

# Create a zip of the 'binaries' directory using gzip
logMessage "Zipping binaries from $nuxeoRoot/data/binaries to $backupFolder/$binaryBackupfile"
tar -czf $backupFolder/$binaryBackupfile -C $nuxeoRoot/data binaries

# Create a zip of the backup
logMessage "Zipping entire backup to $backupRoot/$backupFile"
tar -czf $backupRoot/$backupFile -C $backupRoot $backupStamp

# Delete backup folder
logMessage "Deleting backup folder $backupFolder"
rm -rf $backupFolder

# Start the server.
logMessage "Starting Nuxeo at $nuxeoRoot"
$nuxeoRoot/server/bin/nuxeoctl start

logMessage "Done! Your backup is at $backupRoot/$backupFile"
