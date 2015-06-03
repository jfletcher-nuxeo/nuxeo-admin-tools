#!/bin/sh
./nuxeoctl stop
rm -rf ../packages/store/liveconnect-webinar-nuxe-0.0.0-SNAPSHOT/
rm -rf ../nxserver/bundles/liveconnect-webinar-nuxe.jar
./nuxeoctl mp-install --accept true liveconnect-webinar-nuxe-0.0.0-SNAPSHOT
./nuxeoctl start &