#!/bin/bash
#Usage : copy_auth_key.sh <username>

for i in `cat cluster-machines.txt`
do
	echo $1
	ssh $1@$i "mv .ssh/authorized_keys.old .ssh/authorized_keys"
done
