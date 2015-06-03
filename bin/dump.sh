#!/bin/sh

# Script to make a copy of postgres data and binaries.
# IMPORTANT: will stop and start Nuxeo.

nuxeoRoot="/var/lib/nuxeo"
dumpRoot="/var/lib/nuxeo/server/tmp/dumps"
stamp=`date +%Y%m%d_%H%M%S`

# The dumped files will be placed here.
dumpFolder="$dumpRoot/$stamp"

# File for the postgres dump.
dumpFile="pg_db.sql"

# File for the binaries.
binaryFile="binaries.tar.gz"

# Stop the server.
./nuxeoctl stop

if [ ! -d "$dumpRoot" ]; then
   mkdir $dumpRoot
fi

if [ ! -d "$dumpFolder" ]; then
   mkdir $dumpFolder
fi

# Dump the data.
pg_dump -U nuxeo -p 5433 nuxeo -f $dumpFolder/$dumpFile

# Get the binaries
tar -zcf $dumpFolder/$binaryFile $nuxeoRoot/data/binaries/

# Start the server.
./nuxeoctl start

echo "Done! Your files are at $dumpFolder"
