#!/bin/bash

dbname="osm_germany"

sudo -u _renderd rm /var/cache/renderd/dirty_tiles.txt

sudo -u _renderd /opt/osm2pgsql/bin/osm2pgsql-replication update \
    --database $dbname \
    --username _renderd \
    -- \
    --cache 50000 \
    --number-processes=6 \
    --expire-tiles 1-17 \
    --expire-output /var/cache/renderd/dirty_tiles.txt

#sudo -u _renderd /opt/osm2pgsql/bin/osm2pgsql-replication update \
#    --database $dbname \
#    #--post-processing /switch2osm/osm_replication/expire_tiles_germany.sh \
#    --username _renderd \
#    --max-diff-size 10 -- -G \
#    --cache 50000 \
#    --number-processes=6 \
#    --expire-tiles 3-11 \
#    --expire-output /var/cache/renderd/dirty_tiles.txt

sudo chown _renderd /bigdata/export/world/mod_tile
sudo systemctl daemon-reload
sudo /etc/init.d/renderd restart
sudo /etc/init.d/apache2 restart

cut -d '/' -f1 /var/cache/renderd/dirty_tiles.txt | sort -n | uniq -c
