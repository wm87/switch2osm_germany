#!/bin/bash

mkdir -p /bigdata/import/osm/karte_germany_osm
chmod o+rx /bigdata/import/osm/karte_germany_osm
rm /bigdata/import/osm/karte_germany_osm/germany-latest.osm.pbf
cd /bigdata/import/osm/karte_germany_osm

wget https://download.geofabrik.de/europe/germany-latest.osm.pbf
