#!/bin/bash

MACHINES="$1"
USER_NAME="$2"
PRIVATE_KEY="$3"

ID=$(head -1 "${MACHINES}-INSTALL_ID.txt")
first_machine=$(head -1 $MACHINES)
machine_count=$(wc -l < $MACHINES)

echo -e "\t ## GENERATING COORDINATOR AND SERVERS FILE"
echo "10.10.1.1" > coordinators

count="2"
for i in `seq $count $machine_count`
do
  echo "10.10.1.$i" >> servers
done


RAMCLOUD_ZOOKEEPER_DATA_DIR="/mydata/zoo"
RAMCLOUD_BACKUP_DIR="/mydata/rc"
RAMCLOUD_LOG_DIR="/mydata/logs"
RAMCLOUD_ZOOKEEPER_PORT="2181"

ramcloud_configure_text="
export RAMCLOUD_PROTOCOL=\"tcp\"
export RAMCLOUD_SERVER_PORT=\"1101\"
export RAMCLOUD_COORD_PORT=\"1110\"
export RAMCLOUD_LOG_DIR=\"$RAMCLOUD_LOG_DIR\"
export RAMCLOUD_BACKUP_DIR=\"$RAMCLOUD_BACKUP_DIR\"
export RAMCLOUD_ZOOKEEPER_DATA_DIR=\"$RAMCLOUD_ZOOKEEPER_DATA_DIR\"
export RAMCLOUD_ZOOKEEPER_PORT=\"$RAMCLOUD_ZOOKEEPER_PORT\"
"
zookeeper_configure_text="tickTime=200
dataDir=$RAMCLOUD_ZOOKEEPER_DATA_DIR
clientPort=$RAMCLOUD_ZOOKEEPER_PORT
initLimit=5
syncLimit=2"

echo ">> CONFIGURING ZOOKEEPER SERVICE"
echo -e "\t ## GENERATING zoo.cfg ramcloud-env.sh"
MACHINE_COUNT=$(wc -l < $MACHINES)
IP_PREFIX="10.10.1"
ZOOKEEPER_PORTS="2191:3881"
zookeeper_head="$zookeeper_configure_text"
for i in `seq 1 $machine_count`
do
  zookeeper_head="$zookeeper_head\nserver.$i=$IP_PREFIX.$i:$ZOOKEEPER_PORTS"
done

echo ">> COPYING CONFIG FILES"
echo -e "$zookeeper_head" > "zoo.cfg"
echo -e "$ramcloud_configure_text" > "ramcloud-env.sh" && chmod u+x "ramcloud-env.sh"
scp -i $PRIVATE_KEY -o "StrictHostKeyChecking no" "zoo.cfg" "$USER_NAME@$first_machine:/proj/nosql-json-PG0/RAMCloud_$ID/zookeeper/conf/" 
scp -i $PRIVATE_KEY -o "StrictHostKeyChecking no" "ramcloud-env.sh" "$USER_NAME@$first_machine:/proj/nosql-json-PG0/RAMCloud_$ID/conf/"
scp -i $PRIVATE_KEY -o "StrictHostKeyChecking no" "coordinators" "$USER_NAME@$first_machine:/proj/nosql-json-PG0/RAMCloud_$ID/conf/"
scp -i $PRIVATE_KEY -o "StrictHostKeyChecking no" "servers" "$USER_NAME@$first_machine:/proj/nosql-json-PG0/RAMCloud_$ID/conf/"

echo -e ">> CREATING $RAMCLOUD_ZOOKEEPER_DATA_DIR AND $RAMCLOUD_BACKUP_DIR AND $RAMCLOUD_LOG_DIR"
id=1
for machine in $(cat $MACHINES)
do
  script="mkdir -p $RAMCLOUD_ZOOKEEPER_DATA_DIR && mkdir -p $RAMCLOUD_BACKUP_DIR && mkdir -p $RAMCLOUD_LOG_DIR"
  ssh -i $PRIVATE_KEY -o "StrictHostKeyChecking no" "$USER_NAME@$machine" "echo 'export RAMCLOUD_HOME=\"\$HOME/RAMCloud\"' >> \$HOME/.bashrc"
  ssh -i $PRIVATE_KEY -o "StrictHostKeyChecking no" "$USER_NAME@$machine" "$script"
  ssh -i $PRIVATE_KEY -o "StrictHostKeyChecking no" "$USER_NAME@$machine" "echo \"$id\" > $RAMCLOUD_ZOOKEEPER_DATA_DIR/myid"
  id=$(($id+1))
done

rm "coordinators" "servers" "ramcloud-env.sh" "zoo.cfg"
echo -e ">> SETUP FINISHED 🌮"
exit 0
