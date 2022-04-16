#!/bin/bash
#============================================================
# author:@debarron
# date:08/22/2018
# This script connects to all the nodes in the $MACHINES_FILE
# and generates the /etc/hostname file in each one of them.
# The script was tested on Cloudlab's Clemson cluster.
#============================================================

MACHINES_FILE="$1"
USR="$2"
KEY="$3"

ssh_command="
sudo su -c 'hostname > /etc/hostname'
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
