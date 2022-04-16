#!/bin/bash
MACHINES="$1"
USER_NAME="$2"
PRIVATE_KEY="$3"

echo ">> RAMCLOUD COMPILE"
install_id=$(head -1 "${MACHINES}-INSTALL_ID.txt")

echo -e "\t ## INSTALLING IN FIRST MACHINE WITH ID $install_id"
script="ramcloud-compile.sh"
first_node=$(head -1 $MACHINES)
scp -i "$PRIVATE_KEY" -o "StrictHostKeyChecking no" "$script" "$USER_NAME@$first_node:~" &> /dev/null
ssh -i "$PRIVATE_KEY" -o "StrictHostKeyChecking no" "$USER_NAME@$first_node" "~/$script $install_id" &> /dev/null

echo -e ">> SETUP FINISHED 🌮"
exit 0
