#!/bin/sh

# Script to manually remove a Studio package and re-install it. Useful when an update files.
# See https://jira.nuxeo.com/browse/NXP-15210

# Stop the server.
./nuxeoctl stop

# Remove the cached Studio project.
rm -rf ../packages/store/liveconnect-webinar-nuxe-0.0.0-SNAPSHOT/

# Remove the project JAR.
rm -rf ../nxserver/bundles/liveconnect-webinar-nuxe.jar

# Install the Studio package.
./nuxeoctl mp-install --accept true liveconnect-webinar-nuxe-0.0.0-SNAPSHOT

# Start the server.
./nuxeoctl start &