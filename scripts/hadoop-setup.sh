#!/bin/bash
INSTALL_ID="$1"
data_dir="$2"

HADOOP_VER="2.7.6"
master_node="vm0"
node_prefix="vm"
node_start=1
node_end=$(cat /etc/hosts | grep -v 'vm0\|localhost' | wc -l)

NN_DIR="$data_dir/hadoop/hdfs/namenode"
DN_DIR="$data_dir/hadoop/hdfs/datanode"
NUMREP="1"
HSTNAME=$(hostname | cut -d '.' -f 1)
HOST_PRIVATE_IP=$(grep $HSTNAME /etc/hosts | cut -f 1)
HSTNAME_LEN=${#HSTNAME}

echo "DOWNLOADING HADOOP.."
# how many servers to try:
NUM_HSEV=$(curl -s 'http://www.apache.org/dyn/closer.cgi?as_json=1' | jq --raw-output '.http[]' | wc -l)
HSERV=0
ISZIP=""

HADOOP_URL="https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VER/hadoop-$HADOOP_VER.tar.gz"
curl --connect-timeout 103 -O $HADOOP_URL &> /dev/null
HDFT=$(file hadoop-$HADOOP_VER*)
ISZIP=$(echo $HDFT | grep 'gzip compressed data' || echo "")
HSERV=$((HSERV+1))

if [ ${#ISZIP} -eq 0 ]; then
    echo 'ERROR: COULD NOT DOWNLOAD HADOOP '$HADOOP_VER
    exit 1
fi

# Clean in case of previous install
cluster_prefix="/proj/nosql-json-PG0/hadoop_$INSTALL_ID"
rm -Rf "$cluster_prefix"
mkdir -p "$cluster_prefix"

# Extract hadoop in the prefix dir
tar xzf hadoop-$HADOOP_VER*gz -C "$cluster_prefix" --strip-components 1
hadoop_prefix="$cluster_prefix"

######################
## HADOOP FILES
######################

# HADOOP-ENV
HADOOP_ENV="$hadoop_prefix/etc/hadoop/hadoop-env.sh"
echo '
export HADOOP_IDENT_STRING=$USER
export JAVA_HOME="/usr/lib/jvm/default-java"
' > $HADOOP_ENV

# CORE-SITE
CORE_SITE_FILE="$hadoop_prefix/etc/hadoop/core-site.xml"
echo '<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
      <name>fs.defaultFS</name>
      <value>hdfs://'$master_node':9000</value>
  </property>
  <property>
      <name>hadoop.tmp.dir</name>
      <value>file:'$data_dir'/hadoop/hadoop_data/tmp</value>
  </property>
  <property>
    <name>dfs.webhdfs.enabled</name>
    <value>false</value>
  </property>
</configuration>
' > $CORE_SITE_FILE


# MAPRED-SITE
MAPRED_SITE_FILE="$hadoop_prefix/etc/hadoop/mapred-site.xml"
echo '<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>mapreduce.framework.name</name>
    <value>yarn</value>
  </property>
</configuration>
' > $MAPRED_SITE_FILE


# YARN-SITE
YARN_SITE_FILE="$hadoop_prefix/etc/hadoop/yarn-site.xml"
echo '<?xml version="1.0"?>
<configuration>
      <property>
          <name>yarn.nodemanager.aux-services</name>
          <value>mapreduce_shuffle</value>
      </property>
      <property>
          <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
          <value>org.apache.hadoop.mapred.ShuffleHandler</value>
      </property>
      <property>
               <name>yarn.resourcemanager.resource-tracker.address</name>
               <value>'$master_node':8025</value>
      </property>
      <property>
               <name>yarn.resourcemanager.scheduler.address</name>
               <value>'$master_node':8030</value>
      </property>
      <property>
               <name>yarn.resourcemanager.address</name>
               <value>'$master_node':8050</value>
      </property>
</configuration>
' > $YARN_SITE_FILE


HDFS_SITE_FILE="$hadoop_prefix/etc/hadoop/hdfs-site"
# HDFS-MASTERNODE
echo '<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
      <name>dfs.replication</name>
      <value>'$NUMREP'</value>
    </property>
    <property>
      <name>dfs.namenode.name.dir</name>
      <value>'$NN_DIR'</value>
    </property>
    <property>
      <name>dfs.permissions</name>
      <value>false</value>
    </property>
</configuration>
' > "$HDFS_SITE_FILE.masternode"


# HDFS-DATANODE
echo '<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
      <name>dfs.replication</name>
      <value>'$NUMREP'</value>
    </property>
    <property>
          <name>dfs.datanode.data.dir</name>
          <value>'$DN_DIR'</value>
    </property>
    <property>
      <name>dfs.permissions</name>
      <value>false</value>
    </property>
</configuration>
' > "$HDFS_SITE_FILE.datanode"


SLAVES_FILE="$hadoop_prefix/etc/hadoop/slaves"
cp /dev/null $SLAVES_FILE
for node in `seq $node_start $node_end`
do
    echo "$node_prefix$node" >> $SLAVES_FILE 
done