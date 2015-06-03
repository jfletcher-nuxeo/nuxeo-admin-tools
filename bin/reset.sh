#!/bin/sh

# Script to manually remove a SNAPSHOT Studio package and re-install it. Useful when an update fails.
# See https://jira.nuxeo.com/browse/NXP-15210

# You should pass the path to Nuxeo and the ID of the Studio project
if [ ! -z "$1" ]
then
    nuxeoRoot=$1
    studioID=$2
else
    echo 'You should pass the path to Nuxeo and the ID of the Studio project'
    exit 1
fi

# Stop the server.
$nuxeoRoot/bin/nuxeoctl stop

# Remove the cached Studio project.
rm -rf $nuxeoRoot/packages/store/$studioID-0.0.0-SNAPSHOT/

# Remove the project JAR.
rm -rf $nuxeoRoot/nxserver/bundles/$studioID.jar

# Install the Studio package.
$nuxeoRoot/bin/nuxeoctl mp-install --accept true $studioID-0.0.0-SNAPSHOT

# Start the server.
$nuxeoRoot/bin/nuxeoctl start