#!/bin/bash

ID="$1"
SHARED_DIR="/proj/nosql-json-PG0/"
echo ">> RAMCLOUD CONFIGURE"

echo "\t ## CONFIG AND COMPILE RAMCLOUD LOCAL"
echo "\t ## DOWNLOADING RAMCLOUD (latest) and RAMCloudServices"
git clone https://github.com/debarron/RAMCloud.git $HOME/RAMCloud

mkdir $HOME/RAMCloud/zookeeper
cd $HOME/RAMCloud

echo "\t ## DOWNLOADING ZOOKEEPER (version 3.4.14)"
wget http://mirrors.sonic.net/apache/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz
tar -xvf zookeeper-3.4.14.tar.gz -C zookeeper --strip-components 1
rm zookeeper-3.4.14.tar.gz

echo "\t ## COMPILINT RAMCloud ... This will take time"
git submodule update --init --recursive
ln -s ../../hooks/pre-commit .git/hooks/pre-commit
make -j12

cp -r $HOME/RAMCloud "$SHARED_DIR/RAMCloud_$ID"
rm -Rf $HOME/RAMCloud

exit 0
