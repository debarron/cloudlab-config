#!/bin/bash
# Authors: @debarron @anask 

MACHINES="$1"
USER_NAME="$2"
PRIVATE_KEY="$3"

if [ "$#" -eq 3 ]
then
  echo "RAMCLOUD_HOME not specified, going for ~/RAMCloud"
  RAMCLOUD_HOME="\$HOME/RAMCloud"
else
  echo "RAMCLOUD_HOME set as $4"
  RAMCLOUD_HOME="$4"
fi

script="
sudo apt-get install -y build-essential
sudo apt-get install -y git-core 
sudo apt-get install -y doxygen 
sudo apt-get install -y libpcre3-dev 
sudo apt-get install -y protobuf-compiler 
sudo apt-get install -y libprotobuf-dev 
sudo apt-get install -y libcrypto++-dev 
sudo apt-get install -y libevent-dev 
sudo apt-get install -y libboost-all-dev 
sudo apt-get install -y libgtest-dev 
sudo apt-get install -y libzookeeper-mt-dev 
sudo apt-get install -y zookeeper 
sudo apt-get install -y libssl-dev 
echo 'export RAMCLOUD_HOME=\"${RAMCLOUD_HOME}\"' >> ~/.bashrc
"

echo ">> RAMCLOUD CONFIGURE"
echo -e "\t ## UPDATING CLUSTER NODES ... "
bp_list=""
for machine in $(cat $MACHINES)
do
  ssh -i $PRIVATE_KEY -o "StrictHostKeyChecking no" $USER_NAME@$machine "$script" &> /dev/null &
  echo -e "\t + $machine ... OK ☕"
  
  bp_list="$bp_list $!"
done

echo -e "\n\t ## WAITING FOR NODES TO FINISH"
TOTAL=$(cat $MACHINES | wc -l | sed 's/ //')
DATE=$(date| tr '[:lower:]' '[:upper:]')
echo $DATE
echo -e "\t ## CHECKING PIDS STATUS.. 🤖"
FINISHED=1
while [[ $FINISHED -gt 0 ]]; do
  FINISHED=$TOTAL

  states=""
  for pid in $bp_list; do
    state=$(ps -o state $pid  |tail -n +2)
    states="$states $state"
    if [[ ${#state} -eq 0 ]]; then
      FINISHED=$((FINISHED-1))
    fi;
  done;

  #echo $states
  echo "REMAINING: $FINISHED / $TOTAL .... 🤞🏼 "
  states=${states// /}
  if [[ ${#states} -gt 0 ]]; then
    sleep 30
  fi
done;

DATE=$(date| tr '[:lower:]' '[:upper:]')
echo $DATE
wait

echo -e ">> SETUP FINISHED 🌮"
exit 0
