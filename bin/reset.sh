#!/bin/sh

# Script to manually remove a SNAPTHOT Studio package and re-install it. Useful when an update fails.
# See https://jira.nuxeo.com/browse/NXP-15210

# Hardcode the params if you want.
nuxeoRoot="`pwd`/../"
studioID="liveconnect-webinar-nuxe"

# Stop the server.
./nuxeoctl stop

# Remove the cached Studio project.
rm -rf ../packages/store/$studioID-0.0.0-SNAPSHOT/

# Remove the project JAR.
rm -rf ../nxserver/bundles/$studioID.jar

# Install the Studio package.
./nuxeoctl mp-install --accept true $studioID-0.0.0-SNAPSHOT

# Start the server.
./nuxeoctl start &