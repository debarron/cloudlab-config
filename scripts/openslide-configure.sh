#!/bin/bash
cluster_machines="$1"
username="$2"
private_key="$3"

script="openslide-setup.sh"

# 1 Copy script to all nodes
echo -e ">> COPYING SCRIPT 🤖\n"
for machine in $(cat "$cluster_machines")
do
  scp -o "StrictHostKeyChecking no" -i "$private_key" "openslide-setup.sh" "$username@$machine":~ > /dev/null
  echo -e "\t + $machine ... OK ☕"
done
echo -e ">> SCRIPT FINISHED SUCCESSFULLY 🍻 \n"


# 2 Installing openslide in all nodes
bp_list=""
echo -e ">> INSTALLING SCRIPT 🤖\n"
for machine in $(cat "$cluster_machines")
do
  ssh -o "StrictHostKeyChecking no" -i "$private_key" "$username@$machine" "~/openslide-setup.sh" &> /dev/null &
  bp_list="$bp_list $!"

  echo -e "\t + $machine ... OK ☕"
done
echo -e ">> SCRIPT FINISHED SUCCESSFULLY 🍻 \n"

echo -e "\nWAITING FOR SETUP TO FINISH..\n"
TOTAL=$(cat $cluster_machines | wc -l | sed 's/ //')
DATE=$(date| tr '[:lower:]' '[:upper:]')
echo $DATE
echo -e "CHECKING PIDS STATUS.."
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
  echo "REMAINING: "$FINISHED"/"$TOTAL
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
