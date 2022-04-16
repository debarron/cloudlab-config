#!/bin/bash

MACHINES="$1"
USER_NAME="$2"
PRIVATE_KEY="$3"

# The best alternative I could find to go around ssh
# not very proud of it
env_script="
if [ ! -f \$HOME/envs.sh ]
then
  grep RAMCLOUD \$HOME/.bashrc > \$HOME/envs.sh
  chmod u+x \$HOME/envs.sh
fi
. \$HOME/envs.sh
"

start_zoo_script="
$env_script
\$RAMCLOUD_HOME/zookeeper/bin/zkServer.sh start
"

status_zoo_script="
$env_script
\$RAMCLOUD_HOME/zookeeper/bin/zkServer.sh status
"

echo ">> CONFIGURING ZOOKEEPER SERVICE"
echo -e "\t ## ZOOKEEPER SERVICE START"
for machine in $(cat $MACHINES)
do
  ssh -i $PRIVATE_KEY -o "StrictHostKeyChecking no" "$USER_NAME@$machine" "$start_zoo_script"
done
sleep 3

echo -e "\t ## DETECTING ZOOKEEPER LEADER"
id=1
for machine in $(cat $MACHINES)
do
  ssh -i $PRIVATE_KEY -o "StrictHostKeyChecking no" "$USER_NAME@$machine" "$status_zoo_script" > "$id.zk"
  id=$(($id+1))
done
ip_leader=$(grep "leader" *.zk | cut -d. -f1)
ZOOKEEPER_LEADER="zk:10.10.1.$ip_leader"
echo -e "\t ## ZOOKEEPER_LEADER found in 10.10.1.$ip_leader"

echo -e "\t ## ADDING RAMCLOUD_ZOOKEEPER_LEADER to ramcloud-env.sh in all nodes"
script="
$env_script
. \$RAMCLOUD_HOME/conf/ramcloud-env.sh
echo \"export RAMCLOUD_ZOOKEEPER_LEADER=\\\"$ZOOKEEPER_LEADER:\$RAMCLOUD_ZOOKEEPER_PORT\\\"\" >> \$RAMCLOUD_HOME/conf/ramcloud-env.sh
"
for machine in $(cat $MACHINES)
do
  ssh -i $PRIVATE_KEY -o "StrictHostKeyChecking no" "$USER_NAME@$machine" "$script"
done

rm *.zk
echo -e ">> SETUP FINISHED 🌮"
exit 0

