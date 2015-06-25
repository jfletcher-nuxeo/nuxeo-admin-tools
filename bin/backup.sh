#!/bin/sh

# Params

# $1 - path to Nuxeo (e.g. the folder that contains bin)
# $2 - postgres database name
# $3 - path to 'binaries' folder
# $4 - path to nuxeo.conf

if [ "$#" -ne 4 ]
then
	# Defaults for presales instances.
	nuxeoRoot="/var/lib/nuxeo/server"
	dbName="nuxeo"
	pathToBinaries="$nuxeoRoot/data/binaries/"
	nuxeoConf="/etc/nuxeo/nuxeo.conf"
else
	nuxeoRoot=$1
	dbName=$2
	pathToBinaries=$3
	nuxeoConf=$4
fi


# Script to make a backup of Nuxeo running on Ubuntu/AWS Presales template.
# IMPORTANT: will stop and start Nuxeo.

backupRoot="$nuxeoRoot/backup"
backupStamp=`date +%Y%m%d_%H%M%S`


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
pg_dump -U nuxeo -p 5433 $dbName -f $backupFolder/$pgBackupFile

# Create a zip of the 'binaries' directory using gzip
tar -zcf $backupFolder/$binaryBackupfile $pathToBinaries

# Start the server.
$nuxeoRoot/bin/nuxeoctl start

echo "Done! Your files are at $backupFolder"
