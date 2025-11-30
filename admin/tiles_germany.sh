#!/bin/bash

sudo /etc/init.d/postgresql restart
sudo systemctl daemon-reload
sudo /etc/init.d/renderd restart

sudo rm -R ~/.cache/QGIS/
sudo chown _renderd /bigdata/export/world/mod_tile

# -n 6 -x 5.7  -X 15.1 -y 47.2 -Y 55.0
# -n 6 -x 5.7  -X 15.1 -y 47.2 -Y 55.0

# 64 min (10.08.25)
#perl /switch2osm/settings/render_list_geo.pl -s /run/renderd/renderd.sock -t /bigdata/export/world/mod_tile -m germany -f -z 1 -Z 12 -n 6 -x 5.7 -X 15.1 -y 47.2 -Y 55.0

# 115 min (09.10.25)
#perl /switch2osm/settings/render_list_geo.pl -s /run/renderd/renderd.sock -t /bigdata/export/world/mod_tile -m germany -f -z 13 -Z 15 -n 6 -x 5.7 -X 15.1 -y 47.2 -Y 55.0

# 130 min (10.10.25)
#perl /switch2osm/settings/render_list_geo.pl -s /run/renderd/renderd.sock -t /bigdata/export/world/mod_tile -m germany -f -z 16 -Z 16 -n 6 -x 5.7 -X 15.1 -y 47.2 -Y 55.0

# 356 min (11.10.25)
#perl /switch2osm/settings/render_list_geo.pl -s /run/renderd/renderd.sock -t /bigdata/export/world/mod_tile -m germany -f -z 17 -Z 17 -n 6 -x 5.7 -X 15.1 -y 47.2 -Y 55.0

# ??
#perl /switch2osm/settings/render_list_geo.pl -s /run/renderd/renderd.sock -t /bigdata/export/world/mod_tile -m germany -f -z 18 -Z 18 -n 6 -x 5.7  -X 15.1 -y 47.2 -Y 55.0

sudo /etc/init.d/postgresql restart
sudo systemctl daemon-reload
sudo /etc/init.d/renderd restart

sudo chown _renderd /bigdata/export/world/mod_tile
