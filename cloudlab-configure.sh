#!/bin/bash
cluster_machines="$1"
username="$2"
private_key="$3"
local_storage="$4"


cd ./scripts
echo ">> CURRENT DIR: $(pwd)" 

echo ">> Running ClusterConfigure"
./cluster-configure.sh "$cluster_machines" "$username" "$private_key" "$local_storage"

echo ">> Running OpenSlideConfigure"
./openslide-configure.sh "$cluster_machines" "$username" "$private_key"

echo ">> Running RAMCloudConfigure"
./ramcloud-configure.sh "$cluster_machines" "$username" "$private_key"

echo ">> Running FUSEConfigure"
./fuse-configure.sh "$cluster_machines" "$username" "$private_key"

next_steps="
Log into the cluster's master node:
\t ssh $username@\$\(head -1 scripts/$cluster_machines\)

Start hadoop (if needed):
\t \$HADOOP_HOME/bin/hadoop namenode -format
\t \$HADOOP_HOME/sbin/start-dfs.sh

Start spark (if needed):
\t \$SPARK_HOME/sbin/start-all.sh

Start ramcloud (if needed):
\t \$RAMCLOUD_HOME/sbin/start-all.sh /mydata/rc/bak <MEMORY_MB> <R_FACTOR>
"
