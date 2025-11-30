#!/bin/bash

sudo -u _renderd render_expired \
    --map=germany \
    --touch-from=1 \
    --delete-from=18 \
    --min-zoom=1 --max-zoom=17 \
    --tile-dir=/bigdata/export/world/mod_tile \
    --num-threads=6 \
    --socket=/run/renderd/renderd.sock </var/cache/renderd/dirty_tiles.txt

#sudo -u _renderd render_expired \
#    --map=germany \
#    --touch-from=3 \
#    --delete-from=14 \
#    --min-zoom=3 --max-zoom=13 \
#    --tile-dir=/bigdata/export/world/mod_tile \
#    --num-threads=6 \
#    --socket=/run/renderd/renderd.sock < /var/cache/renderd/dirty_tiles.txt

sudo chown _renderd /bigdata/export/world/mod_tile
sudo systemctl daemon-reload
sudo /etc/init.d/renderd restart
sudo /etc/init.d/apache2 restart

cut -d '/' -f1 /var/cache/renderd/dirty_tiles.txt | sort -n | uniq -c

sudo rm /var/cache/renderd/dirty_tiles.txt
