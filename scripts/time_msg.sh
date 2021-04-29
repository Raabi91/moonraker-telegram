#!/bin/bash

MYDIR_TIME=`dirname $0`
DIR_TIME="`cd $MYDIR_TIME/../; pwd`"

while true
do
. $DIR_TIME/multi_config.sh
. $DIR_TIME/example_config.sh
. $config_dir/telegram_config.sh
SECONDS=0

while [ $SECONDS -lt $time ]; do
   . $DIR_TIME/scripts/time_config.txt
      if [ "$time_msg" = "0" ]; then
        exit 0 
      fi
sleep 10
SECONDS=$(echo "$SECONDS + 10" | bc -l)
    :
done

. $DIR_TIME/scripts/time_config.txt

	if [ "$time_msg" = "1" ]; then
        if [ "$time_pause" = "0" ]; then
        sh $DIR_TIME/scripts/telegram.sh "5"
        SECONDS=0
        fi
    fi
    if [ "$time_msg" = "0" ]; then
        exit 0
    fi
done
