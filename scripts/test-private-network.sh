#!/bin/bash

MACHINES="$1"
USER="$2"
PRIVATE_KEY="$3"

script="
ifconfig | grep '10.10'
"

# inet addr:10.10.1.29  Bcast:10.10.1.255  Mask:255.255.255.0

for m in $(cat "$MACHINES")
do
  response=$(ssh -o "StrictHostKeyChecking no" -i "$PRIVATE_KEY" "$USER@$m" "$script")
  echo "$response"

done
