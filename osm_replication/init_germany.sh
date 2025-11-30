#!/bin/bash

dbname="osm_germany"

sudo -u _renderd /opt/osm2pgsql/bin/osm2pgsql-replication init -d $dbname \
    --server http://download.geofabrik.de/europe/germany-updates/

sudo systemctl restart renderd
