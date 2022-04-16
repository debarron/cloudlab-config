#!/bin/bash

# Let's configure a script based on the
# cluster-more-space-tf profile in CloudLab!
# It's amazing!

MACHINE_LIST="$1"
USER_NAME="$2"
PRIVATE_KEY="$3"

TENSORFLOW_SCRIPT="
cp -r /usr/local/anaconda/conda-home ~/.conda
cp -r /usr/local/anaconda/keras-home ~/.keras
cp /usr/local/anaconda/bashrc ~/.bashrc
source ~/.bashrc
exit 0
"

echo ">> Configuring TENSORFLOW in the cluster!"
for machine in $(cat "$MACHINE_LIST")
do
  ssh -o "StrictHostKeyChecking no" -i "$PRIVATE_KEY" "$USER_NAME"@"$machine" "$TENSORFLOW_SCRIPT"
  echo -e "\t + $machine ... OK ☕️"
done
echo -e ">> ALL SET! 🥃"
