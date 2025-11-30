#!/usr/bin bash

sudo rm -R /opt/osm2pgsql/ $HOME/test
root=$HOME/test

# define a directory for download and unpacked packages
downloaddir=${root}/originals
packagedir=${root}/packages
installdir=/opt/osm2pgsql

for dir in ${root} ${downloaddir} ${packagedir} ${installdir}; do
    mkdir -p ${dir}
done
########################################################################################################################
# download GDAL and its dependencies
cd $root
git clone https://github.com/openstreetmap/osm2pgsql.git

########################################################################################################################
# install osm2pgsql

cd osm2pgsql*
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${installdir} ..
cmake --build . -j 6
sudo cmake --build . --target install

/opt/osm2pgsql/bin/osm2pgsql --version

# deleting the root directory which is no longer needed
sudo rm -rf ${root}