#!/bin/bash
#=============================================================
# author:@Arun-Geore-Zachariah
# date:04/25/2020
# This script connects to all the nodes in the $MACHINES_FILE
# and grants r, w and x permissions to the node data directory
# The script was tested on Cloudlab's Clemson cluster.
#=============================================================

MACHINES_FILE="$1"
USR="$2"
KEY="$3"
data_dir="$4"

ssh_command="
sudo chown -R '$USR' '$data_dir'
"

echo ">> READY TO DISTRIBUTE COMMAND:"
echo -e "$ssh_command\n"

echo ">> NODES:"
for machine in $(cat $MACHINES_FILE) 
do
  ssh -o "StrictHostKeyChecking no" -i "$KEY"  $USR@$machine "$ssh_command"
  echo -e "\t + $machine ... OK ☕️"
done

echo -e ">> SCRIPT FINISHED SUCCESSFULLY 🍻"
