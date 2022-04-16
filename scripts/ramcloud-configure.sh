#!/bin/bash

MACHINES="$1"
USER_NAME="$2"
PRIVATE_KEY="$3"

experiment=$(basename $MACHINES)
scripts=(\
  "set-ramcloud-dependencies" \
  "set-ramcloud-compile" \
  "set-ramcloud-configure" \
  "set-ramcloud-install" \
  "set-zookeeper-service")

install_id=$(head -1 "${MACHINES}-INSTALL_ID.txt")
echo ">> WAIT FOR IT YOUNG BLOOD 👽 ID: $install_id"
for script in "${scripts[@]}"
do
  log_file="LOG-"$script"-"$experiment".log"
  cmd="./$script.sh $MACHINES $USER_NAME $PRIVATE_KEY &> $log_file"
  eval "$cmd"
  echo ">> FINISHED $script.sh LOG $log_file 🕶"
done

echo ">> WORK IS DONE 🥃"
exit 0
