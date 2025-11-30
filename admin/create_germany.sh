#!/bin/bash

# load data from OSM
# https://switch2osm.org/serving-tiles/manually-building-a-tile-server-ubuntu-21/

sudo apt autoremove && sudo apt autoclean
sudo apt update && sudo apt upgrade
sudo apt install renderd
sudo apt install libboost-filesystem1.88.0 screen locate libapache2-mod-tile renderd git tar unzip wget bzip2 apache2 lua5.4 mapnik-utils python3-mapnik python3-psycopg2 python3-yaml gdal-bin npm fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted fonts-unifont postgresql postgis postgresql-18-postgis-3 postgresql-18-postgis-3-scripts net-tools
sudo apt install screen locate libapache2-mod-tile renderd git tar unzip wget bzip2 apache2 lua5.4 mapnik-utils python3-mapnik python3-psycopg2 python3-yaml gdal-bin npm fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted fonts-unifont
sudo apt install fonts-noto-cjk fonts-noto-hinted fonts-noto-unhinted fonts-hanazono fonts-unifont

sudo rm -R ~/.cache/QGIS/
sudo rm -R /switch2osm/src/*
sudo rm -R /bigdata/export/world/mod_tile/germany

# dekleration #
dbname="osm_germany"
cores=6

# get Connection
source /switch2osm/params/db_params.sh $dbname

# DB erstellen #
psql -c "SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '$dbname' AND pid <> pg_backend_pid();" $CON

sudo -u postgres dropdb osm_germany
sudo -u postgres createuser _renderd
sudo -u postgres createdb -E UTF8 -p $dbport $dbname -D $dbtablespace -O _renderd

psql -c "ALTER SCHEMA public OWNER TO _renderd;" $CON
psql -c "CREATE EXTENSION postgis; CREATE EXTENSION hstore;" $CON
psql -c "ALTER TABLE geometry_columns OWNER TO _renderd;" $CON
psql -c "ALTER TABLE spatial_ref_sys OWNER TO _renderd;" $CON
psql -c "GRANT ALL ON SCHEMA public TO _renderd;" $CON

mkdir -p /switch2osm/

# Stylesheet configuration
cd /switch2osm/
mkdir -p src/
cd src/
git clone https://github.com/gravitystorm/openstreetmap-carto
cd openstreetmap-carto

sudo npm install -g carto
carto -v

carto project.mml >germany.xml
grep -rl 'CDATA\[gis\]' ./germany.xml | xargs sed -i 's/CDATA\[gis\]/CDATA\[osm_germany\]/g'

cd /bigdata/import/osm/karte_germany_osm

chmod o+rx /switch2osm/src
chmod o+rx /bigdata/import/osm/karte_germany_osm
chmod o+rx ~

cp /switch2osm/src/openstreetmap-carto/germany.xml /switch2osm/mapnik/
cp /switch2osm/mapnik/*.xml /switch2osm/src/openstreetmap-carto/

#sudo -u _renderd /opt/osm2pgsql/bin/osm2pgsql -d osm_germany --create -G --hstore --tag-transform-script /switch2osm/src/openstreetmap-carto/openstreetmap-carto.lua --number-processes 6 -S /switch2osm/src/openstreetmap-carto/openstreetmap-carto.style /bigdata/import/osm/karte_germany_osm/germany-latest.osm.pbf
sudo -u _renderd /opt/osm2pgsql/bin/osm2pgsql \
	--create \
	--slim \
	--database=osm_germany \
	--host=localhost \
	--number-processes=6 \
	--cache=50000 \
	--output=flex \
	--style=/switch2osm/settings/openstreetmap-carto-flex.lua \
	/bigdata/import/osm/karte_germany_osm/germany-latest.osm.pbf

# Creating indexes
cd /switch2osm/src/openstreetmap-carto/
scripts/indexes.py -0 | xargs -0 -P0 -I{} psql -d osm_germany -U _renderd -c "{}"
psql -f functions.sql -d osm_germany -U _renderd

# Shapefile download
cd /switch2osm/src/openstreetmap-carto/
grep -rl 'gis' ./external-data.yml | xargs sed -i 's/gis/osm_germany/g'
mkdir -p data

scripts/get-external-data.py -U postgres

psql -c "GRANT USAGE ON SCHEMA public TO _renderd;" $CON

tables=$(psql -U postgres -d $dbname -t -c "select tablename from pg_tables where schemaname = 'public';")

for table in $tables; do
	psql -U postgres -d $dbname -c "GRANT SELECT, INSERT, UPDATE, DELETE on public.$table to _renderd;"
done

sh scripts/change-fonts-cjk.sh
sh scripts/get-fonts.sh

sudo chown _renderd /bigdata/export/world/mod_tile
sudo systemctl daemon-reload
sudo /etc/init.d/renderd restart
sudo /etc/init.d/apache2 restart
