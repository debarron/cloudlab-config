#!/bin/bash
MACHINES="$1"
USER_NAME="$2"
PRIVATE_KEY="$3"

install_id=$(head -1 "${MACHINES}-INSTALL_ID.txt")
copy_script="
grep RAMCLOUD \$HOME/.bashrc > \$HOME/envs.sh
chmod u+x \$HOME/envs.sh
. \$HOME/envs.sh
cp -r /proj/nosql-json-PG0/RAMCloud_$install_id \$RAMCLOUD_HOME
cd \$RAMCLOUD_HOME
make install
"

echo ">> RAMCLOUD INSTALL"
echo -e "\t ## COPYING AND INSTALLING RAMCLOUD TO ALL NODES"
bp_list=""
for machine in $(cat $MACHINES)
do
  ssh -i $PRIVATE_KEY -o "StrictHostKeyChecking no" "$USER_NAME@$machine" "$copy_script" &> /dev/null &
  bp_list="$bp_list $!"
  echo -e "\t + $machine ... OK ☕"
done

echo -e "\n\t ## WAITING FOR SETUP TO FINISH..\n"
TOTAL=$(cat $MACHINES | wc -l | sed 's/ //')
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

echo -e "\t ## REMOVING RAMCloud with ID $install_id FROM /proj/nosql-json-PG0"
ssh -i $PRIVATE_KEY -o "StrictHostKeyChecking no" "$USER_NAME"@$(head -1 $MACHINES) "rm -Rf /proj/nosql-json-PG0/RAMCloud_$install_id"

echo -e ">> SETUP FINISHED 🌮"
exit 0
