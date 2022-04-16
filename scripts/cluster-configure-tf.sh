#!/bin/bash

machines="$1"
user_name="$2"
priavate_key="$3"
data_dir="$4"

experiment=$(basename $machines)
scripts=(\
  "set-cluster-tensorflow-env" \
  "set-cluster-permissions" \
  "set-cluster-etchost" \
  "set-cluster-passwd" \
  "set-cluster-dependencies" \
  "set-cluster-iptables" \
  "set-cluster-hadoop" \
  "set-cluster-spark" \
  "set-cluster-bashrc")

# Generate a file to set a unique variable
install_id=$(date +"%s")
echo "$install_id" > "$machines-INSTALL_ID.txt"

echo ">> WAIT FOR IT YOUNG BLOOD 👽 ID: $install_id"
for script in "${scripts[@]}"
do
  log_file="LOG-"$script"-"$experiment".log"
  cmd="./$script.sh $machines $user_name $priavate_key $data_dir &> $log_file"
  
  eval "$cmd"
  echo ">> FINISHED $script.sh LOG $log_file 🕶"
done

echo ">> WORK IS DONE 🥃"
